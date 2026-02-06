
// Функция block_extsyncdoc_run_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
//DynamicDirective
Функция block_extsyncdoc_run_calc_value(block_type, node, path, context, block_context)
	prepare_counter = Неопределено;
	Если НЕ block_context.Свойство("prepare_counter", prepare_counter) Тогда
		block_context.Вставить("prepare_counter", 0);
	КонецЕсли;
	operation = get_prop(context, "operation", Неопределено);
	connection_uuid = get_prop(operation, "connection_uuid", Неопределено); 

	Если context.report.objects_to_write.Количество() > 0 Тогда 
		direction = get_prop(context.report, "direction", 1);
		extsyncdoc_uuid = get_prop(context.report, "uid", ""); 	
		Робот = get_prop(context.operation, "isRobot", Ложь);
		Data = ТранспортИнтеграции.local_helper_system_info(Робот);
		ПараметрыВызова = Новый Структура("Direction, Data", direction, Data);
		
		Если Не ПустаяСтрока(extsyncdoc_uuid) Тогда
			ПараметрыВызова.Вставить("Uuid", extsyncdoc_uuid);
		КонецЕсли; 
		ПолученыйUuid = ТранспортИнтеграции.local_helper_extsyncdoc_write(
						context.params,
						connection_uuid,
						ПараметрыВЫзова,
						context.report.objects_to_write);
		Если Не ПустаяСтрока(ПолученыйUuid) и ПолученыйUuid <> extsyncdoc_uuid Тогда
			context.operation.Вставить("operation_uuid", ПолученыйUuid);
		КонецЕсли;
		context.report.objects_to_write.Очистить();
		context.report.new = Ложь;
	КонецЕсли;
	
	__deferred = Неопределено;
	Если НЕ block_context.Свойство("__deferred", __deferred) Тогда
		block_context.Вставить("__deferred", Новый Структура());
	КонецЕсли;
	
	_CountObjects = "CountObjects";
	Попытка
		result = block_extsyncdoc_run_extsyncdoc_read_saby(context, block_context);
		Если result["Direction"] = 1 Тогда //Из 1С в СБИС 
			result = block_extsyncdoc_run_extsyncdoc_prepare_is(context, block_context);
			result = block_extsyncdoc_run_extsyncdoc_execute_saby_lrs2(context, block_context);
		ИначеЕсли result["Direction"] = 2 или result["Direction"] = 0 Тогда //Из СБИС в 1С
			//result = block_extsyncdoc_run_process_commands_result(context, block_context);
			result = block_extsyncdoc_run_extsyncdoc_prepare_saby(context, block_context);
			result = block_extsyncdoc_run_extsyncdoc_execute_is(context, block_context);
		// Сохраняем идентичность со структурой кода в Питоне
		// BSLLS:EmptyCodeBlock-off
		Иначе
			// ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,add_block_to_dump(block_context));
		КонецЕсли;
		// BSLLS:EmptyCodeBlock-on
	Исключение
		ИнфОбОшибке	= ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, , , , add_block_to_dump(block_context));
	КонецПопытки;
	
	result = block_extsyncdoc_run_extsyncdoc_read_saby(context, block_context);
	ДопПарамерыПрогресса = ПрогрессВыполнения(result);
	ОбъектовПроигнорировано = get_prop(result, "CountIgnored", 0);
	СтрокаПроигнорировано = "";
	Если ОбъектовПроигнорировано <> 0 Тогда
		СтрокаПроигнорировано = ", проигнорировано " + ОбъектовПроигнорировано;
	КонецЕсли;
	ТекстСтатуса = "Обработано " + result["CountConfirmed"] + "/" + result[_CountObjects]
		+ СтрокаПроигнорировано + ", ошибок " + result["CountErrors"];
	СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
    ТранспортИнтеграции.local_helper_pause(1);
	
	operation = get_prop(context, "operation", Неопределено);
	connection_uuid = get_prop(operation, "connection_uuid", Неопределено); 

	ПланыОбменаContext = get_prop(context, "ПланыОбмена", Новый Соответствие);
	УзелПланаОбмена = get_prop(ПланыОбменаContext, connection_uuid, Неопределено);
	Если УзелПланаОбмена <> Неопределено Тогда
		УдаляемОбъектыИзПланаОбмена(УзелПланаОбмена, Неопределено);
		ПланыОбменаContext.Удалить(connection_uuid);
		context.Вставить("ПланыОбмена", ПланыОбменаContext);
	КонецЕсли;		
	
	Возврат result
КонецФункции

// Функция block_extsyncdoc_run_command_syncdocfill
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
// ext_sync_obj - Соответствие - ext_sync_obj
// objects - Соответствие - objects
//
// Возвращаемое значение:
//  Строка - Результат выполения функции
//
//DynamicDirective
Функция block_extsyncdoc_run_command_syncdocfill(context, block_context, ext_sync_obj, objects)
	Если ЗначениеЗаполнено(ext_sync_obj["ini_name"]) Тогда
		obj = ?(ext_sync_obj.Получить("Context") = Неопределено, Новый Соответствие(), ext_sync_obj["Context"]);
		data_is	= Новый Соответствие;
		Для каждого _filter из ext_sync_obj["filter"] Цикл
			data_is.Вставить(_filter.Ключ, _filter.Значение);	
		КонецЦикла;
		ИмяОбъекта = ext_sync_obj["ini_name"];
		data_is.Вставить("ini_name", ИмяОбъекта);
		ext_sync_obj.Вставить("Type", ИмяОбъекта);
			
		obj.Вставить("object", data_is);
		result = block_extsyncdoc_run_add_command_calc_ini(context, block_context, "fill", ext_sync_obj, obj);
		block_extsyncdoc_run_process_command_result_read(context, block_context,
			ext_sync_obj, result, objects); // block_context.objects	
	Иначе
		Возврат "";	
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

// Функция block_extsyncdoc_run_command_processpredefineobject
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
// ext_sync_obj - Соответствие - ext_sync_obj
//
// Возвращаемое значение:
//  Неопределено - Результат выполения функции
//
//DynamicDirective
Функция block_extsyncdoc_run_command_processpredefineobject(context, block_context, ext_sync_obj)
	_Data = "Data";
	_Type = "Type";
	obj = ?(ext_sync_obj.Получить("Context") = Неопределено, Новый Соответствие(), ext_sync_obj["Context"]);
	obj.Вставить("ИдИС", ext_sync_obj.Получить("ClientId"));
	obj.Вставить("ИмяСБИС", ext_sync_obj.Получить(_Data).Получить("ini_name")); 
	data_is = ext_sync_obj.Получить(_Data).Получить("data_is");
	Если data_is = Неопределено Тогда
		data_is	= Новый Соответствие;
		data_is.Вставить("ИдИС", ext_sync_obj.Получить("ClientId"));
	КонецЕсли;
	obj.Вставить("object", data_is);
	
	result = block_extsyncdoc_run_add_command_calc_ini(
		context,
		block_context,
		"predefine",
		ext_sync_obj, obj);
	Если result["Status"] = "complete" Тогда
		ТранспортИнтеграции.ЗаписатьМаппингПредопределенных(context, result);  
	Иначе
		Если result["Status"] = "error" Тогда
			ВызватьИсключение NewExtExceptionСтрока(, "Не удалось загрузить предопределенные данные - "
				+ ext_sync_obj[_Type], "command_processpredefineobject");
		КонецЕсли;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

