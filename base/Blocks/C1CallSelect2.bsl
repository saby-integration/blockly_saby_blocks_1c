
функция ПолучитьЗаписьВыборки(block_context)
	Если block_context["_Выборка"].Следующий() Тогда
		Возврат ЗаписьВыборкиВСтруктуру(block_context["_Выборка"], block_context["_Колонки"]);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
конецфункции

// BSLLS:DuplicateStringLiteral-off

Процедура ИнициализироватьВыборку(node, path, context, block_context, Pagination)
	Если Не block_context.Свойство("_Выборка") Тогда
		ТекстЗапроса = block_context["select"];
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПЕРВЫЕ 0", "ПЕРВЫЕ " + Строка(block_context["LIMIT"] + 1));
	
		param = block_c1_call_select_get_param(node, path, context, block_context);
		
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапроса;
		Для каждого _param Из param Цикл
			ЗначениеПараметра = ПривестиAPI3ОбъектКСсылке(_param.Значение);
			Запрос.УстановитьПараметр(_param.Ключ, ЗначениеПараметра);
		КонецЦикла;
		РезультатЗапроса = Запрос.Выполнить();
		block_context.Вставить("_Выборка", РезультатЗапроса.Выбрать());
		block_context.Вставить("_Колонки", РезультатЗапроса.Колонки);
		Если block_context["_Выборка"].Количество() > block_context["LIMIT"] Тогда
			HasMore = Истина;
		Иначе
			HasMore = Ложь;
		КонецЕсли;
		Pagination.Вставить("HasMore", HasMore);
		Если block_context["SKIP"] > 0 Тогда
			Пока block_context["_Выборка"].Следующий() Цикл
				block_context["INDEX"] = block_context["INDEX"] + 1;
				Если block_context["INDEX"] = block_context["SKIP"] Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры	

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
		Если block_context["INDEX"] >= block_context["LIMIT"] Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	Возврат Новый Структура("Rows, Pagination", Rows, Pagination);	
КонецФункции
// BSLLS:DuplicateStringLiteral-on

