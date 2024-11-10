
#Область include_IntegrationBlockly_base_Blocks_ExtsyncdocWriteExtSysType
#КонецОбласти

//DynamicDirective
Функция block_extsyncdoc_write_calc_value(block_type, node, path, context, block_context)
	Попытка
		direction	= block_context.direction;
	Исключение
		ОшибкаСтрокой	= NewExtExceptionСтрока( 
		Новый Структура("message, detail", "Не указан обязательный параметр", block_type+" direction"),
		);
		ВызватьИсключение ОшибкаСтрокой;
	КонецПопытки;
	Попытка
		objects		= block_context.objects;
	Исключение
		ОшибкаСтрокой	= NewExtExceptionСтрока( 
		Новый Структура("message, detail", "Не указан обязательный параметр", block_type+" objects"),
		);
		ВызватьИсключение ОшибкаСтрокой;
	КонецПопытки;
	
	Если direction = "import" Тогда
		direction = 1;
	ИначеЕсли direction = "export" Тогда
		direction = 0;
	ИначеЕсли direction = "import_api3_obj" Тогда
		direction = 1;
		objects = block_extsyncdoc_write_api3_objects(context, direction, objects);
	ИначеЕсли direction = "import_api3_link" Тогда
		direction = 1;
		objects = block_extsyncdoc_write_api3_link(context, direction, objects);
	Иначе
		ВызватьИсключение "Хрень какая то";
	КонецЕсли;
	
	extsyncdoc_uuid = get_prop(context.operation,"operation_uuid","");
	connection_uuid = get_prop(context.operation,"connection_uuid","");
	
	Попытка
		Data = local_helper_system_info();
		
		Если ПустаяСтрока(extsyncdoc_uuid) Тогда
			ПараметрыВЫзова = Новый Структура("Direction, Data", direction, Data);
		Иначе
			//И почему тут будет новый uuid, а не от предыдущего вызовата? Миша!
			ПараметрыВЫзова = Новый Структура("Uuid, Direction, Data", extsyncdoc_uuid, direction, Data);
		КонецЕсли;
		
		ПолученыйUuid = local_helper_extsyncdoc_write(
		context.params,
		connection_uuid,
		ПараметрыВЫзова,
		objects
		);
		Если Не ПустаяСтрока(ПолученыйUuid) и ПолученыйUuid <> extsyncdoc_uuid Тогда
			context.operation.Вставить("operation_uuid", ПолученыйUuid);
		КонецЕсли;
		Возврат True;
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		block_set_variable(context, "_last_error", NewExtExceptionСтрока(ИнфОбОшибке));
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке);
		//Возврат Ложь;
	КонецПопытки;
	
	Возврат block_context.result;
КонецФункции

//DynamicDirective
Функция block_extsyncdoc_write_api3_link(context, direction, objects, заполнять_data_is = ЛОЖЬ)
	_objects = Новый Массив;
	Для Каждого obj Из objects Цикл
		_id = "";
		obj.Свойство("ИдИС", _id);
		ini_name	= "";
		//obj.Свойство("ini_name", ini_name);
		//# await update_ini(self.executor, context, ini_name)
		_object = Новый Структура(
		"Id, Title, Type, ClientType, ClientId, Data, StatusId",
		_id,
		?(obj.Свойство("Название"), obj.Название, _id),
		obj.ТипИС+"."+obj.ИмяИС,
		obj.ТипИС+"."+obj.ИмяИС,
		_id,
		Новый Структура( "_print_forms", get_prop(obj, "_print_forms")
		//"data_is",
		////"data_is, ini_name",
		//obj,
		////ini_name,
		),
		Неопределено
		);                    
		
		Если ЗначениеЗаполнено(obj.ini_name) Тогда
			_object.Data.Вставить("ini_name", obj.ini_name);	
		КонецЕсли;
		Если ЗначениеЗаполнено(get_prop(obj, "Регламент")) Тогда
			_object.Data.Вставить("Регламент", obj.Регламент);	
		КонецЕсли;
		Если ЗначениеЗаполнено(get_prop(obj, "ПроизвольноеНазваниеРегламента")) Тогда
			_object.Data.Вставить("ПроизвольноеНазваниеРегламента", obj.ПроизвольноеНазваниеРегламента);	
		КонецЕсли;
		Если заполнять_data_is = ИСТИНА Тогда 
			_object.Data.Вставить("data_is",obj);
			_object.Data.data_is.Вставить("ini_name",obj.ИмяИС);
		КонецЕсли;

		_objects.Добавить(_object);
	КонецЦикла;
	
	Возврат _objects;
КонецФункции

//DynamicDirective
Функция block_extsyncdoc_write_api3_objects(context, direction, objects)
	_objects = Новый Массив;
	Для Каждого obj Из objects Цикл
		ПроверитьНаличиеОбязательныхПараметров(obj, "ИдИС,Название,ТипИС");
		_id = obj["ИдИС"];
		ini_name = get_prop(obj, "ini_name");
		Data = Новый Структура("data_is",obj);
		Если ЗначениеЗаполнено(ini_name) Тогда
			Data.Вставить("ini_name", ini_name);
		КонецЕсли;
		_object = Новый Структура("Title, Type, ClientId, Data, StatusId",
		?(obj["Название"]<>неопределено, obj["Название"], _id),
		obj["ТипИС"]+"."+obj["ИмяИС"],
		_id,
		Data,
		"Получен");
		_objects.Добавить(_object);
	КонецЦикла;	
	Возврат _objects;
КонецФункции

