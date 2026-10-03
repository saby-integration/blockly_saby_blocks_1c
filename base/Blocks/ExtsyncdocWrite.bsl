
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
	required_param = Новый Массив;
	required_param.Добавить("direction");
	required_param.Добавить("objects");
	block_check_required_param_in_block_context(required_param, block_context);
	direction	= block_context.direction;
	objects		= block_context.objects;
	run	= get_prop(block_context, "run", Ложь);
	Возврат block_extsyncdoc_write2(direction, objects, context, run);
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
// run - Булево - Необходимо запустить фоновый обмен	
//
// Возвращаемое значение:
//  Строка - Результат выполения функции
//
// BSLLS:FunctionOutParameter-off
// нельзя откзаться от установки значения в objects
//DynamicDirective
Функция block_extsyncdoc_write(direction, objects, context, run = Ложь)
			
	Если direction = "import" Тогда
		direction = 1;
		ЗаполнитьActionПоDirection(objects, direction);
	ИначеЕсли direction = "export" Тогда
		direction = 0;
		ЗаполнитьActionПоDirection(objects, direction);
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
	
	Попытка
		context.report.new = Ложь;
		report_add_objects(objects, run);
		Возврат True;
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		block_set_variable(context, "_last_error", NewExtExceptionСтрока(ИнфОбОшибке));
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке);
	КонецПопытки;
КонецФункции

// Функция block_extsyncdoc_write2
//
// Параметры:
// direction - Неопределено - Направление
// objects - Структура - Объекты
// context - Соответствие - Контекст исполняемого блока
// run - Булево - Необходимо запустить фоновый обмен	
//
// Возвращаемое значение:
//  Строка - Результат выполения функции
//
// BSLLS:FunctionOutParameter-off
// нельзя откзаться от установки значения в objects
//DynamicDirective
Функция block_extsyncdoc_write2(direction, objects, context, run = Ложь)
	
	Если direction = "import" Тогда
		direction = 1;
	ИначеЕсли direction = "export" Тогда
		direction = 0;
	ИначеЕсли direction = "import_api3_obj" Тогда
		direction = 1;
		objects = block_extsyncdoc_write_api3_objects(context, direction, objects);
	ИначеЕсли direction = "export_by_filter" Тогда
		direction = 0;
		objects = block_extsyncdoc_write2_by_filter(context, direction, objects, run);
	ИначеЕсли direction = "import_by_filter" Тогда
		direction = 1;
		objects = block_extsyncdoc_write2_by_filter(context, direction, objects, run);
	Иначе
		ВызватьИсключение "Неподдерживаемый тип направления обмена";
	КонецЕсли;
	
	context.report.Вставить("direction", direction);
	
	Попытка
		context.report.new = Ложь;
		report_add_objects(objects, run);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		block_set_variable(context, "_last_error", NewExtExceptionСтрока(ИнфОбОшибке));
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке);
	КонецПопытки;

	Возврат True;
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
// BSLLS:CognitiveComplexity-off
//DynamicDirective
Функция block_extsyncdoc_write_api3_link(context, direction, objects, заполнять_data_is = Ложь)
	
	Если direction = 0 Тогда
		action = 2;
	ИначеЕсли direction = 1 Тогда
		action = 1;
	Иначе
		ВызватьИсключение "Неподдерживаемый тип направления обмена";
	КонецЕсли;
	
	_objects = Новый Массив;
	Для Каждого obj Из objects Цикл
		_id = get_prop(obj, "ИдИС", "");
		ini_name	= "";
		Title = get_prop(obj, "Название", Неопределено);
		Если Title = Неопределено Тогда
			Title = get_prop(obj, "Title", _id);
		КонецЕсли;
		ТипИС = get_prop(obj,"ТипИС");
		Если ЗначениеЗаполнено(ТипИС) Тогда
			ТипИмяИС = ТипИС + "." + get_prop(obj,"ИмяИС","");
		Иначе
			ТипИмяИС = get_prop(obj,"ИмяИС","");
		КонецЕсли;
		SbisId = get_prop(obj, "ИдСБИС", Неопределено);
		StatusId = get_prop(obj, "StatusId", Неопределено);
		StatusMsg = get_prop(obj, "StatusMsg", Неопределено); 
		Data = get_prop(obj, "Data", Новый Структура( "_print_forms", get_prop(obj, "_print_forms")));
		error = get_prop(Data, "error");
		data_is = get_prop(Data, "data_is");
		Если data_is <> Неопределено И StatusId = Неопределено Тогда 
			StatusId = "Получен";	
		КонецЕсли;	
		Если error <> Неопределено И StatusId = Неопределено Тогда 
			StatusId = "Ошибка";	
			StatusMsg = Строка(error);	
		КонецЕсли;	
		//obj.Свойство("ini_name", ini_name);
		//# await update_ini(self.executor, context, ini_name)
		// BSLLS:NumberOfValuesInStructureConstructor-off
		_object = Новый Структура(
		"Id, Title, Type, ClientType, ClientId, Data, StatusId, StatusMsg, SbisId, Action",
		_id, Title, ТипИмяИС, ТипИмяИС,	_id,	Data, StatusId, StatusMsg, SbisId, action);                      
		// BSLLS:NumberOfValuesInStructureConstructor-on
		
		Если ЗначениеЗаполнено(get_prop(obj, "ini_name")) Тогда
			_object.Data.Вставить("ini_name", obj.ini_name);	
		КонецЕсли;
		Если ЗначениеЗаполнено(get_prop(obj, "Регламент")) Тогда
			_object.Data.Вставить("Регламент", obj.Регламент);	
		КонецЕсли;
		Если ЗначениеЗаполнено(get_prop(obj, "ПроизвольноеНазваниеРегламента")) Тогда
			_object.Data.Вставить("ПроизвольноеНазваниеРегламента", obj.ПроизвольноеНазваниеРегламента);	
		КонецЕсли;
		Если data_is = Неопределено И заполнять_data_is = Истина Тогда 
			_object.Data.Вставить("data_is",obj);
		КонецЕсли;
		Endpoint = get_prop(context, "Endpoint", Неопределено);
        Если ЗначениеЗаполнено(Endpoint) Тогда 
            _object.Data.Вставить("endpoint", Endpoint);
        КонецЕсли;
		_objects.Добавить(_object);
	КонецЦикла;
	
	Возврат _objects;
