
// Функция block_saby_write_document_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Соответствие - Результат выполения функции
//
//DynamicDirective
Функция block_saby_write_document_calc_value(block_type, node, path, context, block_context) 
	Если has_prop(block_context, "Результат") Тогда
		Возврат get_prop(block_context, "Результат"); 
	КонецЕсли;
	QueryId = get_prop(block_context, "AsyncRequest"); 
	Если QueryId = Неопределено Тогда
		Попытка
			multithread_mode = get_prop(context, "multithread_mode", ЛОЖЬ);
			doc = get_prop(block_context, "doc");
			Результат = ТранспортИнтеграции.local_helper_write_document(context.params, doc, multithread_mode);
		Исключение   
			ИнфОбОшибке = ИнформацияОбОшибке();
			ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
			Если Не ЭтоСлужебнаяОшибкаБлока(ОшибкаСтруктура.type) Тогда 
				ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, , , , add_block_to_dump(block_context));
			КонецЕсли;	
			Если ОшибкаСтруктура.type = "AsyncRequest" Тогда
				set_prop(ОшибкаСтруктура.dump, block_context, "QueryId", "AsyncRequest", Неопределено);
			КонецЕсли;
			ВызватьИсключение ИнфОбОшибке.Описание; 	
		КонецПопытки;
	Иначе 
		responce = ТранспортИнтеграции.local_helper_exec_method_process_responce_async(context.params, QueryId);
		Результат = ТранспортИнтеграции.local_helper_write_document_process_responce(responce);
		block_context.Удалить("AsyncRequest");
	КонецЕсли;
	block_context.Вставить("Результат", Результат);
	Возврат Результат;		
КонецФункции	
