
#Область include_IntegrationBlockly_base_Blocks_ExtsyncdocWriteExtSysType
#КонецОбласти

// Функция block_extsyncdoc_write2_calc_value
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
Функция block_extsyncdoc_write2_calc_value(block_type, node, path, context, block_context)

	objects = block_context.objects;
	direction = block_context.direction;
	
	result = block_extsyncdoc_write(direction, objects, context);
			
	Возврат result;
КонецФункции

// Функция block_extsyncdoc_write_calc_value
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
Функция block_extsyncdoc_write_calc_value(block_type, node, path, context, block_context)
	Попытка
		direction	= block_context.direction;
	Исключение
		ОшибкаСтрокой	= NewExtExceptionСтрока( 
		Новый Структура("message, detail", "Не указан обязательный параметр", block_type+" direction"));
		ВызватьИсключение ОшибкаСтрокой;
	КонецПопытки;
	Попытка
		objects		= block_context.objects;
	Исключение
		ОшибкаСтрокой	= NewExtExceptionСтрока(
			Новый Структура("message, detail", "Не указан обязательный параметр", block_type + " objects"));
		ВызватьИсключение ОшибкаСтрокой;
	КонецПопытки;
	
	Возврат block_extsyncdoc_write(direction, objects, context);
КонецФункции

// Функция block_extsyncdoc_write
//
// Параметры:
// direction - Неопределено - Направление
// objects - Структура - Объекты
// context - Соответствие - Контекст исполняемого блока
//
// Возвращаемое значение:
//  Строка - Результат выполения функции
//
// BSLLS:FunctionOutParameter-off
// нельзя откзаться от установки значения в objects
//DynamicDirective
Функция block_extsyncdoc_write(direction, objects, context)
			
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
	ИначеЕсли direction = "import_by_filter" Тогда
		direction = 1;
		objects = block_extsyncdoc_write_by_filter(context, direction, objects);
	Иначе
		ВызватьИсключение "Неподдерживаемый тип направления обмена";
	КонецЕсли;
	
	context.report.Вставить("direction", direction);
	
	extsyncdoc_uuid = get_prop(context.operation, "operation_uuid", "");
	connection_uuid = get_prop(context.operation, "connection_uuid", "");
	Робот = get_prop(context.operation, "isRobot", Ложь);
	
	Попытка
		Робот = get_prop(context.operation, "isRobot", Ложь);
		Data = ТранспортИнтеграции.local_helper_system_info(Робот);
		
		Если ПустаяСтрока(extsyncdoc_uuid) Тогда
			ПараметрыВызова = Новый Структура("Direction, Data", direction, Data);
		Иначе
			//И почему тут будет новый uuid, а не от предыдущего вызовата? Миша!
			ПараметрыВызова = Новый Структура("Uuid, Direction, Data", extsyncdoc_uuid, direction, Data);
		КонецЕсли; 
		ИнтеграцияДополнитьМассив(context.report.objects_to_write, objects);
		Если context.report.objects_to_write.Количество() > 20 Тогда
			ПолученыйUuid = ТранспортИнтеграции.local_helper_extsyncdoc_write(
				context.params,
				connection_uuid,
				ПараметрыВызова,
				context.report.objects_to_write);
			Если Не ПустаяСтрока(ПолученыйUuid) и ПолученыйUuid <> extsyncdoc_uuid Тогда
				context.operation.Вставить("operation_uuid", ПолученыйUuid);
			КонецЕсли;
			context.report.objects_to_write.Очистить();
			context.report.new = Ложь;
		КонецЕсли;		
		Возврат True;

	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		block_set_variable(context, "_last_error", NewExtExceptionСтрока(ИнфОбОшибке));
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке);
	КонецПопытки;
КонецФункции
// BSLLS:FunctionOutParameter-on

// Функция block_extsyncdoc_write_api3_link
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// direction - Неопределено - Направление
// objects - Структура - Объекты
// заполнять_data_is - Булево - Признак заполнять_data_is
//
// Возвращаемое значение:
//  Массив - Результат выполения функции
//
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS:UnusedLocalVariable-off
//DynamicDirective
Функция block_extsyncdoc_write_api3_link(context, direction, objects, заполнять_data_is = ЛОЖЬ)
	_objects = Новый Массив;
	Для Каждого obj Из objects Цикл
		_id = get_prop(obj, "ИдИС", "");
		ini_name	= "";
		Title = get_prop(obj, "Название", Неопределено);
		Если Title = Неопределено Тогда
			Title = get_prop(obj, "Title", _id);
		КонецЕсли;
		ТипИмяИС = get_prop(obj,"ТипИС","") + "." + get_prop(obj,"ИмяИС","");
		StatusId = get_prop(obj, "StatusId", Неопределено);
		StatusMsg = get_prop(obj, "StatusMsg", Неопределено);
		//obj.Свойство("ini_name", ini_name);
		//# await update_ini(self.executor, context, ini_name)
		_object = Новый Структура(
		"Id, Title, Type, ClientType, ClientId, Data, StatusId, StatusMsg",
		_id,
		Title,
		ТипИмяИС,
		ТипИмяИС,
		_id,
		Новый Структура( "_print_forms", get_prop(obj, "_print_forms")
		//"data_is",
		////"data_is, ini_name",
		//obj,
		////ini_name,
		),
		StatusId,
		StatusMsg
		);                      
		
		Если ЗначениеЗаполнено(get_prop(obj, "ini_name")) Тогда
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
		Endpoint = get_prop(context, "Endpoint", Неопределено);
        Если ЗначениеЗаполнено(Endpoint) Тогда 
            _object.Data.Вставить("endpoint", Endpoint);
        КонецЕсли;
		_objects.Добавить(_object);
	КонецЦикла;
	
	Возврат _objects;