КонецФункции
// BSLLS:CognitiveComplexity-on
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
	
	Если direction = 0 Тогда
		action = 2;
	ИначеЕсли direction = 1 Тогда
		action = 1;
	Иначе
		ВызватьИсключение "Неподдерживаемый тип направления обмена";
	КонецЕсли;
	
	_objects = Новый Массив;
	Для Каждого obj Из objects Цикл
		ПроверитьНаличиеОбязательныхПараметров(obj, "ИдИС,Название,ИмяИС");
		_id = obj["ИдИС"];
		ini_name = get_prop(obj, "ini_name");
		Data = Новый Структура("data_is",obj);
		Если ЗначениеЗаполнено(ini_name) Тогда
			Data.Вставить("ini_name", ini_name);
		КонецЕсли;
		ТипИС = get_prop(obj,"ТипИС");
		Если ЗначениеЗаполнено(ТипИС) Тогда
			ТипИмяИС = ТипИС + "." + get_prop(obj,"ИмяИС","");
		Иначе
			ТипИмяИС = get_prop(obj,"ИмяИС","");
		КонецЕсли;
		_object = Новый Структура("Title, ClientType, ClientId, Data, StatusId",
		?(obj["Название"]<>неопределено, obj["Название"], _id),
		ТипИмяИС,
		_id,
		Data,
		"Получен");
		ИдСБИС = get_prop(obj, "ИдСБИС");
		Если ЗначениеЗаполнено(ИдСБИС) Тогда
			_object.Вставить("SbisId", ИдСБИС);
		КонецЕсли;
		ИмяСБИС = get_prop(obj, "ИмяСБИС");
		Если ЗначениеЗаполнено(ИмяСБИС) Тогда
			_object.Вставить("SbisType", ИмяСБИС);
		КонецЕсли;
		_object.Вставить("Action", action);
		_objects.Добавить(_object);
	КонецЦикла;	
	Возврат _objects;