// Функция block_extsyncdoc_run_command_getobject
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
// ext_sync_obj - Соответствие - ext_sync_obj
// objects - Соответствие - objects
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
//DynamicDirective
Функция block_extsyncdoc_run_command_getobject(context, block_context, ext_sync_obj, objects)
	_Data = "Data";

	obj = ?(get_prop(ext_sync_obj,"Context") = Неопределено, Новый Соответствие(), get_prop(ext_sync_obj,"Context"));
	obj.Вставить("ИдИС", get_prop(ext_sync_obj, "ClientId"));
	obj.Вставить("ИмяСБИС", get_prop(ext_sync_obj, "SbisType")); 
	data_is = get_prop(get_prop(ext_sync_obj, _Data), "data_is");
	Если data_is = Неопределено Тогда
		Если get_prop(ext_sync_obj, "ClientType") <> Неопределено Тогда
			Type = "ClientType";
		Иначе
			Type = "Type";
		КонецЕсли;	
		type_list = СтрРазделить82(get_prop(ext_sync_obj, Type), ".");
		data_is	= Новый Соответствие;
		data_is.Вставить("ИдИС", get_prop(ext_sync_obj, "ClientId"));
		data_is.Вставить("ТипИС", type_list[0]);
		data_is.Вставить("ИмяИС", type_list[1]);
		data_is.Вставить("Регламент", get_prop(get_prop(ext_sync_obj, _Data), "Регламент"));
		ЗначениеДата = get_prop(get_prop(ext_sync_obj, "Data"), "ПроизвольноеНазваниеРегламента");
		data_is.Вставить("ПроизвольноеНазваниеРегламента", ЗначениеДата);
		data_is.Вставить("ini_name", get_prop(get_prop(ext_sync_obj, _Data), "ini_name"));
		data_is.Вставить("_print_forms", get_prop(get_prop(ext_sync_obj, _Data), "_print_forms")); // TODO убрать костыли
	КонецЕсли;
	obj.Вставить("object", data_is);
	endpoint=get_prop(get_prop(ext_sync_obj, _Data, Новый Структура), "endpoint", Неопределено);
	
	begin = ДатаВМиллисекундах();
	result = block_extsyncdoc_run_add_command_calc_ini(context, block_context, "read", ext_sync_obj, obj, endpoint);
	end = ДатаВМиллисекундах();
	action = Новый Структура("Begin, End, Title", begin, end, "Чтение объекта из ИС");
	include_actions = get_prop(result, "Actions");
	Если ЗначениеЗаполнено(include_actions) Тогда
		action.Вставить("Data", Новый Структура("Actions", get_prop(result, "Actions")));
	КонецЕсли;	
	block_extsyncdoc_run_process_command_result_read(context, block_context,
		ext_sync_obj, result, objects, action); // block_context.objects
	
	Возврат Неопределено;
КонецФункции

// Функция block_extsyncdoc_run_command_update
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
// ext_sync_obj - Соответствие - ext_sync_obj
// objects - Соответствие - objects
//
// Возвращаемое значение:
//  Неопределено - Результат выполения функции
//
//DynamicDirective
Функция block_extsyncdoc_run_command_update(context, block_context, ext_sync_obj, objects)
	_Data = "Data";
	_DataSm = "data";

	Попытка
	// Сохраняем идентичность со структурой кода в Питоне
	// BSLLS:UnusedLocalVariable-off
		obj = ext_sync_obj[_Data][_DataSm];
	// BSLLS:UnusedLocalVariable-on
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Объект не содержит необходимый параметр"));
	КонецПопытки;
	begin = ДатаВМиллисекундах();
	result = block_extsyncdoc_run_add_command_calc_ini(context, block_context,
		"update", ext_sync_obj, ext_sync_obj[_Data][_DataSm]);
	end = ДатаВМиллисекундах();
	action = Новый Структура("Begin, End, Title", begin, end, "Запись объекта в ИС");
	include_actions = get_prop(result, "Actions");
	Если ЗначениеЗаполнено(include_actions) Тогда
		action.Вставить("Data", Новый Структура("Actions", get_prop(result, "Actions")));
	КонецЕсли;
	block_extsyncdoc_run_process_command_result_update(context, block_context,
		ext_sync_obj, result, objects, action); // block_context.objects
	Возврат Неопределено;
КонецФункции

// BSLLS:NumberOfValuesInStructureConstructor-off
// BSLLS:NestedConstructorsInStructureDeclaration-off

// Функция block_extsyncdoc_run_command_find
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
// ext_sync_obj - Соответствие - ext_sync_obj
// objects - Соответствие - objects
// item_keys - Соответствие - item_keys
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS:CognitiveComplexity-off
// BSLLS:IfElseIfEndsWithElse-off
// BSLLS:DuplicateStringLiteral-off
//DynamicDirective
Функция block_extsyncdoc_run_command_find(context, block_context, ext_sync_obj, objects, item_keys)
	Попытка
		obj = ext_sync_obj["Data"]["data"];
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Объект не содержит необходимый параметр"));
	КонецПопытки;
	ext_sync_obj["ClientType"] = Неопределено;
	calc_find = Истина;
	Integration = Неопределено;
	context.operation.Свойство("integration_id", Integration);
	
	Если get_prop(obj, "ИдИС") <> Неопределено Тогда
		begin = ДатаВМиллисекундах();
		Попытка
			result = ПолучитьСсылкуПоИдИС(obj["ИмяИС"], obj["ИдИС"]);
		Исключение
			result = Неопределено;	
		КонецПопытки;	
		end = ДатаВМиллисекундах();
		action = Новый Структура("Begin, End, Title", begin, end, "Поиск объекта в ИС");
		actions = Новый Массив();
		actions.Добавить(fill_action(action, 0, ext_sync_obj["SbisType"]));
		ext_sync_obj.Вставить("Actions", actions);
		Если ЗначениеЗаполнено(result) Тогда
			calc_find = Ложь; 
			
			ext_sync_obj["Data"]["data"]["ИдИС"] = obj["ИдИС"];
			ext_sync_obj["Data"]["data"]["ИмяИС"] = obj["ИмяИС"];
			ext_sync_obj["ClientType"] = obj["ИмяИС"]; 
			ext_sync_obj ["ClientId"] = obj["ИдИС"];
			
			_data = Новый Структура("SbisType, SbisId", ext_sync_obj["Data"]["data"]["ИмяСБИС"], ext_sync_obj["Data"]["data"]["ИдСБИС"]);
			_data.Вставить("Integration", Integration);
			_data.Вставить("ClientId", obj["ИдИС"]);
			_data.Вставить("ClientType", obj["ИмяИС"]);
			_data.Вставить("Status", ?(ЗначениеЗаполнено(result), 1, 4));
			_data.Вставить("StatusMsg", "Сопоставлено");
			
			ЗаполнитьClientParamОбъекта(_data, item_keys);
			
			objects.Добавить(Новый Структура("Uuid, StatusId",ext_sync_obj["Uuid"],"Синхронизирован") );
			
			ТранспортИнтеграции.local_helper_mapping_obj_write(context.params, _data);
			
			ext_sync_obj["StatusId"] = "Синхронизирован"; 
			ext_sync_obj ["ClientId"] = obj["ИдИС"];
			ext_sync_obj["ClientType"] = Неопределено;	
		Иначе
			ext_sync_obj["Data"]["data"].Удалить("ИдИС");	
		КонецЕсли;								
	КонецЕсли;
	
	Если calc_find Тогда
		Для Каждого item_key из item_keys Цикл
			params = Новый Соответствие;
			params.Вставить("object", ext_sync_obj["Data"]["data"]);
			params.Вставить("key", item_key);
			
			result = block_extsyncdoc_run_add_command_calc_ini(context, block_context, "find", ext_sync_obj, params, "find_by_key_"+item_key["Key"]);
			Если result["Status"] = "complete" И ЗначениеЗаполнено(result["Result"]) Тогда
					
				ext_sync_obj["Data"]["data"]["ИдИС"] = result["Result"]["ИдИС"];
				ext_sync_obj["Data"]["data"]["ИмяИС"] = result["Result"]["ИмяИС"];
				ext_sync_obj["ClientType"] = result["Result"]["ИмяИС"]; 
				ext_sync_obj ["ClientId"] = result["Result"]["ИдИС"];
				
				_data = Новый Структура("SbisType, SbisId", ext_sync_obj["Data"]["data"]["ИмяСБИС"], ext_sync_obj["Data"]["data"]["ИдСБИС"]);
				_data.Вставить("Integration", Integration);
				_data.Вставить("ClientId", result["Result"]["ИдИС"]);
				_data.Вставить("ClientType", result["Result"]["ИмяИС"]);
				Если ЗначениеЗаполнено(result["Result"]["ИдИС"]) Тогда
					_data.Вставить("Status", 1);
				Иначе
				    _data.Вставить("Status", 4);
				КонецЕсли;
				_data.Вставить("StatusMsg", "Сопоставлено");
					
				ЗаполнитьClientParamОбъекта(_data, item_keys);
				
				objects.Добавить(Новый Структура("Uuid, StatusId", ext_sync_obj["Uuid"], "Синхронизирован") );
				
				ТранспортИнтеграции.local_helper_mapping_obj_write(context.params, _data);
				
				ext_sync_obj["StatusId"] = "Синхронизирован"; 
				ext_sync_obj ["ClientId"] = result["Result"]["ИдИС"];
				ext_sync_obj["ClientType"] = Неопределено;
				Прервать;
			ИначеЕсли result["Status"] = "error" И get_prop(result["Result"], "Type") <> "NotFound" Тогда
				
				_data = Новый Структура("SbisType, SbisId", ext_sync_obj["Data"]["data"]["ИмяСБИС"], ext_sync_obj["Data"]["data"]["ИдСБИС"]);
				_data.Вставить("Integration", Integration);
				_data.Вставить("ClientId", ext_sync_obj["Data"]["data"]["ИдИС"]);
				_data.Вставить("ClientType", ext_sync_obj["Data"]["data"]["ИмяИС"]);
				_data.Вставить("Status", 5);
				_data.Вставить("StatusMsg", get_prop(result["Result"], "message"));	
					
				ЗаполнитьClientParamОбъекта(_data, item_keys);	
					
				ТранспортИнтеграции.local_helper_mapping_obj_write(context.params, _data);
				
				objects.Добавить(Новый Структура("Uuid, StatusId, StatusMsg, Data",
				ext_sync_obj["Uuid"],
				"Ошибка", 
				get_prop(result["Result"], "message"), 
				Новый Структура("error", 
					Новый Структура("action, message, code, detail, stack", 
					get_prop(result["Result"], "action"),
					get_prop(result["Result"], "message"),
					get_prop(result["Result"], "code"),
					get_prop(result["Result"], "detail"),
					get_prop(result["Result"], "stack")))
				) );
			КонецЕсли;	
			//Если результат не пустой
		КонецЦикла;
	КонецЕсли;
	
	Если (Не ЗначениеЗаполнено(get_prop(result, "Result")) ИЛИ ext_sync_obj["Subobject"] = Ложь) Тогда
		Возврат block_extsyncdoc_run_command_update(context, block_context, ext_sync_obj, objects);
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции
// BSLLS:DuplicateStringLiteral-off
// BSLLS:IfElseIfEndsWithElse-on
// BSLLS:CognitiveComplexity-on

