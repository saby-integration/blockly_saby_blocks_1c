
Функция block_extsyncdoc_run_calc_value(block_type, node, path, context, block_context)
	prepare_counter = Неопределено;
	Если НЕ block_context.Свойство("prepare_counter", prepare_counter) Тогда
		block_context.Вставить("prepare_counter", 0);
	КонецЕсли;
	
	__deferred = Неопределено;
	Если НЕ block_context.Свойство("__deferred", __deferred) Тогда
		block_context.Вставить("__deferred", Новый Структура());
	КонецЕсли;
	
	Попытка
		result = block_extsyncdoc_run_extsyncdoc_read_saby(context, block_context);
		Если result["Direction"] = 1 Тогда //Из 1С в СБИС 
			result = block_extsyncdoc_run_extsyncdoc_prepare_is(context, block_context);
			result = block_extsyncdoc_run_extsyncdoc_execute_saby_lrs(context, block_context);
		ИначеЕсли result["Direction"] = 2 или result["Direction"] = 0 Тогда //Из СБИС в 1С
			//result = block_extsyncdoc_run_process_commands_result(context, block_context);
			result = block_extsyncdoc_run_extsyncdoc_prepare_saby(context, block_context);
			result = block_extsyncdoc_run_extsyncdoc_execute_is(context, block_context);
		Иначе	
			//ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,add_block_to_dump(block_context));
		КонецЕсли;
	Исключение
		ИнфОбОшибке	= ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,add_block_to_dump(block_context));
	КонецПопытки;
	
	result = block_extsyncdoc_run_extsyncdoc_read_saby(context, block_context);
	return result
КонецФункции

Функция block_extsyncdoc_run_command_syncdocfill(context, block_context, ext_sync_obj, objects)
	Если ЗначениеЗаполнено(ext_sync_obj["ini_name"]) Тогда
		obj = ?(ext_sync_obj.Получить("Context") = Неопределено, Новый Соответствие(), ext_sync_obj["Context"]);
		data_is	= Новый Соответствие;
		Для каждого _filter из ext_sync_obj["filter"] Цикл
			data_is.Вставить(_filter.Ключ, _filter.Значение);	
		КонецЦикла;
		ИмяОбъекта = СтрЗаменить(ext_sync_obj["ini_name"],"СинхВыгрузка_","");
		data_is.Вставить("ini_name", ИмяОбъекта);
		ext_sync_obj.Вставить("Type", ИмяОбъекта);
			
		obj.Вставить("object", data_is);
		result = block_extsyncdoc_run_add_command_calc_ini(context, block_context, "fill", ext_sync_obj, obj);
		block_extsyncdoc_run_process_command_result_read(context, block_context, ext_sync_obj, result, objects); //block_context.objects	
	Иначе
		Возврат "";	
	КонецЕсли;
КонецФункции

Функция block_extsyncdoc_run_command_processpredefineobject(context, block_context, ext_sync_obj)
	
	obj = ?(ext_sync_obj.Получить("Context") = Неопределено, Новый Соответствие(), ext_sync_obj["Context"]);
	obj.Вставить("ИдИС", ext_sync_obj.Получить("ClientId"));
	obj.Вставить("ИмяСБИС", СтрЗаменить(ext_sync_obj.Получить("Data").Получить("ini_name"), "СинхВыгрузка_","")); 
	data_is = ext_sync_obj.Получить("Data").Получить("data_is");
	Если data_is = Неопределено Тогда
		data_is	= Новый Соответствие;
		data_is.Вставить("ИдИС", ext_sync_obj.Получить("ClientId"));
	КонецЕсли;
	obj.Вставить("object", data_is);
	
	result = block_extsyncdoc_run_add_command_calc_ini(context, block_context, "predefine", ext_sync_obj, obj);
	Если result["status"] = "complete" Тогда
		Если ТипЗнч(result["data"]) = Тип("Массив") Тогда 
			Для каждого _data из result["data"] Цикл
				local_helper_extsyncdoc_write_predefined(context["params"], context["operation"]["connection_uuid"], ext_sync_obj["Type"], _data["ClientType"], _data["Objects"]);	
			КонецЦикла;	
		Иначе	
			local_helper_extsyncdoc_write_predefined(context["params"], context["operation"]["connection_uuid"], ext_sync_obj["Type"], result["data"]["ClientType"], result["data"]["Objects"]);  
		КонецЕсли;  
	ИначеЕсли result["status"] = "error" Тогда
		ВызватьИсключение NewExtExceptionСтрока(,"Не удалость загрузить предопределенные данные - " + ext_sync_obj["Type"], "command_processpredefineobject");	
	КонецЕсли;
