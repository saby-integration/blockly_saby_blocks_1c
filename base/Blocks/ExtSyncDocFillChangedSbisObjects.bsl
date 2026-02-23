
// Функция ОжиданиеЗавершенияОперацииPrepareLRS
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Соответствие - Результат выполения функции
//
//DynamicDirective
Функция ОжиданиеЗавершенияОперацииPrepareLRS(context, block_context)
	Пока Истина Цикл
		result = block_extsyncdoc_run_extsyncdoc_read_saby(context, block_context);
		ДопПарамерыПрогресса = ПрогрессВыполнения(result);
		ОбъектовПроигнорировано = get_prop(result, "CountIgnored", 0);
		СтрокаПроигнорировано = "";
		Если ОбъектовПроигнорировано <> 0 Тогда
			СтрокаПроигнорировано = ", проигнорировано " + ОбъектовПроигнорировано;
		КонецЕсли;
		ТекстСтатуса = "Обработано " + result["CountConfirmed"] + "/" + result["CountObjects"]
			+ СтрокаПроигнорировано + ", ошибок " + result["CountErrors"];
		Status = result["Status"];
		Если Status = 10 Или Status = 20 Тогда
			//Успешное завершение
			СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
			ТранспортИнтеграции.local_helper_pause(1);
			// Если не поставить паузу, то сообщение может не успеть долететь и обновить строку состояния выгрузки.
			Прервать;   
		ИначеЕсли Status = 50 Тогда	
			СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
			ТранспортИнтеграции.local_helper_pause(1);
			// Если не поставить паузу, то сообщение может не успеть долететь и обновить строку состояния выгрузки.
			Прервать;   
		Иначе
			Если Status = 100 Тогда
				//Завершено с ошибкой
				СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
				ТранспортИнтеграции.local_helper_pause(1);
				// Если не поставить паузу, то сообщение может не успеть долететь и обновить строку состояния выгрузки.
				Прервать;
			КонецЕсли;
		КонецЕсли;
		СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
		ТранспортИнтеграции.local_helper_pause(1);	
	КонецЦикла;
	Возврат result;
КонецФункции

// Функция block_extsyncdoc_extsyncdoc_fillchangedsbisobjects_calc_value
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
Функция block_extsyncdoc_extsyncdoc_fillchangedsbisobjects_calc_value(block_type, node, path, context, block_context) Экспорт  
	connection_uuid = "";
	context.operation.Свойство("connection_uuid", connection_uuid);
	extsyncdoc_uuid = ТранспортИнтеграции.local_helper_extsyncdoc_fillchangedsbisobjects_lrs(context.params, connection_uuid);
   	context.operation.Вставить("operation_uuid", extsyncdoc_uuid);
	result = ОжиданиеЗавершенияОперацииPrepareLRS(context, block_context);
	Возврат result; 
КонецФункции
