
// Функция block_saby_edo_start_write_document_get_value
//
// Параметры:
// block_context - Соответствие - Контекст текущего выполняемого блока
// context - Соответствие - Контекст исполняемого блока
// doc - Соответствие - doc
// multithread_mode - Булево - Признак многопоточности
//
// Возвращаемое значение:
//  Соответствие - Результат выполения функции
//
//DynamicDirective
Функция block_saby_edo_start_write_document_get_value(block_context, context, doc, multithread_mode)
	Если has_prop(block_context,"Документ") Тогда
		Возврат get_prop(block_context,"Документ"); 
	КонецЕсли;	
	QueryId = get_prop(block_context,"AsyncRequest"); 
	Если QueryId = Неопределено Тогда  		
		Попытка
			Результат = ТранспортИнтеграции.local_helper_write_document(context.params, doc, multithread_mode, 120);
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();
			ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
			Если ЭтоСлужебнаяОшибкаБлока(ОшибкаСтруктура.type) Тогда 
				Если ОшибкаСтруктура.type = "AsyncRequest" Тогда
					set_prop(ОшибкаСтруктура.dump,block_context,"QueryId","AsyncRequest",Неопределено);
				КонецЕсли;
				ВызватьИсключение ИнфОбОшибке.Описание; 
			КонецЕсли;
			Возврат Ложь;
		КонецПопытки;
	Иначе 
		Попытка
			responce = ТранспортИнтеграции.local_helper_exec_method_process_responce_async(context.params, QueryId);
			Результат = ТранспортИнтеграции.local_helper_write_document_process_responce(responce);
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();
			ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
			Результат = Ложь;
	    КонецПопытки;	
		block_context.Удалить("AsyncRequest");
	КонецЕсли;
	block_context.Вставить("Документ", Результат);
    Возврат Результат;
КонецФункции   

// Функция block_saby_edo_start_prepare_result_get_value
//
// Параметры:
// block_context - Соответствие - Контекст текущего выполняемого блока
// context - Соответствие - Контекст исполняемого блока
// execute_action - Соответствие - Доп параметры функции
// multithread_mode - Булево - Признак многопоточного выполнения
//
// Возвращаемое значение:
//  Соответствие - Результат выполения функции
//
//DynamicDirective
Функция block_saby_edo_start_prepare_result_get_value(block_context, context, execute_action, multithread_mode)
	Если has_prop(block_context, "prepare_result") Тогда
		Возврат get_prop(block_context, "prepare_result"); 
	КонецЕсли;	
	QueryId = get_prop(block_context, "AsyncRequest"); 
	Если QueryId = Неопределено Тогда  		
		ВремяОжиданияСекунд = 120;
		Попытка
			prepare_result = ТранспортИнтеграции.local_helper_prepare_action(
				context.params,
				execute_action,
				multithread_mode,
				ВремяОжиданияСекунд);
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();
			ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
			Если ЭтоСлужебнаяОшибкаБлока(ОшибкаСтруктура.type) Тогда 
				Если ОшибкаСтруктура.type = "AsyncRequest" Тогда
					set_prop(ОшибкаСтруктура.dump, block_context, "QueryId", "AsyncRequest", Неопределено);
				КонецЕсли;
				ВызватьИсключение ИнфОбОшибке.Описание; 
			КонецЕсли;
			Возврат Ложь;
		КонецПопытки;
	Иначе 
		Попытка
			responce = ТранспортИнтеграции.local_helper_exec_method_process_responce_async(context.params, QueryId);
			prepare_result = ТранспортИнтеграции.local_helper_prepare_action_process_responce(responce);
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();
			ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
			prepare_result = Ложь;
	    КонецПопытки;			
		block_context.Удалить("AsyncRequest");
	КонецЕсли;
	block_context.Вставить("prepare_result", prepare_result);
    Возврат prepare_result;
КонецФункции

// Функция block_saby_edo_start_execute_action_get_value
//
// Параметры:
// block_context - Соответствие - Контекст текущего выполняемого блока
// context - Соответствие - Контекст исполняемого блока
// execute_action - Соответствие - Доп параметры функции
// multithread_mode - Булево - Признак многопоточного выполнения
//
// Возвращаемое значение:
//  Соответствие - Результат выполения функции
//
//DynamicDirective
Функция block_saby_edo_start_execute_action_get_value(block_context, context, execute_action, multithread_mode)
	Если has_prop(block_context, "execute_action") Тогда
		Возврат get_prop(block_context, "execute_action"); 
	КонецЕсли;	
	QueryId = get_prop(block_context,"AsyncRequest"); 
	Если QueryId = Неопределено Тогда  		
		Попытка
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS:FunctionOutParameter-off
			execute_action = ТранспортИнтеграции.local_helper_execute_action(context.params, execute_action, multithread_mode, 120);
// BSLLS:FunctionOutParameter-on
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();
			ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
			Если ЭтоСлужебнаяОшибкаБлока(ОшибкаСтруктура.type) Тогда 
				Если ОшибкаСтруктура.type = "AsyncRequest" Тогда
					set_prop(ОшибкаСтруктура.dump, block_context, "QueryId", "AsyncRequest", Неопределено);
				КонецЕсли;
				ВызватьИсключение ИнфОбОшибке.Описание; 
			КонецЕсли;
			Возврат Ложь;
		КонецПопытки;
	Иначе 
		Попытка
			responce = ТранспортИнтеграции.local_helper_exec_method_process_responce_async(context.params, QueryId);
			execute_action = ТранспортИнтеграции.local_helper_execute_action_process_responce(responce);
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();
			ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
			execute_action = Ложь;
	    КонецПопытки;	
		block_context.Удалить("AsyncRequest");
	КонецЕсли;
	block_context.Вставить("execute_action", execute_action);
    Возврат execute_action;
КонецФункции

// Функция block_saby_edo_start_calc_value
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
Функция block_saby_edo_start_calc_value(block_type, node, path, context, block_context)
	multithread_mode = get_prop(context,"multithread_mode", Ложь); 
	Документ = get_prop(block_context, "doc");
	Состояние = get_prop(Документ, "Состояние");
	КодСостояния = get_prop(Состояние, "Код");
	Если ЗначениеЗаполнено(КодСостояния) И КодСостояния <> "0" Тогда
		doc = Новый Структура("Идентификатор, Редакция, ДопПоля", Документ["Идентификатор"], Новый Массив, "Расширение");
		НовыйИдентификатор = Строка(Новый УникальныйИдентификатор());
		doc["Редакция"].Добавить(
			Новый Структура("ПримечаниеИС, Идентификатор",
				Документ["Тип"] + ":" + НовыйИдентификатор,
				НовыйИдентификатор));
		Документ = block_saby_edo_start_write_document_get_value(block_context, context, doc, multithread_mode)	
	КонецЕсли;	                                         
	
	Если ТипЗнч(Документ["Этап"]) = Тип("Массив") Тогда 
		execute_action = Новый Структура("Идентификатор, Этап", Документ["Идентификатор"], Документ["Этап"][0]);
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
	prepare_result = block_saby_edo_start_prepare_result_get_value(block_context, context, execute_action, multithread_mode);
	
	Если prepare_result = Ложь Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Возврат block_saby_edo_start_execute_action_get_value(block_context, context, execute_action, multithread_mode);
КонецФункции