КонецФункции

Функция block_extsyncdoc_run_command_getobject(context, block_context, ext_sync_obj, objects)
	obj = ?(ext_sync_obj.Получить("Context") = Неопределено, Новый Соответствие(), ext_sync_obj["Context"]);
	obj.Вставить("ИдИС", ext_sync_obj.Получить("ClientId"));
	obj.Вставить("ИмяСБИС", ext_sync_obj["SbisType"]); 
	data_is = ext_sync_obj.Получить("Data").Получить("data_is");
	Если data_is = Неопределено Тогда
		Если get_prop(ext_sync_obj, "ClientType") <> Неопределено Тогда
			Type = "ClientType";
		Иначе
			Type = "Type";
		КонецЕсли;	
		type_list = СтрРазделить82(ext_sync_obj.Получить(Type),".");
		data_is	= Новый Соответствие;
		data_is.Вставить("ИдИС", ext_sync_obj.Получить("ClientId"));
		data_is.Вставить("ТипИС", type_list[0]);
		data_is.Вставить("ИмяИС", type_list[1]);
		data_is.Вставить("Регламент", ext_sync_obj["Data"]["Регламент"]);
		data_is.Вставить("ПроизвольноеНазваниеРегламента", ext_sync_obj["Data"]["ПроизвольноеНазваниеРегламента"]);
		data_is.Вставить("ini_name", СтрЗаменить(ext_sync_obj["Data"]["ini_name"],"СинхВыгрузка_",""));
		data_is.Вставить("_print_forms", ext_sync_obj["Data"]["_print_forms"]); //TODO убрать костыли
	КонецЕсли;
	obj.Вставить("object", data_is);
	endpoint=get_prop(get_prop(ext_sync_obj, "Data", Новый Структура),"endpoint", Неопределено);
	
	begin = ТекущаяУниверсальнаяДатаВМиллисекундах();
	result = block_extsyncdoc_run_add_command_calc_ini(context, block_context, "read", ext_sync_obj, obj, endpoint);
	end = ТекущаяУниверсальнаяДатаВМиллисекундах();
	action = Новый Структура("Begin, End, Title", begin, end, "Чтение объекта из ИС");
	block_extsyncdoc_run_process_command_result_read(context, block_context, ext_sync_obj, result, objects, action); //block_context.objects
КонецФункции

Функция block_extsyncdoc_run_command_update(context, block_context, ext_sync_obj, objects)
	Попытка
		obj = ext_sync_obj["Data"]["data"];
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Объект не содержит необходимый параметр"));
	КонецПопытки;
	begin = ТекущаяУниверсальнаяДатаВМиллисекундах();
	result = block_extsyncdoc_run_add_command_calc_ini(context, block_context, "update", ext_sync_obj, ext_sync_obj["Data"]["data"]);
	end = ТекущаяУниверсальнаяДатаВМиллисекундах();
	action = Новый Структура("Begin, End, Title", begin, end, "Запись объекта в ИС");
	block_extsyncdoc_run_process_command_result_update(context, block_context, ext_sync_obj, result, objects, action); //block_context.objects
КонецФункции