// Функция block_extsyncdoc_run_add_command_calc_ini
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
// command - Соответствие - command
// ext_sync_obj - Соответствие - ext_sync_obj
// obj - Соответствие - obj
// endpoint - Строка - endpoint
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
//DynamicDirective
Функция block_extsyncdoc_run_add_command_calc_ini(context, block_context,
	command, ext_sync_obj, obj, endpoint = Неопределено)
	Если get_prop(ext_sync_obj, "ClientType") <> Неопределено Тогда
		Type = "ClientType";
	Иначе
		Type = "Type";
	КонецЕсли;
	type_list = СтрРазделить82(ext_sync_obj[Type], ".");
	ini_name = get_prop(get_prop(obj, "object"), "ini_name");
	Если НЕ ЗначениеЗаполнено(ini_name) Тогда
		ini_name = type_list[type_list.Количество() - 1] + "_" + command;	
	КонецЕсли;	

	Возврат load_calc_ini(ini_name, obj, endpoint);
КонецФункции

// Функция load_calc_ini
//
// Параметры:
// ini_name - Строка - ini_name
// obj - Структура - obj
// endpoint - Строка - endpoint
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
//DynamicDirective
Функция load_calc_ini(ini_name, obj, endpoint)
	Load_ini(ini_name);
	add_new_context();
	Попытка
		EndpointArgs = Новый Структура("object", obj);
		ПараметрыВызова = Новый Структура("Algorithm, EndpointArgs, Endpoint", ini_name, EndpointArgs, endpoint);
		Результат	= CalcIni(ПараметрыВызова);
		delete_last_context();
		Возврат Результат;
	Исключение
		delete_last_context();
		ИнфОбОшибке = ИнформацияОбОшибке();
		ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
		Если ЭтоПроблемаСДоступомКСервису(ОшибкаСтруктура.type) Тогда
			ВызватьИсключение ОшибкаСтруктура.Описание;
		КонецЕсли;	
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Объект не содержит необходимый параметр"));
	КонецПопытки;
КонецФункции

//Функция block_extsyncdoc_run_process_commands_result(context, block_context)
//КонецФункции

// Функция block_extsyncdoc_run_process_command_result_read
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
// ext_sync_obj - Соответствие - ext_sync_obj
// result - Соответствие - result
// objects - Соответствие - objects
// action - Строка - action
//
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS:IfElseIfEndsWithElse-off
//DynamicDirective
Процедура block_extsyncdoc_run_process_command_result_read(context, block_context,
	ext_sync_obj, result, objects, action = Неопределено)
	
	Если result.Status = "complete" Тогда
		result = result["Result"];

		Если ТипЗнч(result) = Тип("Массив") И result.Количество() > 0 Тогда
			block_extsyncdoc_run_process_command_result_read_array(
				context,
				block_context,
				ext_sync_obj,
				result,
				objects,
				action);	
		Иначе
			block_extsyncdoc_run_process_command_result_read__object(result,ext_sync_obj,objects, action);			
		КонецЕсли;	
	ИначеЕсли result.Status = "error" Тогда
		ОшибкаСтруктура= result["Result"];
		_data = ext_sync_obj; 
		_data.Вставить("StatusMsg", ОшибкаСтруктура.message);
		type = get_prop(ОшибкаСтруктура, "type", "");
		_data.Вставить("StatusId", "Ошибка"); 	
		Если ЭтоПользовательскоеИсключение(type) Тогда
			Если type = "UserCancel" Тогда
				_data.Вставить("StatusId", "Игнорирован");
			КонецЕсли;
			ИмяИС = get_prop(ext_sync_obj, "ClientType");
			ИдИС = get_prop(ext_sync_obj, "ClientId");
			Ссылка1С = ПолучитьСсылкуПоИдИС(ИмяИС, ИдИС);
			_data.Вставить("Title", Строка(Ссылка1С));
			data_is = get_prop(get_prop(_data, "Data"), "data_is", Новый Структура);
			data_is.Вставить("Причина", ОшибкаСтруктура);
			_data["Data"].Вставить("data_is", data_is);	
		Иначе	
			_data.Вставить("Title", ОшибкаСтруктура.detail);
			_data.Вставить("Data", Новый Структура("error", ОшибкаСтруктура));
		КонецЕсли;
		
		Если action <> Неопределено Тогда
			actions = Новый Массив();
			status = get_prop(ОшибкаСтруктура, "code", 100);
			actions.Добавить(fill_action(action, status, get_prop(result, "Название")));
			_data.Вставить("Actions", actions);
		КонецЕсли;
		objects.Добавить(_data);

	КонецЕсли;
КонецПроцедуры
// BSLLS:IfElseIfEndsWithElse-on