КонецФункции

// Функция ESOПоAPI3
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// СписокОбъектов - Массив - Объекты
// direction - Неопределено - Направление
//
// Возвращаемое значение:
//  Массив - Результат выполения функции - массив ESO объектов
//
//DynamicDirective
Функция ESOПоAPI3(context, СписокОбъектов, direction)
	МассивESO = Новый Массив;
	TextStatusMsg = "StatusMsg";
	TextStatusId = "StatusMsg";
	Для Каждого ЭлементAPI3 Из СписокОбъектов Цикл
		СформироватьAPI3СсылкуИзЭлементаСписка(ЭлементAPI3);
		ЭлементESO = Новый Структура;
		_id = get_prop(ЭлементAPI3, "ИдИС", "");
		Title = get_prop(ЭлементAPI3, "Название", _id);
		ЭлементESO.Вставить("Title", Title);
		ТипИС = get_prop(ЭлементAPI3,"ТипИС");
		Если ЗначениеЗаполнено(ТипИС) Тогда
			ТипИмяИС = ТипИС + "." + get_prop(ЭлементAPI3, "ИмяИС", "");
		Иначе
			ТипИмяИС = get_prop(ЭлементAPI3, "ИмяИС");
		КонецЕсли;
		ЭлементESO.Вставить("ClientType", ТипИмяИС);
		ЭлементESO.Вставить("ClientId", get_prop(ЭлементAPI3, "ИдИС"));
		Если ЗначениеЗаполнено(get_prop(ЭлементAPI3, TextStatusId)) Тогда
			ЭлементESO.Вставить(TextStatusId, get_prop(ЭлементAPI3, "StatusId"));
		КонецЕсли;
		Если ЗначениеЗаполнено(get_prop(ЭлементAPI3, TextStatusMsg)) Тогда
			ЭлементESO.Вставить(TextStatusMsg, get_prop(ЭлементAPI3, TextStatusMsg));
		КонецЕсли;
		ЭлементESO.Вставить("SbisId", get_prop(ЭлементAPI3, "ИдСБИС"));
		ЭлементESO.Вставить("SbisType", get_prop(ЭлементAPI3, "ИмяСБИС"));
		
		Data = Новый Структура();
		Если direction = 0 Тогда
			// Export
			ЭлементESO.Вставить("Type", get_prop(ЭлементAPI3, "ИмяСБИС"));
			Data.Вставить("data", ЭлементAPI3);
		Иначе
			// Import
			ЭлементESO.Вставить("Type", get_prop(ЭлементAPI3, "ИмяИС"));
			Data.Вставить("data_is", ЭлементAPI3);
		КонецЕсли;

		Endpoint = get_prop(context, "Endpoint");
		Если ЗначениеЗаполнено(Endpoint) Тогда
		    Data.Вставить("endpoint", Endpoint);
		КонецЕсли;
		
		ini_name = get_prop(ЭлементAPI3, "ini_name");
		Если ЗначениеЗаполнено(ini_name) Тогда
			Data.Вставить("ini_name", ini_name);
		КонецЕсли;
		
		ЭлементESO.Вставить("Data", Data);
		МассивESO.Добавить(ЭлементESO);
	КонецЦикла;

	Возврат МассивESO;
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
		
		Если get_prop(Запись, "ТипИС", "") = "" Тогда
			МассивТипов = Saby_СтрРазделить82(Запись["ИмяИС"],".");
			ИмяИСДляДефолтныхЗначений = МассивТипов[1];
		Иначе
			ИмяИСДляДефолтныхЗначений = ИмяИС;
		КонецЕсли;
		ДанныеПоТипу = get_prop(DefaultValueForType, ИмяИСДляДефолтныхЗначений); 
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