Функция block_extsyncdoc_run_command_find(context, block_context, ext_sync_obj, objects, item_keys)
	Попытка
		obj = ext_sync_obj["Data"]["data"];
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Объект не содержит необходимый параметр"));
	КонецПопытки;
	ext_sync_obj["ClientType"] = Неопределено;
	
	Если get_prop(obj, "ИдИС") = Неопределено Тогда
		calc_find = Истина;
	Иначе		
		keys = Новый Соответствие;
		keys.Вставить("Value1", Новый Соответствие);
		keys["Value1"].Вставить("Uid", obj["ИдИС"]);
		keys["Value1"].Вставить("Type", obj["ИмяИС"]);
		
		params = Новый Соответствие;
		params.Вставить("object", ext_sync_obj["Data"]["data"]);
		params.Вставить("key", keys);		
		
		begin = ТекущаяУниверсальнаяДатаВМиллисекундах();
		result = block_extsyncdoc_run_add_command_calc_ini(context, block_context, "find", ext_sync_obj, params, "find_by_key_Uid");
		end = ТекущаяУниверсальнаяДатаВМиллисекундах();
		action = Новый Структура("Begin, End, Title", begin, end, "Поиск объекта в ИС");
		actions = Новый Массив();
		actions.Добавить(fill_action(action, 0, ext_sync_obj["SbisType"]));
		ext_sync_obj.Вставить("Actions", actions);
		Если (result["status"] = "complete" И НЕ ЗначениеЗаполнено(result["data"])) ИЛИ result["status"] = "error" Тогда
			ext_sync_obj["Data"]["data"].Удалить("ИдИС");
			calc_find = Истина;
		Иначе
			calc_find = Ложь;
		КонецЕсли;								
	КонецЕсли;
	
	Если calc_find Тогда
		Для Каждого item_key из item_keys Цикл
			params = Новый Соответствие;
			params.Вставить("object", ext_sync_obj["Data"]["data"]);
			params.Вставить("key", item_key);
			
			result = block_extsyncdoc_run_add_command_calc_ini(context, block_context, "find", ext_sync_obj, params, "find_by_key_"+item_key["Key"]);
			Если result["status"] = "complete" и ЗначениеЗаполнено(result["data"]) Тогда
				connection_uuid = Неопределено;
				context.operation.Свойство("connection_uuid", connection_uuid);
				
				ext_sync_obj["Data"]["data"]["ИдИС"] = result["data"]["ИдИС"];
				ext_sync_obj["Data"]["data"]["ИмяИС"] = result["data"]["ИмяИС"];
				ext_sync_obj["ClientType"] = result["data"]["ИмяИС"]; 
				ext_sync_obj ["ClientId"] = result["data"]["ИдИС"];
				
				_filter = Новый Структура("ConnectionId, Type, Id, IdType",
					connection_uuid,
					ext_sync_obj["Data"]["data"]["ИмяСБИС"],
					ext_sync_obj["Data"]["data"]["ИдСБИС"],
					1
					);
				
				_data = Новый Структура("ClientId, ClientType, Status, Status_msg",
					result["data"]["ИдИС"],
					result["data"]["ИмяИС"],
					?(ЗначениеЗаполнено(result["data"]["ИдИС"]), 1, 4),
					"Сопоставлено"
					);
					
				НомерКлюча = 1;	
				Для каждого ik из item_keys Цикл
					ИндексКлюча = 1;
					Пока Истина Цикл
						Если get_prop(ik, "Value"+ИндексКлюча) <> Неопределено Тогда
							ЗначениеКлюча = ik["Value"+ИндексКлюча];
							Если get_prop(ЗначениеКлюча, "Uid") <> Неопределено Тогда
								ЗначениеКлюча = ЗначениеКлюча["Uid"];	
							КонецЕсли;
							_data.Вставить("ClientParam_"+НомерКлюча+"_"+ИндексКлюча, ЗначениеКлюча);
							ИндексКлюча = ИндексКлюча + 1;	
						Иначе
							Прервать;
						КонецЕсли;	
					КонецЦикла;
					НомерКлюча = НомерКлюча + 1;
				КонецЦикла;
				
				objects.Добавить(Новый Структура("Uuid, StatusId",ext_sync_obj["Uuid"],"Синхронизирован") );
				
				local_helper_mapping_obj_find_and_update(
					context.params,
					_filter,
					_data
					);
				
				ext_sync_obj["StatusId"] = "Синхронизирован"; 
				ext_sync_obj ["ClientId"] = result["data"]["ИдИС"];
				ext_sync_obj["ClientType"] = Неопределено;
				Прервать;
			ИначеЕсли result["status"] = "error"  и get_prop(result["data"], "Type") <> "NotFound" Тогда
				connection_uuid = Неопределено;
				context.operation.Свойство("connection_uuid", connection_uuid);
				
				_filter = Новый Структура("ConnectionId, Type, Id, IdType",
					connection_uuid,
					ext_sync_obj["Data"]["data"]["ИмяСБИС"],
					ext_sync_obj["Data"]["data"]["ИдСБИС"],
					1
					);
				
				_data = Новый Структура("ClientId, ClientType, Status, StatusId, Status_msg",
					ext_sync_obj["Data"]["data"]["ИдИС"],
					ext_sync_obj["Data"]["data"]["ИмяИС"],
					5,
					"Ошибка",
					get_prop(result["data"], "message")
					);	
				
				local_helper_mapping_obj_find_and_update(
					context.params,
					_filter,
					_data
					);
				objects.Добавить(Новый Структура("Uuid, StatusId, StatusMsg, Data",
				ext_sync_obj["Uuid"],
				"Ошибка", 
				get_prop(result["data"], "message"), 
				Новый Структура("error", 
					Новый Структура("action, message, code, detail, stack", 
					get_prop(result["data"], "action"),
					get_prop(result["data"], "message"),
					get_prop(result["data"], "code"),
					get_prop(result["data"], "detail"),
					get_prop(result["data"], "stack")))
				) );
			КонецЕсли;	
			//Если результат не пустой
		КонецЦикла;
	КонецЕсли;
	
	Если (Не ЗначениеЗаполнено(get_prop(result,"data")) ИЛИ ext_sync_obj["Subobject"] = Ложь) Тогда
		Возврат block_extsyncdoc_run_command_update(context, block_context, ext_sync_obj, objects);
	КонецЕсли;