// Функция block_extsyncdoc_run_process_command_result_read_array
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
// ext_sync_obj - Соответствие - ext_sync_obj
// result - Соответствие - result
// objects - Соответствие - objects
// action - Строка - action
//
//DynamicDirective
Процедура block_extsyncdoc_run_process_command_result_read_array(context, block_context, ext_sync_obj, result, objects, action)
	ПервыйЭлемент = Истина;
	Если action <> Неопределено Тогда
		begin = action.begin;
		end = action.end;
		elapsedTime = (end - begin) / result.Количество();
		current_begin = begin;
	КонецЕсли;
	сч = 1;
	Для каждого _result из result Цикл
		Если action <> Неопределено Тогда
			current_action = Новый Структура;
			copy_block_context(current_action, action); 
			current_end = begin + Окр(elapsedTime * сч);
			current_action.begin = current_begin;
			current_action.end = current_end; 
		КонецЕсли;
		сч = сч + 1;
		Если ПервыйЭлемент Тогда
			ПервыйЭлемент = Ложь;	
		Иначе
			ext_sync_obj.Удалить("Uuid"); 
			ext_sync_obj.Удалить("@ExtSyncObj");
		КонецЕсли;
		ОбъектСинхронизации = ЗначениеИзСтрокиВСтрокуВнутрНаСервере(ext_sync_obj);
		block_extsyncdoc_run_process_command_result_read__object(_result, ОбъектСинхронизации, objects, current_action);
		Если action <> Неопределено Тогда
			current_begin = current_end;
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

// Функция block_extsyncdoc_run_process_command_result_read__object
//
// Параметры:
// result - Соответствие - result
// ext_sync_obj - Соответствие - ext_sync_obj
// objects - Соответствие - Соответствие
// action - Соответствие - action
//
//DynamicDirective
Процедура block_extsyncdoc_run_process_command_result_read__object(result, ext_sync_obj, objects, action = Неопределено)
	Попытка
		ПроверитьНаличиеОбязательныхПараметров(result, "ИдИС,ИмяИС", ext_sync_obj["Type"]+" "+get_prop(ext_sync_obj,"Title",ext_sync_obj["ClientId"]));
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
		Если get_prop(result, "error") <> Неопределено Тогда
			ОшибкаСтруктура.message = get_prop(result, "error");
		КонецЕсли;			
		_data = ext_sync_obj;
		_data.Вставить("Title", ОшибкаСтруктура.detail);
		_data.Вставить("StatusId", "Ошибка");
		_data.Вставить("StatusMsg", ОшибкаСтруктура.message);
		_data.Вставить("Data", 
		Новый Структура("error", ОшибкаСтруктура));
		objects.Добавить(_data);
		Возврат;
	КонецПопытки;
	
	new_data = Новый Соответствие;
	Для Каждого ЭлементСтруктуры Из get_prop(ext_sync_obj, "Data", Новый Соответствие()) Цикл
	  new_data.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
	КонецЦикла;
	
	new_ext_sync_obj = Новый Соответствие;
	Для Каждого ЭлементСтруктуры Из ext_sync_obj Цикл
	  new_ext_sync_obj.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
	КонецЦикла;
	
	Если get_prop(new_data, "_print_forms") <> Неопределено Тогда
		new_data.Удалить("_print_forms");
	КонецЕсли;	
	new_data.Вставить("data_is", result);
	new_data.Вставить("name", get_prop(result,"Название"));
	new_data.Вставить("ini_name", "");
	
	new_ext_sync_obj.Вставить("ClientId", result["ИдИС"]);
	new_ext_sync_obj.Вставить("Id", result["ИдИС"]);
	new_ext_sync_obj.Вставить("SbisType", get_prop(result,"ИмяСБИС"));
	new_ext_sync_obj.Вставить("StatusId", "Получен");
	new_ext_sync_obj.Вставить("Title", get_prop(result,"Название"));
	new_ext_sync_obj.Вставить("Data", new_data);
	Если action <> Неопределено Тогда
		actions = Новый Массив();
		actions.Добавить(fill_action(action, 0, new_ext_sync_obj["SbisType"]));
		new_ext_sync_obj.Вставить("Actions", actions);
	КонецЕсли;
		
	objects.Добавить(new_ext_sync_obj);
КонецПроцедуры

//DynamicDirective

Процедура block_extsyncdoc_run_process_command_result_update_mapdelete(context, Integration, objdict)
	Если ТипЗнч(objdict) <> Тип("Соответствие") Тогда 
		Возврат;
	КонецЕсли;	
	Для Каждого Запись Из objdict Цикл
		Filter = Новый Структура;
		Filter.Вставить("ClientType", Запись.Ключ);
		Filter.Вставить("ClientId", Запись.Значение);
		ТранспортИнтеграции.local_helper_mapping_obj_delete(context.params, Integration, Filter);
	КонецЦикла;		
КонецПроцедуры

// Функция block_extsyncdoc_run_process_command_result_update
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
// command - Соответствие - Название блока
// result - Соответствие - result
// objects - Массив - objects
// action - Строка - Действие
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
//DynamicDirective
Функция block_extsyncdoc_run_process_command_result_update(context, block_context, command, result, objects, action)
	Integration = Неопределено;
	context.operation.Свойство("integration_id", Integration);
	actions = get_prop(command, "Actions", Новый Массив());
	
	Если get_prop(result["Result"], "ИдИС") <> Неопределено Тогда
		//# записываем идентификатор в маппинг
		_data = Новый Структура("SbisType, SbisId", command["Data"]["data"]["ИмяСБИС"], command["Data"]["data"]["ИдСБИС"]);
		_data.Вставить("Integration", Integration);
		_data.Вставить("ClientId", result["Result"]["ИдИС"]);
		_data.Вставить("ClientType", result["Result"]["ИмяИС"]);
		_data.Вставить("Status", ?(ЗначениеЗаполнено(result["Result"]["ИдИС"]), 1, 4));
		_data.Вставить("StatusMsg", "Сопоставлено");
			
		ЗаполнитьClientParamОбъекта(_data, get_prop(command, "Keys", Новый Массив));
			
		ТранспортИнтеграции.local_helper_mapping_obj_write(context.params, _data);
		actions.Добавить(fill_action(action, 0, command["SbisType"]));	
		objects.Добавить(Новый Структура("Uuid, StatusId, ClientId, ClientType, Actions", command["Uuid"], "Синхронизирован", result["Result"]["ИдИС"], result["Result"]["ИмяИС"], actions));
	ИначеЕсли result["Status"] = "complete" И  Не ЗначениеЗаполнено(result["Result"]) Тогда
		_data = Новый Структура("SbisType, SbisId", command["Data"]["data"]["ИмяСБИС"], command["Data"]["data"]["ИдСБИС"]);
		_data.Вставить("Integration", Integration);
		_data.Вставить("ClientId", command["Data"]["data"]["ИдИС"]);
		_data.Вставить("ClientType", command["Data"]["data"]["ИмяИС"]);
		_data.Вставить("Status", 2);
		_data.Вставить("StatusMsg", "Игнорирован");
			
		ЗаполнитьClientParamОбъекта(_data, get_prop(command, "Keys", Новый Массив));
		
		ТранспортИнтеграции.local_helper_mapping_obj_write(context.params, _data);
		actions.Добавить(fill_action(action, 0, command["SbisType"]));
		objects.Добавить(Новый Структура("Uuid, StatusId, StatusMsg, Actions",
		command["Uuid"],
		"Игнорирован", 
		"Игнорирован", 
		actions));
	Иначе
		Если result["Status"] = "error" Тогда 
			// BSLLS:CommentedCode-off
			// BSLLS:SpaceAtStartComment-off
			ОшибкаСтруктура = result["Result"];
			Type = get_prop(ОшибкаСтруктура, "type", "");
			Если Type = "NotFound" Тогда
				dump = block_obj_get_path_value(ОшибкаСтруктура, "stack.0.dump.remove_mapping", Новый Соответствие);
				block_extsyncdoc_run_process_command_result_update_mapdelete(context, Integration, dump);
				_object = Новый Структура("Uuid, StatusId, StatusMsg",
				command["Uuid"],
				Неопределено, 
				"");
				objects.Добавить(_object);
			Иначе	
		
				_data = Новый Структура("SbisType, SbisId", command["Data"]["data"]["ИмяСБИС"], command["Data"]["data"]["ИдСБИС"]);
				_data.Вставить("Integration", Integration);
				_data.Вставить("ClientId", command["Data"]["data"]["ИдИС"]);
				_data.Вставить("ClientType", command["Data"]["data"]["ИмяИС"]);
				_data.Вставить("Status", 5);
				_data.Вставить("StatusMsg", get_prop(result["Result"], "message"));
					
				ЗаполнитьClientParamОбъекта(_data, get_prop(command, "Keys", Новый Массив));
								
				ТранспортИнтеграции.local_helper_mapping_obj_write(context.params, _data);
				status = get_prop(result["Result"], "code", 100);
				actions.Добавить(fill_action(action, status, command["SbisType"]));
				_error = Новый Структура("action, message, code, detail, stack", 
									get_prop(result["Result"], "action"),
									get_prop(result["Result"], "message"),
									get_prop(result["Result"], "code"),
									get_prop(result["Result"], "detail"),
									get_prop(result["Result"], "stack"));
				_object = Новый Структура("Uuid, StatusId, StatusMsg, Data, Actions",
					command["Uuid"],
					"Ошибка", 
					get_prop(result["Result"], "message"), 
					Новый Структура("error", _error),
					actions);
				objects.Добавить(_object);
			КонецЕсли;
			// BSLLS:SpaceAtStartComment-on
			// BSLLS:CommentedCode-on
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// BSLLS:NestedConstructorsInStructureDeclaration-on
// BSLLS:NumberOfValuesInStructureConstructor-on