//DynamicDirective
Функция СформироватьAPI3СсылкуИзЭлементаСписка(ЭлементСписка)
	API3_ref = ЭлементСписка;
	ВставитьСвойствоЕслиНет(API3_ref, "ИдИС", get_prop(API3_ref, "ИдИС"));
	ВставитьСвойствоЕслиНет(API3_ref, "ТипИС", get_prop(API3_ref, "ТипИС"));
	ВставитьСвойствоЕслиНет(API3_ref, "ИмяИС", get_prop(API3_ref, "ИмяИС"));
	ВставитьСвойствоЕслиНет(API3_ref, "ТипСБИС", get_prop(API3_ref, "ТипСБИС"));
	ВставитьСвойствоЕслиНет(API3_ref, "ИмяСБИС", get_prop(API3_ref, "ИмяСБИС"));
	ВставитьСвойствоЕслиНет(API3_ref, "ИдСБИС", get_prop(API3_ref, "ИдСБИС"));
	Data = get_prop(ЭлементСписка, "Data", Новый Структура);
	Для Каждого ЭлементData Из Data Цикл
		API3_ref.Вставить(ЭлементData.Ключ, ЭлементData.Значение);
	КонецЦикла;
	API3_ref.Удалить("Data");
	Возврат API3_ref;  
КонецФункции

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
// BSLLS:CognitiveComplexity-off
Функция block_extsyncdoc_write_by_filter(context, direction, filter)
	TextSelection = "Selection";
	Если Не filter[TextSelection]["MarkedAll"] Тогда 
		Список = filter[TextSelection]["Marked"];
		СписокAPI3Ссылки = Новый Массив;
		Для Каждого ЭлементСписка Из Список Цикл
			СписокAPI3Ссылки.Добавить(СформироватьAPI3СсылкуИзЭлементаСписка(ЭлементСписка));
		КонецЦикла;
		ДобавитьДанныеПоТипуОбъектов(СписокAPI3Ссылки, filter);	
		Возврат block_extsyncdoc_write_api3_link(context, direction, СписокAPI3Ссылки, Истина);
	КонецЕсли;	
	
	ПараметрыКоманды = Новый Структура("Filter", filter);
	Selection = get_prop(filter, TextSelection);
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
		РазмерСтраницы = 20;
		Pagination.Вставить("PageSize", РазмерСтраницы);
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
			СписокAPI3Ссылки = Новый Массив;
			Для Каждого ЭлементСписка Из Список Цикл
				СписокAPI3Ссылки.Добавить(СформироватьAPI3СсылкуИзЭлементаСписка(ЭлементСписка));
			КонецЦикла;
			ДобавитьДанныеПоТипуОбъектов(СписокAPI3Ссылки, filter);
			block_extsyncdoc_write("import_api3_link", СписокAPI3Ссылки, context); 
			Навигация = Результат["Pagination"];
			ЕстьЕще = get_prop(Навигация, "HasMore", Ложь);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Новый Массив;
КонецФункции
// BSLLS:CognitiveComplexity-on

Процедура block_extsyncdoc_write2_checkerror(res, filter)
	Если res["Status"] = "error" И Не (res.Result.message = "Не найден endpoint add_to_report") Тогда
		ВызватьИсключение NewExtExceptionСтрока(, "Ошибка выполнения ini: '" + filter.Algorithm
		+ "', endpoint: 'main'" + Символы.ПС + res.Result.message,
		res.Result.detail, res.Result.action);
	КонецЕсли;	
КонецПроцедуры