КонецФункции

Функция block_extsyncdoc_run_add_command_calc_ini(context, block_context, command, ext_sync_obj, obj, endpoint=Неопределено)
	//obj_name = СтрЗаменить(ext_sync_obj["Data"]["ini_name"], "Данные_","");
	//obj_name = СтрЗаменить(obj_name, "СинхВыгрузка_","");
	Если get_prop(ext_sync_obj, "ClientType") <> Неопределено Тогда
		Type = "ClientType";
	Иначе
		Type = "Type";
	КонецЕсли;
	type_list = СтрРазделить82(ext_sync_obj[Type],".");
	obj_name = get_prop(get_prop(obj,"object"),"ini_name");
	Если НЕ ЗначениеЗаполнено(obj_name) Тогда
		obj_name = type_list[type_list.Количество() - 1];	
	КонецЕсли;	
		
	ini_name = obj_name+"_"+command;
	Возврат load_calc_ini(ini_name, obj, endpoint);
	
КонецФункции

Функция load_calc_ini(ini_name, obj, endpoint)
	Load_ini(ini_name);
	add_new_context();
	Попытка
		CurrentStepByStep = StepByStep;  // мы не можем поддержвать отадку внутри блока обмена
		StepByStep = Ложь;
		CurrentFunctions = Functions;
		ПараметрыВызова = Новый Структура("ini_name, object, endpoint", ini_name, obj, endpoint);
		Результат	= CalcIni(ПараметрыВызова);
		delete_last_context();
		StepByStep = CurrentStepByStep;
		Functions = CurrentFunctions;
		Возврат Результат;
	Исключение
		delete_last_context();
		StepByStep = CurrentStepByStep;
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Объект не содержит необходимый параметр"));
	КонецПопытки;