// Процедура ЗаполнитьClientParamОбъекта
//
// Параметры:
// _data - Соответствие - _data
// Keys - Соответствие - Keys
//
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS:CognitiveComplexity-off
//DynamicDirective
Процедура ЗаполнитьClientParamОбъекта(_data, Keys)
	НомерКлюча = 1;	
	Для Каждого ik из Keys Цикл
		Order = get_prop(ik, "Order", НомерКлюча);
		ИндексКлюча = 1;
		ИмяКлюча = get_prop(ik, "Key"); 
		Пока Истина Цикл
			Если get_prop(ik, "Value" + ИндексКлюча) = Неопределено Тогда
				Прервать;
			КонецЕсли;	
			ЗначениеКлюча = ik["Value" + ИндексКлюча];
			Если get_prop(ЗначениеКлюча, "Uid") <> Неопределено Тогда
				ЗначениеКлюча = ЗначениеКлюча["Uid"];	
			КонецЕсли;
			Если Order = 1 Тогда
				_data.Вставить("ClientKey" + Order + "_" + ИндексКлюча, ЗначениеКлюча);
			ИначеЕсли ИмяКлюча = "ObjectName" Тогда
				_data.Вставить("ClientTitle", ik["Value1"]);
			Иначе
				_data.Вставить("ClientKey" + Order, ЗначениеКлюча);
			КонецЕсли;
			ИндексКлюча = ИндексКлюча + 1;		
		КонецЦикла;
		НомерКлюча = НомерКлюча + 1;
	КонецЦикла;	
КонецПроцедуры
// BSLLS:CognitiveComplexity-on

// Функция ПолучитьИнформациюОбОшибке
//
// Параметры:
// ДействиеОбъекта - Массив - ДействиеОбъекта
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
//DynamicDirective
Функция ПолучитьИнформациюОбОшибке(ДействиеОбъекта)
	РезультатРаботы = Неопределено;
	Если ТипЗнч(ДействиеОбъекта) <> Тип("Массив") Тогда Возврат РезультатРаботы; КонецЕсли;
	Для Каждого ЭлементДействияУровень1 из ДействиеОбъекта Цикл
		Если ТипЗнч(ЭлементДействияУровень1) <> Тип("Соответствие") Тогда Продолжить; КонецЕсли;
		Если get_prop(ЭлементДействияУровень1,"StatusId", "") = "Ошибка" Тогда
			ОшибкаДата	= get_prop(ЭлементДействияУровень1,"Data");
			ОшибкаЕррор	= get_prop(ОшибкаДата,"error");
			РезультатРаботы = Новый Структура("message,detail",get_prop(ОшибкаЕррор,"message"),get_prop(ОшибкаЕррор,"detail"));
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат РезультатРаботы;
КонецФункции

//DynamicDirective

Функция СравнениеПоИмяИсИдИС(ЗначениеИС, МассивЗначенийФильтра, ЭтоТипСтруктураСоответствие) 
	
	ИмяИс = get_prop(ЗначениеИС, "ИмяИС"); 
	ИдИс = get_prop(ЗначениеИС, "ИдИС");
	
	Игнорирован = Ложь;
	Для Каждого ЗаписьЗначенияФильтра Из МассивЗначенийФильтра Цикл
		ИмяИсФильтра = get_prop(ЗаписьЗначенияФильтра, "ИмяИС");
		Если ЭтоТипСтруктураСоответствие.Найти(ТипЗнч(ЗаписьЗначенияФильтра)) = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		Если ИмяИсФильтра <> ИмяИс Тогда 
			Продолжить;
		КонецЕсли;
	   	ИдИсФильтра = get_prop(ЗаписьЗначенияФильтра, "ИдИС");
		Если ИдИс = ИдИсФильтра Или Лев(ИдИс, 36) = ИдИсФильтра Тогда
			Возврат Ложь;
		Иначе
			Игнорирован = Истина;	
		КонецЕсли;
	КонецЦикла;	
	Возврат Игнорирован;
КонецФункции

//DynamicDirective

Функция ПроверкаРеквизитовПоФильтрамМассива(МассивИС, МассивЗначенийФильтра)
	Для Каждого ЗначениеИС Из МассивИС Цикл 
		Игнорирован = ПроверкаРеквизитовПоФильтрамСтруктур(ЗначениеИС, МассивЗначенийФильтра);
		Если Игнорирован = Истина Тогда
			Возврат Истина;
		КонецЕсли;	
	КонецЦикла;
	Возврат Ложь;
КонецФункции	

//DynamicDirective

Функция ПроверкаРеквизитовПоФильтрамСтруктур(data_is, ЗначениеФильтра)
	ЭтоТипСтруктураСоответствие = Новый Массив;
	ЭтоТипСтруктураСоответствие.Добавить(Тип("Структура"));
	ЭтоТипСтруктураСоответствие.Добавить(Тип("Соответствие"));
	МассивЗначенийФильтра = ЗначениеФильтра;
	Если ЭтоТипСтруктураСоответствие.Найти(ТипЗнч(ЗначениеФильтра)) <> Неопределено Тогда  
		МассивЗначенийФильтра = Новый Массив;
		МассивЗначенийФильтра.Добавить(ЗначениеФильтра);
	КонецЕсли;   
	
	Для Каждого РеквизитИС Из data_is Цикл 
		Если get_prop(РеквизитИС, "Ключ", Неопределено) = "Ответственный" Тогда // не участвует в фильтрации
			Продолжить;
		КонецЕсли;
		ЗначениеИС = get_prop(РеквизитИС, "Значение");
		Если ТипЗнч(ЗначениеИС) = Тип("Массив") Тогда 
			Игнорирован = ПроверкаРеквизитовПоФильтрамМассива(ЗначениеИС, МассивЗначенийФильтра);
			Если Игнорирован = Истина Тогда
				Возврат Истина;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		Если ЭтоТипСтруктураСоответствие.Найти(ТипЗнч(ЗначениеИС)) = Неопределено Тогда 
			Продолжить;
		КонецЕсли; 
        ИмяИс = get_prop(ЗначениеИС, "ИмяИС");
		Если ИмяИс = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Игнорирован = СравнениеПоИмяИсИдИС(ЗначениеИС, МассивЗначенийФильтра, ЭтоТипСтруктураСоответствие);
		Если Игнорирован = Истина Тогда
			Возврат Истина;
		КонецЕсли;	
	КонецЦикла;	

	Возврат Ложь;
