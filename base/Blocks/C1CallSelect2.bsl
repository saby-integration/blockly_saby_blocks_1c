
функция ПолучитьЗаписьВыборки(local_context)
	Если local_context["_Выборка"].Следующий() Тогда
		Возврат ЗаписьВыборкиВСтруктуру(local_context["_Выборка"], local_context["_Колонки"]);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
конецфункции

// BSLLS:DuplicateStringLiteral-off
// BSLLS:CognitiveComplexity-off

Процедура ИнициализироватьВыборку(node, path, context, block_context, Pagination, local_context)
	Если Не local_context.Свойство("_Выборка") Тогда
		ТекстЗапроса = block_context["SELECT"];
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПЕРВЫЕ 0", "ПЕРВЫЕ " + Строка(block_context["LIMIT"] + 1));
	
		Если Не block_context.Свойство("SELECT_PARAMS") Тогда
			block_context.Вставить("SELECT_PARAMS", block_c1_call_select_get_param(node, path, context, block_context));
		КонецЕсли;
		
		ТекстЗапросаСоСтатусами = ДополнитьЗапросСтатусамиСаби(ТекстЗапроса);
		
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапросаСоСтатусами;
		block_context["SELECT"] = ТекстЗапросаСоСтатусами;
		
		Для каждого _param Из block_context["SELECT_PARAMS"] Цикл
			ЗначениеПараметра = ПривестиAPI3ОбъектКСсылке(_param.Значение);
			Запрос.УстановитьПараметр(_param.Ключ, ЗначениеПараметра);
			block_context["SELECT_PARAMS"].Вставить(_param.Ключ, ЗначениеПараметра);
			ПараметрНеЗаполнено = Не ЗначениеЗаполнено(_param.Значение);
			Запрос.УстановитьПараметр(_param.Ключ + "НеЗаполнено", ПараметрНеЗаполнено);
			block_context["SELECT_PARAMS"].Вставить(_param.Ключ + "НеЗаполнено", ПараметрНеЗаполнено);
		КонецЦикла;
		
		block_check_step(context, block_context);
		
		РезультатЗапроса = Запрос.Выполнить();
		local_context.Вставить("_Выборка", РезультатЗапроса.Выбрать());
		local_context.Вставить("_Колонки", РезультатЗапроса.Колонки);
		Если local_context["_Выборка"].Количество() > block_context["LIMIT"] И block_context["LIMIT"] <> 0 Тогда
			HasMore = Истина;
		Иначе
			HasMore = Ложь;
		КонецЕсли;
		Pagination.Вставить("HasMore", HasMore);
		Если block_context["INDEX"] > block_context["SKIP"] Тогда
			сч = 0;
			Пока local_context["_Выборка"].Следующий() Цикл
				сч = сч + 1;
				Если сч = block_context["INDEX"] Тогда
					Возврат;
				КонецЕсли;
			КонецЦикла;			
		КонецЕсли;
		
		Если block_context["SKIP"] > 0 Тогда
			Пока local_context["_Выборка"].Следующий() Цикл
				block_context["INDEX"] = block_context["INDEX"] + 1;
				Если block_context["INDEX"] = block_context["SKIP"] Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
// BSLLS:CognitiveComplexity-on

Функция block_c1_call_select2_execute(block_type, node, path, context, block_context)
	local_context = Новый Структура;
	workspace_find_fields(node, block_context);
	workspace_execute_inputs(node, path, context, block_context);
    Pagination = Новый Структура("HasMore", Ложь);
	begin = ДатаВМиллисекундах();
	Title = "Выполнение запроса в ИС";
	Subtitle = get_prop(block_context, "__id");
	workspace_find_fields(node, block_context);
	workspace_execute_inputs(node, path, context, block_context);
    ДочернийУзел = get_statement_node(node);
	Rows = Новый Массив;
	Pagination = Новый Структура("HasMore", Ложь); 
	Попытка
        c1_call_select2_execute(block_type, node, path, context, block_context, Pagination, local_context);
	Исключение   
	    ИнфОбОшибке = ИнформацияОбОшибке();
		ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
		Если ЭтоСлужебнаяОшибкаБлока(ОшибкаСтруктура.type) Тогда
			ВызватьИсключение ИнфОбОшибке.Описание; // (исходное исключение)
		КонецЕсли;
        Data = Новый Структура;
		Data.Вставить("message", get_prop(ОшибкаСтруктура, "message"));
		Data.Вставить("detail", get_prop(ОшибкаСтруктура, "detail"));
        end = ДатаВМиллисекундах();
		block_saby_execute_action_write_esoaction(begin, end, Title, Subtitle, Data, , 100);		
		ВызватьИсключение ИнфОбОшибке.Описание;	
	КонецПопытки;
	end = ДатаВМиллисекундах();
	block_saby_execute_action_write_esoaction(begin, end, Title, Subtitle);			
	Возврат Новый Структура("Rows, Pagination", block_context["ROWS"], Pagination);    

КонецФункции

Процедура c1_call_select2_execute(block_type, node, path, context, block_context, Pagination, local_context)
	Пока Истина Цикл
		
		Если Не block_c1_call_select_init_block_context_for_item(node, path, context, block_context, Pagination, local_context) Тогда
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
		Если block_context["INDEX"] >= block_context["LIMIT"] И block_context["LIMIT"] <> 0 Тогда
			Прервать;
		КонецЕсли;
		

		block_context.Вставить("__child", Неопределено);
		context_set_step(block_context.__id);
		block_check_step(context, block_context);
		
	КонецЦикла;	
КонецПроцедуры	

Функция block_c1_call_select_init_block_context_for_item(node, path, context, block_context, Pagination, local_context)
	Если Не block_context.Свойство("INDEX") Тогда
		block_context.Вставить("INDEX", 0);
		block_context.Вставить("ROWS", Новый Массив);
		Если get_prop(block_context, "pagination") <> Неопределено Тогда
			page = block_context["pagination"]["Page"];
			pageSize = block_context["pagination"]["PageSize"];
		Иначе
			page = 0;
			pageSize = 0;
		КонецЕсли;
		block_context.Вставить("SKIP", page*pageSize );
 		block_context.Вставить("LIMIT", page*pageSize + pageSize);
	КонецЕсли;
	
	Если Не block_context.Свойство("ROW") Тогда
		ИнициализироватьВыборку(node, path, context, block_context, Pagination, local_context);
		block_context.Вставить("ROW", ПолучитьЗаписьВыборки(local_context));
		// когда кончится прервать
		Если block_context["ROW"] = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		block_set_variable(context, block_context.VAR, block_context["ROW"]);
	КонецЕсли;
	Возврат Истина
КонецФункции

// BSLLS:DuplicateStringLiteral-on