КонецФункции

//Функция block_extsyncdoc_run_process_commands_result(context, block_context)
//КонецФункции

Процедура block_extsyncdoc_run_process_command_result_read(context, block_context, ext_sync_obj, result, objects, action = Неопределено)
	
	Если result.status = "complete" Тогда
		result = result["data"];

		Если ТипЗнч(result) = Тип("Массив") И result.Количество() > 0 Тогда
			block_extsyncdoc_run_process_command_result_read_array(context, block_context, ext_sync_obj, result, objects, action);	
		Иначе
			block_extsyncdoc_run_process_command_result_read__object(result,ext_sync_obj,objects, action);			
		КонецЕсли;	
	ИначеЕсли result.status = "error" Тогда
		ОшибкаСтруктура= result["data"];
		_data = ext_sync_obj;
		_data.Вставить("Title", ОшибкаСтруктура.detail);
		_data.Вставить("StatusId", "Ошибка");
		_data.Вставить("StatusMsg", ОшибкаСтруктура.message);
		_data.Вставить("Data", 
		Новый Структура("error", ОшибкаСтруктура)
		);
		Если action <> Неопределено Тогда
			actions = Новый Массив();
			status = get_prop(ОшибкаСтруктура, "code", 100);
			actions.Добавить(fill_action(action, status, get_prop(result,"Название")));
			_data.Вставить("Actions", actions);
		КонецЕсли;
		objects.Добавить(_data);
	КонецЕсли;
КонецПроцедуры

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
			ext_sync_obj["Uuid"] = Строка(Новый УникальныйИдентификатор);
		КонецЕсли;
		block_extsyncdoc_run_process_command_result_read__object(_result,ext_sync_obj,objects, current_action);
		Если action <> Неопределено Тогда
			current_begin = current_end;
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

Процедура block_extsyncdoc_run_process_command_result_read__object(result, ext_sync_obj, objects, action = Неопределено)
	Попытка
		ПроверитьНаличиеОбязательныхПараметров(result, "ИдИС,ТипИС,ИмяИС,Название", ext_sync_obj["Type"]+" "+get_prop(ext_sync_obj,"Title",ext_sync_obj["ClientId"]));
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
	
	new_ext_sync_obj.Удалить("@ExtSyncObj");
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