КонецФункции
	
//DynamicDirective

Функция ПроверкаЗначенийПоФильтру(data_is, КлючФильтра, ЗначениеФильтра)
	ЭтоТипСтрокаЧислоБулево = Новый Массив;
	ЭтоТипСтрокаЧислоБулево.Добавить(Тип("Строка"));
	ЭтоТипСтрокаЧислоБулево.Добавить(Тип("Число"));
	ЭтоТипСтрокаЧислоБулево.Добавить(Тип("Булево"));
	Если ЭтоТипСтрокаЧислоБулево.Найти(ТипЗнч(ЗначениеФильтра)) <> Неопределено Тогда 
		ЗначениеРеквизита = get_prop(data_is, КлючФильтра, Неопределено);
		Если ЗначениеРеквизита <> Неопределено И ЗначениеРеквизита <> ЗначениеФильтра Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	Возврат ПроверкаРеквизитовПоФильтрамСтруктур(data_is, ЗначениеФильтра);
КонецФункции

//DynamicDirective

Функция ИгнорированПоФильтру(data_is, Filter)
	Итог = Ложь;
	КлючФильтра = Filter["Ключ"]; 
	ЗначениеФильтра = Filter["Значение"];
	Если get_prop(ЗначениеФильтра, "Api3Link", Неопределено) <> Неопределено Тогда // для совместимости с первой версией фильтра
		ЗначениеФильтра = get_prop(ЗначениеФильтра, "Api3Link");
	КонецЕсли;
	ИмяФильтра = КлючФильтра;
	Отступ3 = 3;
	Отступ5 = 5; 
	Если Прав(КлючФильтра, Отступ3) = "_To" Тогда 
		Сравнение = "Больше";
		ИмяФильтра = Лев(ИмяФильтра, СтрДлина(ИмяФильтра) - Отступ3);
	ИначеЕсли Прав(КлючФильтра, Отступ5) = "_From" Тогда
		Сравнение = "Меньше";
		ИмяФильтра = Лев(ИмяФильтра, СтрДлина(ИмяФильтра) - Отступ5);
	ИначеЕсли Прав(КлючФильтра, Отступ3) = "Нач" Тогда	
		Сравнение = "Меньше";
		ИмяФильтра = Лев(ИмяФильтра, СтрДлина(ИмяФильтра) - Отступ3);
	ИначеЕсли Прав(КлючФильтра, Отступ3) = "Кнц" Тогда
		Сравнение = "Больше";
		ИмяФильтра = Лев(ИмяФильтра, СтрДлина(ИмяФильтра) - Отступ3);
	Иначе
		Сравнение = "Равно";	
	КонецЕсли;	
	
	Если Сравнение = "Больше" Или Сравнение = "Меньше" Тогда
		РеквизитОбъекта = get_prop(data_is, ИмяФильтра);
		Если РеквизитОбъекта = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;	
		ЗначениеРеквизита = ПреобразоватьСтрокуВДату("dd.MM.yyyy", РеквизитОбъекта);
		ЗначениеФильтра = ПреобразоватьСтрокуВДату("yyyy-MM-dd", ЗначениеФильтра); 
	КонецЕсли;
	Если Сравнение = "Больше" И ЗначениеРеквизита > ЗначениеФильтра Тогда
		Итог = Истина;
	КонецЕсли;
	Если Сравнение = "Меньше" И ЗначениеРеквизита < ЗначениеФильтра Тогда
		Итог = Истина;
	КонецЕсли;
	Если Сравнение = "Равно" Тогда
		Итог = ПроверкаЗначенийПоФильтру(data_is, КлючФильтра, ЗначениеФильтра);	
	КонецЕсли;
	Возврат Итог;
КонецФункции

//DynamicDirective

Процедура ПроверитьОбъектыПоФильтрам(context, objects)
	Filter = get_prop(context, "Filter", Неопределено);
	Если Filter = Неопределено Тогда 
		Возврат;
	КонецЕсли; 
	Для Каждого ext_sync_obj Из objects Цикл 
		SubObject = get_prop(ext_sync_obj, "Subobject", Истина);
		Если SubObject = Истина Тогда
			Продолжить;
		КонецЕсли;	
		data_is = get_prop(get_prop(ext_sync_obj, "Data"), "data_is");
		Если data_is = Неопределено Тогда
			Продолжить;
		КонецЕсли;	
		Для Каждого Запись_Filter Из Filter Цикл
			Если Запись_Filter["Значение"] = Неопределено Тогда  
				Продолжить;
			КонецЕсли;
			Результат = ИгнорированПоФильтру(data_is, Запись_Filter);
			Если Результат = Истина Тогда
				ext_sync_obj.Вставить("StatusId", "Игнорирован");	
				ext_sync_obj.Вставить("StatusMsg", "Применен фильтр по реквизиту " + Запись_Filter["Ключ"]);
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
	КонецЦикла;	
КонецПроцедуры

// Функция block_extsyncdoc_run_extsyncdoc_prepare_is
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS-off
//DynamicDirective
Функция block_extsyncdoc_run_extsyncdoc_prepare_is(context, block_context)
	extsyncdoc_uuid = Неопределено;
	context.operation.Свойство("operation_uuid", extsyncdoc_uuid);
	connection_uuid = Неопределено;
	context.operation.Свойство("connection_uuid", connection_uuid);
	МассивОшибокДляФормыКлиента = Новый Массив;
	Пока Истина Цикл
		block_context.Вставить("prepare_counter", block_context.prepare_counter + 1);
		//Если block_context.prepare_counter >= 3000 Тогда
		//	//ВызватьИсключение "Превышено количество циклов prepare для операции экспорта";
		//	ИнфОбОшибке = ИнформацияОбОшибке();
		//	ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Превышено количество циклов prepare для операции экспорта"));
		//КонецЕсли;
		
		result = Неопределено;
		Попытка
			result = ТранспортИнтеграции.local_helper_extsyncdoc_prepare(context.params, extsyncdoc_uuid, 1);
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();
			ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));
		КонецПопытки;
		ДопПарамерыПрогресса = ПрогрессВыполнения(result);
		
		Для каждого key_ Из result Цикл
			block_context.Вставить(key_.Ключ, key_.Значение);
		КонецЦикла;
		
		actions = ?(block_context.Свойство("requiredActions"), block_context.requiredActions, Новый Массив );
		count_actions = actions.Количество(); 
		ДопПарамерыПрогресса.Вставить("ВсегоОбъектов", block_context.all_objects);
		СообщитьПрогрессОперации(,Строка(block_context.all_objects)+" объектов получено, в т.ч. с ошибками " + 
			block_context.count_error, ДопПарамерыПрогресса);
		
		Если count_actions > 0 Тогда
			
			objects = Новый Массив;
			Для Каждого command_ Из result["requiredActions"] Цикл
				Попытка
					//await getattr(self, f'command_{command[0].lower()}')(context, block_context, command[1])
					Если НРег(command_[0]) = "syncdocfill" Тогда
						result = block_extsyncdoc_run_command_syncdocfill(context, block_context, command_[1], objects);
					ИначеЕсли НРег(command_[0]) = "processpredefineobject" Тогда
						result = block_extsyncdoc_run_command_processpredefineobject(context, block_context, command_[1]);
					ИначеЕсли НРег(command_[0]) = "getobject" Тогда
						result = block_extsyncdoc_run_command_getobject(context, block_context, command_[1], objects);
					ИначеЕсли НРег(command_[0]) = "update" Тогда
						result = block_extsyncdoc_run_command_update(context, block_context, command_[1], objects);
					ИначеЕсли НРег(command_[0]) = "find" Тогда
						item_keys = Новый Массив;
						result = block_extsyncdoc_run_command_find(context, block_context, command_[1], objects, item_keys); //Где взять item_keys
					КонецЕсли;
					ДанныеОбОшибке = ПолучитьИнформациюОбОшибке(command_);
					Если ЗначениеЗаполнено(ДанныеОбОшибке) Тогда
						МассивОшибокДляФормыКлиента.Добавить(ДанныеОбОшибке);
					КонецЕсли;
				Исключение
					ИнфОбОшибке = ИнформацияОбОшибке();
					ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке, , , ,add_block_to_dump(block_context));
					_error = Новый Структура("error", ОшибкаСтруктура);
					_data = command_[1];
					_data.Вставить("Title", ОшибкаСтруктура.detail);
					_data.Вставить("StatusId", "Ошибка");
					_data.Вставить("StatusMsg", ОшибкаСтруктура.message);
					_data.Вставить("Data", 
					_error);
					objects.Добавить(_data);
				КонецПопытки;
			КонецЦикла;
			ПроверитьОбъектыПоФильтрам(context, objects);
						
			Если objects.Количество() > 0 Тогда
				res = ТранспортИнтеграции.local_helper_extsyncdoc_write(
				context.params,
				connection_uuid,
				Новый Структура("Uuid", extsyncdoc_uuid),
				objects);
				context.report.new = Ложь;
			КонецЕсли;
		КонецЕсли;	
		
		Если count_actions <= 0 И (block_context.all_objects <= block_context.count_processed + block_context.count_error) Тогда
			Если block_context.count_error > 0 Тогда
				// todo Взять за пример и сделать функцию вызова исключения 
				// ВызватьИсключение NewExtExceptionСтрока(,"Ошибки подготовки", МассивОшибокДляФормыКлиента);
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат result;
КонецФункции
// BSLLS-on

