
функция ПолучитьЗаписьВыборки(block_context)
	Если block_context["_Выборка"].Количество() > block_context["INDEX"] Тогда
		Возврат block_context["_Выборка"][block_context["INDEX"]];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
конецфункции

// BSLLS:DuplicateStringLiteral-off
//DynamicDirective

Процедура ИнициализироватьВыборку(node, path, context, block_context, Pagination)
	Если Не block_context.Свойство("_Выборка") Тогда
		ТекстЗапроса = block_context["SELECT"];
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПЕРВЫЕ 0", "ПЕРВЫЕ " + Строка(block_context["LIMIT"] + 1));
	    Если Не block_context.Свойство("SELECT_PARAMS") Тогда
			block_context.Вставить("SELECT_PARAMS", block_c1_call_select_get_param(node, path, context, block_context));
		КонецЕсли;		
		ТекстЗапросаСоСтатусами = ДополнитьЗапросСтатусамиСаби(ТекстЗапроса, context.params.Contour);
		block_context["SELECT"] = ТекстЗапросаСоСтатусами;
		ИнициализироватьВыборкуНаСервере(ТекстЗапросаСоСтатусами, block_context, Pagination);
	КонецЕсли;
	block_check_step(context, block_context);
КонецПроцедуры

Процедура ИнициализироватьВыборкуНаСервере(ТекстЗапроса, block_context, Pagination)
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Для каждого _param Из block_context["SELECT_PARAMS"] Цикл
		ЗначениеПараметра = ПривестиAPI3ОбъектКСсылке(_param.Значение);
		Запрос.УстановитьПараметр(_param.Ключ, ЗначениеПараметра);
		block_context["SELECT_PARAMS"].Вставить(_param.Ключ, ЗначениеПараметра);
		ПараметрНеЗаполнено = Не ЗначениеЗаполнено(_param.Значение);
		Запрос.УстановитьПараметр(_param.Ключ + "НеЗаполнено", ПараметрНеЗаполнено);
		block_context["SELECT_PARAMS"].Вставить(_param.Ключ + "НеЗаполнено", ПараметрНеЗаполнено);
	КонецЦикла;
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	_Колонки = РезультатЗапроса.Колонки;
	Если Выборка.Количество() > block_context["LIMIT"] Тогда
		HasMore = Истина;
	Иначе
		HasMore = Ложь;
	КонецЕсли;
	Pagination.Вставить("HasMore", HasMore);
	_Выборка = Новый Массив;

	Инд = 0;
	Пока Выборка.Следующий() Цикл
		Инд = Инд + 1;
		Если Инд > block_context["SKIP"] Тогда
			Если Инд > block_context["LIMIT"] Тогда
				Прервать;
			КонецЕсли;
			_Выборка.Добавить(ЗаписьВыборкиВСтруктуру(Выборка, _Колонки));
		КонецЕсли;
	КонецЦикла;

	block_context.Вставить("_Выборка", _Выборка);
КонецПроцедуры

//DynamicDirective

Функция block_c1_call_select2_execute(block_type, node, path, context, block_context)
	workspace_find_fields(node, block_context);
	workspace_execute_inputs(node, path, context, block_context);
    Pagination = Новый Структура("HasMore", Ложь);
	c1_call_select2_execute(block_type, node, path, context, block_context, Pagination, Новый Структура);
	Возврат Новый Структура("Rows, Pagination", block_context["ROWS"], Pagination);	
КонецФункции

//DynamicDirective

Процедура c1_call_select2_execute(block_type, node, path, context, block_context, Pagination, local_context)
	Пока Истина Цикл
		
		Если Не block_c1_call_select_init_block_context_for_item(node, path, context, block_context, Pagination) Тогда
			Прервать;
		КонецЕсли;
		
		Попытка
			ДочернийУзел = get_statement_node(node);
			ОбсчитатьЗаписьВыборки(ДочернийУзел, path, context, block_context);			
		Исключение   
			ИнфОбОшибке = ИнформацияОбОшибке(); 
			ПрерватьЦикл = Ложь;
			ОбработатьОшибкуЦиклическогоБлока(block_type, block_context, ИнфОбОшибке, ПрерватьЦикл); 
			Если ПрерватьЦикл Тогда
				Прервать;
			КонецЕсли;	
		КонецПопытки;
		block_context.Удалить("ROW");
		
		block_context["INDEX"] = block_context["INDEX"] + 1;
		
		block_context.Вставить("__child", Неопределено);
		context_set_step(block_context.__id);
		block_check_step(context, block_context);
		
	КонецЦикла;	
КонецПроцедуры	

//DynamicDirective

Функция block_c1_call_select_init_block_context_for_item(node, path, context, block_context, Pagination)
	Если Не block_context.Свойство("INDEX") Тогда
		block_context.Вставить("INDEX", 0);
		block_context.Вставить("ROWS", Новый Массив);
		page = block_context["pagination"]["Page"];
		pageSize = block_context["pagination"]["PageSize"];
		block_context.Вставить("SKIP", page*pageSize );
 		block_context.Вставить("LIMIT", page*pageSize + pageSize);
	КонецЕсли;
	
	Если Не block_context.Свойство("ROW") Тогда
		ИнициализироватьВыборку(node, path, context, block_context, Pagination);
		block_context.Вставить("ROW", ПолучитьЗаписьВыборки(block_context));
		// когда кончится прервать
		Если block_context["ROW"] = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		block_set_variable(context, block_context.VAR, block_context["ROW"]);
	КонецЕсли;
	Возврат Истина
КонецФункции

// BSLLS:DuplicateStringLiteral-on