Функция block_extsyncdoc_run_process_command_result_update(context, block_context, command, result, objects, action)
	connection_uuid = Неопределено;
	context.operation.Свойство("connection_uuid", connection_uuid);
	actions = get_prop(command, "Actions", Новый Массив());
	
	Если get_prop(result["data"], "ИдИС") <> Неопределено Тогда
		//# записываем идентификатор в маппинг
		_filter = Новый Структура("ConnectionId, Type, Id, IdType",
			connection_uuid,
			command["Data"]["data"]["ИмяСБИС"],
			command["Data"]["data"]["ИдСБИС"],
			1
			);
		_data = Новый Структура("ClientId, ClientType, Status, Status_msg",
			result["data"]["ИдИС"],
			result["data"]["ИмяИС"],
			?(ЗначениеЗаполнено(result["data"]["ИдИС"]), 1, 4),
			"Сопоставлено"
			);
		local_helper_mapping_obj_find_and_update(context.params, _filter, _data);
		actions.Добавить(fill_action(action, 0, command["SbisType"]));	
		objects.Добавить(Новый Структура("Uuid, StatusId, ClientId, ClientType, Actions",command["Uuid"],"Синхронизирован", result["data"]["ИдИС"], result["data"]["ИмяИС"], actions));
	ИначеЕсли Не ЗначениеЗаполнено(result["data"]) Тогда
		_filter = Новый Структура("ConnectionId, Type, Id, IdType",
			connection_uuid,
			command["Data"]["data"]["ИмяСБИС"],
			command["Data"]["data"]["ИдСБИС"],
			1
			);
		
		_data = Новый Структура("ClientId, ClientType, Status, Status_msg",
			command["Data"]["data"]["ИдИС"],
			command["Data"]["data"]["ИмяИС"],
			2,
			"Игнорирован"
			);   
		local_helper_mapping_obj_find_and_update(context.params, _filter, _data);
		actions.Добавить(fill_action(action, 0, command["SbisType"]));
		objects.Добавить(Новый Структура("Uuid, StatusId, StatusMsg, Actions",
		command["Uuid"],
		"Игнорирован", 
		"Игнорирован", 
		actions));
	ИначеЕсли result["status"] = "error" Тогда 	
		_filter = Новый Структура("ConnectionId, Type, Id, IdType",
			connection_uuid,
			command["Data"]["data"]["ИмяСБИС"],
			command["Data"]["data"]["ИдСБИС"],
			1
			);
		
		_data = Новый Структура("ClientId, ClientType, Status, Status_msg",
			command["Data"]["data"]["ИдИС"],
			command["Data"]["data"]["ИмяИС"],
			5,
			get_prop(result["data"], "message")
			);	
			
			НомерКлюча = 1;	
			Для каждого ik из get_prop(command, "Keys", Новый Массив) Цикл
				ИндексКлюча = 1;
				Пока Истина Цикл
					Если get_prop(ik, "Value"+ИндексКлюча) <> Неопределено Тогда
						ЗначениеКлюча = ik["Value"+ИндексКлюча];
						Если get_prop(ЗначениеКлюча, "Uid") <> Неопределено Тогда
							ЗначениеКлюча = ЗначениеКлюча["Uid"];	
						КонецЕсли;
						_data.Вставить("ClientParam_"+НомерКлюча+"_"+ИндексКлюча, ЗначениеКлюча);
						ИндексКлюча = ИндексКлюча + 1;	
					Иначе
						Прервать;
					КонецЕсли;	
				КонецЦикла;
				НомерКлюча = НомерКлюча + 1;
			КонецЦикла;
			
		local_helper_mapping_obj_find_and_update(context.params, _filter, _data);
		status = get_prop(result["data"], "code", 100);
		actions.Добавить(fill_action(action, status, command["SbisType"]));
		objects.Добавить(Новый Структура("Uuid, StatusId, StatusMsg, Data, Actions",
		command["Uuid"],
		"Ошибка", 
		get_prop(result["data"], "message"), 
		Новый Структура("error", 
			Новый Структура("action, message, code, detail, stack", 
			get_prop(result["data"], "action"),
			get_prop(result["data"], "message"),
			get_prop(result["data"], "code"),
			get_prop(result["data"], "detail"),
			get_prop(result["data"], "stack"))),
		actions));
	КонецЕсли;
	
КонецФункции

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