КонецФункции
// BSLLS:UnusedLocalVariable-on

// Функция block_extsyncdoc_write_api3_objects
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// direction - Неопределено - Направление
// objects - Структура - Объекты
//
// Возвращаемое значение:
//  Массив - Результат выполения функции
//
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

//DynamicDirective

Процедура ДобавитьДанныеПоТипуОбъектов(Список, filter)
	Selection = get_prop(filter, "Selection");
	DefaultValueForType = get_prop(Selection, "DefaultValueForType"); 
	Если DefaultValueForType = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Для Каждого Запись Из Список Цикл
		ИмяИС = get_prop(Запись, "ИмяИС");
		Если Не ЗначениеЗаполнено(ИмяИС) Тогда
			Продолжить;
		КонецЕсли;
		ДанныеПоТипу = get_prop(DefaultValueForType, ИмяИС); 
		Если Не ЗначениеЗаполнено(ДанныеПоТипу) Тогда
			Продолжить;
		КонецЕсли;
		Вложения = get_prop(ДанныеПоТипу, "Attachments");
		Запись.Вставить("_print_forms", Вложения);
		Запись.Вставить("ini_name", get_prop(ДанныеПоТипу, "Algorithm"));
		Регламент = get_prop(ДанныеПоТипу, "Regulation"); 
		Запись.Вставить("Регламент", get_prop(Регламент, "НазваниеРегламента"));
		Запись.Вставить("ПроизвольноеНазваниеРегламента", get_prop(Регламент, "ПроизвольноеНазваниеРегламента"));	
	КонецЦикла;	
КонецПроцедуры

// Функция block_extsyncdoc_write_by_filter
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// direction - Неопределено - Направление
// filter - Структура - filter
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
//DynamicDirective
Функция block_extsyncdoc_write_by_filter(context, direction, filter)
	Если Не filter.Selection.MarkedAll Тогда 
		Список = filter.Selection.Marked;
		ДобавитьДанныеПоТипуОбъектов(Список, filter);	
		Возврат block_extsyncdoc_write_api3_link(context, direction, Список);
	КонецЕсли;	
	ПараметрыКоманды = Новый Структура("Filter", filter);
	Selection = get_prop(filter, "Selection");
	DataSets = get_prop(Selection, "DataSets", Новый Массив);
	Для Каждого Algorithm Из DataSets Цикл
		res = load_calc_ini(Algorithm, ПараметрыКоманды, "add_to_report");
		
		Если res.Status = "complete" Тогда
			Продолжить;
		КонецЕсли;	
		
		Если res.Status = "error" И Не (res.Result.message = "Не найден endpoint add_to_report") Тогда
			ВызватьИсключение NewExtExceptionСтрока(, "Ошибка выполнения ini: '" + filter.Algorithm
				+ "', endpoint: 'add_to_report'" + Символы.ПС + res.Result.message,
				res.Result.detail, res.Result.action);
		КонецЕсли;	
		ЕстьЕще = Истина;
		Страница = 0;
		Pagination = Новый Структура();
		Pagination.Вставить("PageSize", 20);
		Пока ЕстьЕще = Истина Цикл
			Pagination.Вставить("Page", Страница);  
			ПараметрыКоманды.Вставить("Pagination", Pagination);
			res = load_calc_ini(Algorithm, ПараметрыКоманды, "main");
			Страница = Страница + 1;
			Если res["Status"] = "error" Тогда
				ВызватьИсключение NewExtExceptionСтрока(, "Ошибка выполнения ini: '" + filter.Algorithm
				+ "', endpoint: 'main'" + Символы.ПС + res.Result.message,
				res.Result.detail, res.Result.action);
			КонецЕсли;	
			Результат = res.Result;
			Список = Результат["Rows"];
			ДобавитьДанныеПоТипуОбъектов(Список, filter);
			block_extsyncdoc_write("import_api3_link", Список, context); 
			Навигация = Результат["Pagination"];
			ЕстьЕще = get_prop(Навигация, "HasMore", Ложь);
		КонецЦикла;
	КонецЦикла;
КонецФункции