// Функция block_extsyncdoc_write2_by_filter
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// direction - Неопределено - Направление
// filter - Структура - filter
// run - Булево - Необходимо запустить фоновый обмен	
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
//DynamicDirective
Функция block_extsyncdoc_write2_by_filter(context, direction, filter, run)
	TextSelection = "Selection";
	Если Не filter[TextSelection]["MarkedAll"] Тогда
		Список = filter[TextSelection]["Marked"];
		ДобавитьДанныеПоТипуОбъектов(Список, filter);
		Возврат ESOПоAPI3(context, Список, direction);
	КонецЕсли;	
	
	context_data = get_prop(context, "data");
	OperationParams = get_prop(context_data, "EndpointArgs");
	ПараметрыКоманды = Новый Структура("Filter, OperationParams", filter, OperationParams);
	Selection = get_prop(filter, TextSelection);
	МассивDataSets = get_prop(Selection, "DataSets", Новый Массив);
	
	Для Каждого Algorithm Из МассивDataSets Цикл
		result = load_calc_ini(Algorithm, ПараметрыКоманды, "add_to_report");
		
		Если result.Status = "complete" Тогда
			Продолжить;
		КонецЕсли;	
		
		block_extsyncdoc_write2_checkerror(result, filter);
		
		ЕстьЕщеДанные = Истина;
		Страница = 0;
		Pagination = Новый Структура();
		РазмерСтраницы = 20;
		Pagination.Вставить("PageSize", РазмерСтраницы);
		Пока ЕстьЕщеДанные = Истина Цикл
			Pagination.Вставить("Page", Страница);  
			ПараметрыКоманды.Вставить("Pagination", Pagination);
			result = load_calc_ini(Algorithm, ПараметрыКоманды, "main");
			Страница = Страница + 1;
			Если result["Status"] = "error" Тогда
				ВызватьИсключение NewExtExceptionСтрока(, "Ошибка выполнения ini: '" + filter.Algorithm
				+ "', endpoint: 'main'" + Символы.ПС + result.Result.message,
				result.Result.detail, result.Result.action);
			КонецЕсли;	
			Результат = result.Result;
			Список = Результат["Rows"];

			ДобавитьДанныеПоТипуОбъектов(Список, filter);
			МассивESO = ESOПоAPI3(context, Список, direction);
			operation = "export";
			Если direction = 1 Тогда
				operation = "import";
			КонецЕсли;
			block_extsyncdoc_write2(operation, МассивESO, context, run);

			Навигация = Результат["Pagination"];
			ЕстьЕщеДанные = get_prop(Навигация, "HasMore", Ложь);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Новый Массив;
КонецФункции

//DynamicDirective

Процедура block_extsyncdoc_write_run(ПараметрыВыполнения, РезультатВыполнения = Неопределено) Экспорт
	Если context = Неопределено Тогда
		context = get_prop(ПараметрыВыполнения, "context");
	КонецЕсли;	
	direction = get_prop(context.report, "direction", 1);
	block_context = Новый Структура;
	block_context.Вставить("prepare_counter", 0);
	Если direction = 1 Тогда //Из 1С в СБИС 
		block_extsyncdoc_run_extsyncdoc_prepare_is(context, block_context);
		block_extsyncdoc_run_extsyncdoc_execute_saby_lrs2(context, block_context);
	ИначеЕсли direction = 2 или direction = 0 Тогда //Из СБИС в 1С
		//result = block_extsyncdoc_run_process_commands_result(context, block_context);
		block_extsyncdoc_run_extsyncdoc_prepare_saby(context, block_context);
		block_extsyncdoc_run_extsyncdoc_execute_is(context, block_context);
		// Сохраняем идентичность со структурой кода в Питоне
		// BSLLS:EmptyCodeBlock-off
	Иначе
		// ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,add_block_to_dump(block_context));
	КонецЕсли;
	
КонецПроцедуры

// Процедура ЗаполнитьActionПоDirection
//
// Параметры:
// objects - Массив - Массив объектов
// direction - Целое - Идентификатор направления в котором происходит синхронизация.
//                      1 - из ИС в СБИС, 2 - из СБИС в ИС.
//
//DynamicDirective
Процедура ЗаполнитьActionПоDirection(objects, direction)
	Если direction = 0 Тогда
		action = 2;
	ИначеЕсли direction = 1 Тогда
		action = 1;
	Иначе
		ВызватьИсключение "Неподдерживаемый тип направления обмена";
	КонецЕсли;
	
	Для Каждого object Из objects Цикл
		object.Вставить("Action", action);
	КонецЦикла;	
КонецПроцедуры