Функция block_extsyncdoc_run_extsyncdoc_prepare_is(context, block_context)
	extsyncdoc_uuid = Неопределено;
	context.operation.Свойство("operation_uuid", extsyncdoc_uuid);
	connection_uuid = Неопределено;
	context.operation.Свойство("connection_uuid", connection_uuid);
	МассивОшибокДляФормыКлиента = Новый Массив;
	Пока Истина Цикл
		block_context.Вставить("prepare_counter", block_context.prepare_counter + 1);
		Если block_context.prepare_counter >= 3000 Тогда
			//ВызватьИсключение "Превышено количество циклов prepare для операции экспорта";
			ИнфОбОшибке = ИнформацияОбОшибке();
			ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Превышено количество циклов prepare для операции экспорта"));
		КонецЕсли;
		
		result = Неопределено;
		Попытка
			result = local_helper_extsyncdoc_prepare(context.params, extsyncdoc_uuid, 1);
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
		СообщитьПрогрессОперации(,Строка(block_context.all_objects)+" объектов получено, в т.ч. с ошибками "+block_context.count_error, ДопПарамерыПрогресса);
		
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
					ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке,,,,add_block_to_dump(block_context));
					_data = command_[1];
					_data.Вставить("Title", ОшибкаСтруктура.detail);
					_data.Вставить("StatusId", "Ошибка");
					_data.Вставить("StatusMsg", ОшибкаСтруктура.message);
					_data.Вставить("Data", 
					Новый Структура("error",
					ОшибкаСтруктура
					)
					);
					objects.Добавить(_data);
				КонецПопытки;
			КонецЦикла;
			
			Если objects.Количество() > 0 Тогда
				res = local_helper_extsyncdoc_write(
				context.params,
				connection_uuid,
				Новый Структура("Uuid", extsyncdoc_uuid),
				objects);
			КонецЕсли;
		КонецЕсли;	
		
		Если count_actions <= 0 И (block_context.all_objects <= block_context.count_processed + block_context.count_error) Тогда
			Если block_context.count_error > 0 Тогда
				//todo Взять за пример и сделать функцию вызова исключения 
				//ВызватьИсключение NewExtExceptionСтрока(,"Ошибки подготовки", МассивОшибокДляФормыКлиента);
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат result;
КонецФункции

Функция block_extsyncdoc_run_extsyncdoc_prepare_saby(context, block_context)
	extsyncdoc_uuid = "";
	context.operation.Свойство("operation_uuid", extsyncdoc_uuid);
	result = local_helper_extsyncdoc_prepare_saby(context.params, extsyncdoc_uuid);
	//Пробросим ключи с данными статистики для формы длительных операциий
	Для каждого key_ Из result Цикл
		block_context.Вставить(key_.Ключ, key_.Значение);
	КонецЦикла;
	Возврат result;
КонецФункции

Функция block_extsyncdoc_run_extsyncdoc_execute_saby(context, block_context)
	extsyncdoc_uuid = "";
	context.operation.Свойство("operation_uuid", extsyncdoc_uuid);
	Возврат local_helper_extsyncdoc_execute(context.params, extsyncdoc_uuid, 1);
КонецФункции

Функция block_extsyncdoc_run_extsyncdoc_execute_saby_lrs(context, block_context)
	extsyncdoc_uuid = "";
	context.operation.Свойство("operation_uuid", extsyncdoc_uuid);
	local_helper_extsyncdoc_execute_lrs(context.params, extsyncdoc_uuid, 1);
	Пока Истина Цикл
		result = block_extsyncdoc_run_extsyncdoc_read_saby(context, block_context);
		ДопПарамерыПрогресса = ПрогрессВыполнения(result);
		ТекстСтатуса = "Загружено " + result["CountConfirmed"]+"/"+result["CountObjects"]+", ошибок "+result["CountErrors"];
		Если result["CountObjects"] > 0 и result["CountObjects"] = (result["CountErrors"] + result["CountConfirmed"] + result["CountProcessed"]) Тогда
			СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
			local_helper_pause(1); // Если не поставить паузу, то сообщение может не успеть долететь и обновить строку состояния выгрузки.
			Прервать;
		Иначе			
			Status = result["Status"];
			Если Status = 10 Или Status = 20 Тогда
				//Успешное завершение
				СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
				local_helper_pause(1); // Если не поставить паузу, то сообщение может не успеть долететь и обновить строку состояния выгрузки.
				Прервать;
			ИначеЕсли Status = 100 Тогда
				//Завершено с ошибкой
				СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
				local_helper_pause(1); // Если не поставить паузу, то сообщение может не успеть долететь и обновить строку состояния выгрузки.
				Прервать;
			КонецЕсли;
			СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
			local_helper_pause(1);
		КонецЕсли;
	КонецЦикла;