// Функция block_extsyncdoc_run_extsyncdoc_prepare_saby
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
//DynamicDirective
Функция block_extsyncdoc_run_extsyncdoc_prepare_saby(context, block_context)
	extsyncdoc_uuid = "";
	context.operation.Свойство("operation_uuid", extsyncdoc_uuid);
	result = ТранспортИнтеграции.local_helper_extsyncdoc_prepare_saby(context.params, extsyncdoc_uuid);
	// Пробросим ключи с данными статистики для формы длительных операциий
	Для каждого key_ Из result Цикл
		block_context.Вставить(key_.Ключ, key_.Значение);
	КонецЦикла;
	Возврат result;
КонецФункции

// Функция block_extsyncdoc_run_extsyncdoc_execute_saby
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
//DynamicDirective
Функция block_extsyncdoc_run_extsyncdoc_execute_saby(context, block_context)
	extsyncdoc_uuid = "";
	context.operation.Свойство("operation_uuid", extsyncdoc_uuid);
	Возврат ТранспортИнтеграции.local_helper_extsyncdoc_execute(context.params, extsyncdoc_uuid, 1);
КонецФункции

// Функция block_extsyncdoc_run_extsyncdoc_execute_saby_lrs
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Неопределено - Результат выполения функции
//
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS:CognitiveComplexity-off
//DynamicDirective
Функция block_extsyncdoc_run_extsyncdoc_execute_saby_lrs(context, block_context)
	extsyncdoc_uuid = "";
	Status100 = 100;
	Status50 = 50;
	Status20 = 20;
	Status10 = 10;
	
	context.operation.Свойство("operation_uuid", extsyncdoc_uuid);
	ТранспортИнтеграции.local_helper_extsyncdoc_execute_lrs(context.params, extsyncdoc_uuid, 1);
	_CountObjects = "CountObjects";
	Пока Истина Цикл
		result = block_extsyncdoc_run_extsyncdoc_read_saby(context, block_context);
		ДопПарамерыПрогресса = ПрогрессВыполнения(result);
		ОбъектовПроигнорировано = get_prop(result, "CountIgnored", 0);
		СтрокаПроигнорировано = "";
		Если ОбъектовПроигнорировано <> 0 Тогда
			СтрокаПроигнорировано = ", проигнорировано " + ОбъектовПроигнорировано;
		КонецЕсли;
		ТекстСтатуса = "Обработано " + result["CountConfirmed"] + "/" + result[_CountObjects]
			+ СтрокаПроигнорировано + ", ошибок " + result["CountErrors"];
		Если result[_CountObjects] > 0 И result[_CountObjects] = (result["CountErrors"] + result["CountConfirmed"]
			+ result["CountProcessed"]) Тогда
			СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
			ТранспортИнтеграции.local_helper_pause(1); 
			// Если не поставить паузу, то сообщение может не успеть долететь и обновить строку состояния выгрузки.
			Если result["Status"] <> Status50 Тогда
				Прервать;
			КонецЕсли;
		Иначе			
			Status = result["Status"];
			Если Status = Status10 Или Status = Status20 Тогда
				// У спешное завершение
				СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
				ТранспортИнтеграции.local_helper_pause(1);
				// Если не поставить паузу, то сообщение может не успеть долететь и обновить строку состояния выгрузки.
				Прервать;
			Иначе
				Если Status = Status100 Тогда
					// Завершено с ошибкой
					СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
					ТранспортИнтеграции.local_helper_pause(1);
					// Если не поставить паузу, то сообщение может не успеть долететь и обновить строку состояния выгрузки.
					Прервать;
				КонецЕсли;
			КонецЕсли;
			СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
			ТранспортИнтеграции.local_helper_pause(1);
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

//DynamicDirective

Функция block_extsyncdoc_run_extsyncdoc_execute_saby_lrs2_wait(context, block_context)
	Status100 = 100;
	Status50 = 50;
	Status20 = 20;
	Status10 = 10;
	Пока Истина Цикл
		result = block_extsyncdoc_run_extsyncdoc_read_saby(context, block_context);
		ДопПарамерыПрогресса = ПрогрессВыполнения(result);
		ВсегоОбъектов = get_prop(result, "CountObjects", 0);
		ОбъектовПроигнорировано = get_prop(result, "CountIgnored", 0);
		ОбъектовСОшибками = get_prop(result, "CountErrors", 0);
		ОбъектовЗагружено = get_prop(result, "CountConfirmed", 0);
		
		СтрокаПроигнорировано = "";
		Если ОбъектовПроигнорировано <> 0 Тогда
			СтрокаПроигнорировано = ", проигнорировано " + ОбъектовПроигнорировано;
		КонецЕсли;
		ТекстСтатуса = "Обработано " + ОбъектовЗагружено + "/" + ВсегоОбъектов
						+ СтрокаПроигнорировано + ", ошибок " + ОбъектовСОшибками;
		Если ВсегоОбъектов > 0
			И ВсегоОбъектов = ОбъектовПроигнорировано + ОбъектовСОшибками + ОбъектовЗагружено Тогда
			СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
			ТранспортИнтеграции.local_helper_pause(1); 
			// Если не поставить паузу, то сообщение может не успеть долететь и обновить строку состояния выгрузки.
			Если result["Status"] <> Status50 Тогда
				Прервать;
			КонецЕсли;
		Иначе			
			Status = result["Status"];
			Если Status = Status10 Или Status = Status20 Тогда
				// У спешное завершение
				СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
				ТранспортИнтеграции.local_helper_pause(1);
				// Если не поставить паузу, то сообщение может не успеть долететь и обновить строку состояния выгрузки.
				Прервать;
			Иначе
				Если Status = Status100 Тогда
					// Завершено с ошибкой
					СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
					ТранспортИнтеграции.local_helper_pause(1);
					// Если не поставить паузу, то сообщение может не успеть долететь и обновить строку состояния выгрузки.
					Прервать;
				КонецЕсли;
			КонецЕсли;
			СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
			ТранспортИнтеграции.local_helper_pause(1);
		КонецЕсли;
	КонецЦикла;
	Возврат result;	
