
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
		ТекстЗапроса = block_context["select"];
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПЕРВЫЕ 0", "ПЕРВЫЕ " + Строка(block_context["LIMIT"] + 1));
	
		param = block_c1_call_select_get_param(node, path, context, block_context);
		
		ИнициализироватьВыборкуНаСервере(ТекстЗапроса, param, block_context, Pagination);
	КонецЕсли;
КонецПроцедуры

Процедура ИнициализироватьВыборкуНаСервере(ТекстЗапроса, param, block_context, Pagination)
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Для каждого _param Из param Цикл
		ЗначениеПараметра = ПривестиAPI3ОбъектКСсылке(_param.Значение);
		Запрос.УстановитьПараметр(_param.Ключ, ЗначениеПараметра);
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
    ДочернийУзел = get_statement_node(node);
	Rows = Новый Массив;
	Pagination = Новый Структура("HasMore", Ложь);
	Пока Истина Цикл
		
		Если Не block_c1_call_select_init_block_context_for_item(node, path, context, block_context, Pagination) Тогда
			Прервать;
		КонецЕсли;
		
		block_check_step(context, block_context);
		
		Попытка
			ОбсчитатьЗаписьВыборки(ДочернийУзел, path, context, block_context, Rows);			
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
		
	КонецЦикла;
	Возврат Новый Структура("Rows, Pagination", Rows, Pagination);	
КонецФункции
// BSLLS:DuplicateStringLiteral-on