КонецФункции

Функция block_extsyncdoc_run_extsyncdoc_execute_is(context, block_context, break_extsyncobj_uuid=Неопределено)
	extsyncdoc_uuid = "";
	context.operation.Свойство("operation_uuid", extsyncdoc_uuid);
	connection_uuid = Неопределено;
	context.operation.Свойство("connection_uuid", connection_uuid);
	
	ДопПарамерыПрогресса = ПрогрессВыполнения(block_context);
	ДопПарамерыПрогресса.Вставить("ВсегоОбъектов", block_context.all_objects);
	СообщитьПрогрессОперации(,Строка(block_context.all_objects)+" объектов получено, в т.ч. с ошибками "+block_context.count_error, ДопПарамерыПрогресса);
	Пока Истина Цикл
		block_context.Вставить("prepare_counter", get_prop(block_context, "prepare_counter", 0) + 1);
		Если block_context.prepare_counter >= 3000 Тогда
			ВызватьИсключение "Превышено количество циклов prepare для операции";
		КонецЕсли;
		
		result = Неопределено;
		
		extra_fields = Новый Массив;
		extra_fields.Добавить("Keys"); 
		extra_fields.Добавить("SbisType");
        limit = 1;
		
		Попытка
			result = local_helper_extsyncobj_get_obj_for_execute(context.params, extsyncdoc_uuid, extra_fields, limit);
		Исключение 
			ИнфОбОшибке = ИнформацияОбОшибке();
			ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));
		КонецПопытки;
		ДопПарамерыПрогресса = ПрогрессВыполнения(result);

		Если Не ЗначениеЗаполнено(result) Тогда
			local_helper_extsyncdoc_execute(context.params, extsyncdoc_uuid, 2);
			local_helper_pause(1);
			Возврат Истина;
		КонецЕсли;
		
		objects = Новый Массив;
		Для Каждого obj Из result Цикл
			// при отадке инишек нам нужно получить объект для отладки
			Если break_extsyncobj_uuid <> Неопределено И get_prop(obj, "Uuid") = break_extsyncobj_uuid Тогда
				Возврат obj;
			КонецЕсли;
			
			БылоОбъектов = objects.Количество();
			block_extsyncdoc_run_command_find(context, block_context, obj, objects, obj["Keys"]); //Добавить item_keys, где их взять?

			Если objects.Количество() = БылоОбъектов Тогда // если не обновить статус у всех переданных объектов = бесконечный цикл
				ВызватьИсключение(NewExtExceptionСтрока(, "Команда Execute не выполнена", obj["Type"] ,"block_extsyncdoc_run_extsyncdoc_execute_is",obj));
			КонецЕсли;
		КонецЦикла;
		//Устанавливаем статус маппинга
		Если objects.Количество() > 0 Тогда
			res = local_helper_extsyncdoc_write(
			context.params,
			connection_uuid,
			Новый Структура("Uuid", extsyncdoc_uuid),
			objects
			);
		КонецЕсли;
		//Читаем статистику обмена
		СтатусЗагрузки = block_extsyncdoc_run_extsyncdoc_read_saby(context, block_context);
		ТекстСтатуса = "Выгружено " + СтатусЗагрузки["CountConfirmed"]+"/"+СтатусЗагрузки["CountObjects"]+", ошибок "+СтатусЗагрузки["CountErrors"];
		СообщитьПрогрессОперации(, ТекстСтатуса, ДопПарамерыПрогресса);
	КонецЦикла;
	local_helper_pause(1); //Для прогрузки состояния на форме длительных операций
КонецФункции

Функция block_extsyncdoc_run_extsyncdoc_read_saby(context, block_context)
	extsyncdoc_uuid = "";
	context.operation.Свойство("operation_uuid", extsyncdoc_uuid);
	Возврат local_helper_extsyncdoc_read(context.params, extsyncdoc_uuid);
КонецФункции