КонецФункции

//DynamicDirective

Функция block_extsyncdoc_run_extsyncdoc_execute_saby_lrs2(context, block_context)
	extsyncdoc_uuid = "";
		
	context.operation.Свойство("operation_uuid", extsyncdoc_uuid); 
	block_context.Вставить("execute_counter", 0);
	Пока Истина Цикл
		ТранспортИнтеграции.local_helper_extsyncdoc_execute_lrs2(context.params, extsyncdoc_uuid, 1); 
		result = block_extsyncdoc_run_extsyncdoc_execute_saby_lrs2_wait(context, block_context);
		ВсегоОбъектов = get_prop(result, "CountObjects", 0);
		ОбъектовПроигнорировано = get_prop(result, "CountIgnored", 0);
		ОбъектовСОшибками = get_prop(result, "CountErrors", 0);
		ОбъектовЗагружено = get_prop(result, "CountConfirmed", 0);
		Если ВсегоОбъектов = ОбъектовПроигнорировано + ОбъектовСОшибками + ОбъектовЗагружено Тогда 
			Прервать;
		КонецЕсли;  
		block_context.Вставить("execute_counter", block_context.execute_counter + 1);
		Если block_context.execute_counter > 100 Тогда
			Прервать;
		КонецЕсли;	
		block_extsyncdoc_run_extsyncdoc_prepare_is(context, block_context);
	КонецЦикла;
	
	Возврат Неопределено;	
КонецФункции

// BSLLS:CognitiveComplexity-on
// Функция block_extsyncdoc_run_extsyncdoc_execute_is
//
// BSLLS:MissingParameterDescription-off
// Не видит описание параметра - break_extsyncobj_uuid
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
// break_extsyncobj_uuid - Строка = Точка прерывания
//
// Возвращаемое значение:
//  Булево,Неопределено - Результат выполения функции
//
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS:CognitiveComplexity-off
// BSLLS:AllFunctionPathMustHaveReturn-off
//DynamicDirective
Функция block_extsyncdoc_run_extsyncdoc_execute_is(context, block_context, break_extsyncobj_uuid = Неопределено)
	extsyncdoc_uuid = "";
	context.operation.Свойство("operation_uuid", extsyncdoc_uuid);
	connection_uuid = Неопределено;
	context.operation.Свойство("connection_uuid", connection_uuid);
	
	ДопПарамерыПрогресса = ПрогрессВыполнения(block_context);
	ДопПарамерыПрогресса.Вставить("ВсегоОбъектов", block_context.all_objects);
	СообщитьПрогрессОперации(,Строка(block_context.all_objects)+" объектов получено, в т.ч. с ошибками "+block_context.count_error, ДопПарамерыПрогресса);
	block_context.Вставить("prepare_counter", 0);
	Пока Истина Цикл
		Если block_context.prepare_counter >= 20 Тогда
			ВызватьИсключение "Превышено количество циклов prepare для операции";
		КонецЕсли;
		
		result = Неопределено;
		
		extra_fields = Новый Массив;
		extra_fields.Добавить("Keys"); 
		extra_fields.Добавить("SbisType");
        limit = 1;
		
		Попытка
			result = ТранспортИнтеграции.local_helper_extsyncobj_get_obj_for_execute(context.params, extsyncdoc_uuid, extra_fields, limit);
		Исключение 
			ИнфОбОшибке = ИнформацияОбОшибке();
			ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));
		КонецПопытки;

		Если Не ЗначениеЗаполнено(result) Тогда
			// BSLLS:CommentedCode-off
			// BSLLS:SpaceAtStartComment-off
			СтатусЗагрузки = block_extsyncdoc_run_extsyncdoc_read_saby(context, block_context);
			ВсегоОбъектов = СтатусЗагрузки["CountObjects"];
			ОбъектовПроигнорировано = get_prop(СтатусЗагрузки, "CountIgnored", 0);
			ОбъектовСОшибками = get_prop(СтатусЗагрузки, "CountErrors", 0);
			ОбъектовЗагружено = get_prop(СтатусЗагрузки, "CountConfirmed", 0);
			Если ВсегоОбъектов = ОбъектовПроигнорировано + ОбъектовСОшибками + ОбъектовЗагружено Тогда 
				ТранспортИнтеграции.local_helper_extsyncdoc_execute(context.params, extsyncdoc_uuid, 2);
				ТранспортИнтеграции.local_helper_extsyncdoc_write_stat(context.params, extsyncdoc_uuid);
				ТранспортИнтеграции.local_helper_pause(1);
				Возврат Истина;
			Иначе 
				block_context.Вставить("prepare_counter", get_prop(block_context, "prepare_counter", 0) + 1);
				block_extsyncdoc_run_extsyncdoc_prepare_saby(context, block_context);
				 Продолжить;
			КонецЕсли;
			// BSLLS:SpaceAtStartComment-on
			// BSLLS:CommentedCode-on
		КонецЕсли;
		
		objects = Новый Массив;
		Для Каждого obj Из result Цикл
			// при отадке инишек нам нужно получить объект для отладки
			Если break_extsyncobj_uuid <> Неопределено И get_prop(obj, "Uuid") = break_extsyncobj_uuid Тогда
				Возврат obj;
			КонецЕсли;
			
			БылоОбъектов = objects.Количество();
			block_extsyncdoc_run_command_find(context, block_context, obj, objects, obj["Keys"]); // Добавить item_keys, где их взять?

			Если objects.Количество() = БылоОбъектов Тогда // если не обновить статус у всех переданных объектов = бесконечный цикл
				ВызватьИсключение(NewExtExceptionСтрока(, "Команда Execute не выполнена", obj["Type"] ,"block_extsyncdoc_run_extsyncdoc_execute_is",obj));
			КонецЕсли;
		КонецЦикла;
		// Устанавливаем статус маппинга
		Если objects.Количество() > 0 Тогда
			// BSLLS:UnusedLocalVariable-off
			// Оставим res для отладки
			res = ТранспортИнтеграции.local_helper_extsyncdoc_write(
				context.params,
				connection_uuid,
				Новый Структура("Uuid", extsyncdoc_uuid),
				objects);
			context.report.new = Ложь;	
			// BSLLS:UnusedLocalVariable-on
		КонецЕсли;
		// Читаем статистику обмена
		СтатусЗагрузки = block_extsyncdoc_run_extsyncdoc_read_saby(context, block_context);
		ДопПарамерыПрогресса = ПрогрессВыполнения(СтатусЗагрузки);
		ОбъектовПроигнорировано = get_prop(СтатусЗагрузки, "CountIgnored", 0);
		СтрокаПроигнорировано = "";
		Если ОбъектовПроигнорировано <> 0 Тогда
			СтрокаПроигнорировано = ", проигнорировано " + ОбъектовПроигнорировано;
		КонецЕсли;
		ТекстСтатуса = "Обработано " + СтатусЗагрузки["CountConfirmed"] + "/" + СтатусЗагрузки["CountObjects"]
			+ СтрокаПроигнорировано + ", ошибок " + СтатусЗагрузки["CountErrors"];
		СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
	КонецЦикла;
	ТранспортИнтеграции.local_helper_pause(1); //Для прогрузки состояния на форме длительных операций
КонецФункции

// BSLLS:CognitiveComplexity-on
// BSLLS:AllFunctionPathMustHaveReturn-on
// BSLLS:MissingParameterDescription-on

// Функция block_extsyncdoc_run_extsyncdoc_read_saby
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
//DynamicDirective
Функция block_extsyncdoc_run_extsyncdoc_read_saby(context, block_context)
	extsyncdoc_uuid = "";
	context.operation.Свойство("operation_uuid", extsyncdoc_uuid);
	Возврат ТранспортИнтеграции.local_helper_extsyncdoc_read(context.params, extsyncdoc_uuid);
КонецФункции

