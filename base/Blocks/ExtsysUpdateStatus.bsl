
// Функция block_extsys_update_status2_calc_value
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
Функция block_extsys_update_status2_calc_value(block_type, node, path, context, block_context)
	begin = ДатаВМиллисекундах();
	
	СтатусыДокументовОбновитьПоUID(
		get_prop(block_context, "UID"),
		get_prop(block_context, "ACTIVE_STAGE"), 
		get_prop(block_context, "STATE_CODE"),
		,
		get_prop(block_context, "ИмяИС"),
		get_prop(block_context, "ИдИС"), 
		get_prop(block_context, "SbisID")
	);
	end = ДатаВМиллисекундах();
	
	
	Data_message = Новый Структура;
	Data_message.Вставить("UID", get_prop(block_context, "UID"));
	Data_message.Вставить("ACTIVE_STAGE", get_prop(block_context, "ACTIVE_STAGE"));
	Data_message.Вставить("STATE_CODE", get_prop(block_context, "STATE_CODE"));
	Data_message.Вставить("ИмяИС", get_prop(block_context, "ИмяИС"));
	Data_message.Вставить("ИдИС", get_prop(block_context, "ИдИС"));
	Data_message.Вставить("SbisID", get_prop(block_context, "SbisID"));
	
	Data = Новый Структура;
	Data.Вставить("Key", Data_message); 
	
	block_saby_execute_action_write_esoaction_on_obj(begin, end, "Обновление статусов ИС", 
						get_prop(block_context, "ИмяИС"), Data);
	
	Возврат Неопределено;

КонецФункции

Функция block_extsys_update_status3_UID_by_OBJECT(OBJECT)  
	UID = get_prop(OBJECT, "Идентификатор"); // Для документ и event
	Если UID = Неопределено Тогда
		UID = block_obj_get_path_value(OBJECT, "Data.data_is.ИдСБИСВИ", ""); // Для объекта синхронизации из 1С в Saby 
	КонецЕсли;	
	Если UID = Неопределено Тогда
		UID = block_obj_get_path_value(OBJECT, "Data.data.ИдентификаторВИ", ""); // Для объекта синхронизации из Saby в 1C
	КонецЕсли;
	Если UID = Неопределено Тогда
		UID = get_prop(OBJECT, "SbisId"); // Для объекта синхронизации
	КонецЕсли;
	Возврат UID;
КонецФункции	

Функция block_extsys_update_status3_get_api3obj(OBJECT, ACTIVE_STAGE, STATE_CODE)
	UID = block_extsys_update_status3_UID_by_OBJECT(OBJECT);	
	ИмяИС = get_prop(OBJECT, "СlientType", get_prop(OBJECT, "ИмяИС"));
	ИдИС = get_prop(OBJECT, "ClientId", get_prop(OBJECT, "ИдИС"));
	ИдСБИС = get_prop(OBJECT, "SbisId");
	
	СтатусыДокументовОбновитьПоUID(UID, ACTIVE_STAGE, STATE_CODE,, ИмяИС, ИдИС, ИдСБИС);  
	Выборка = СтатусыДокументовПрочитатьПоUID(UID);
	Пока Выборка.Следующий() Цикл   
		API3Obj = Api3Object(Выборка.Объект, Неопределено);
		API3Obj.Вставить("ИдСБИС", ИдСБИС);
		Возврат API3Obj;
	КонецЦикла;
	Возврат Неопределено;	
КонецФункции

// Функция block_extsys_update_status3_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Соответствие - API3 объект или Неопределено
//
//DynamicDirective
Функция block_extsys_update_status3_calc_value(block_type, node, path, context, block_context)
	begin = ДатаВМиллисекундах();
	Результат = Неопределено;
	Title = "Обновление статусов ИС"; 
	Попытка
		OBJECT = get_prop(block_context, "OBJECT");
		Если OBJECT <> Неопределено Тогда
			ACTIVE_STAGE = get_prop(block_context, "ACTIVE_STAGE");
			STATE_CODE = get_prop(block_context, "STATE_CODE");
			Результат = block_extsys_update_status3_get_api3obj(OBJECT, ACTIVE_STAGE, STATE_CODE);
		КонецЕсли;	
		Если Результат = Неопределено Тогда
			Возврат Результат;
		КонецЕсли;	
		end = ДатаВМиллисекундах();
		
		actions = Новый Массив();
		action = Новый Структура("Begin, End, Title", begin, end, Title);
		actions.Добавить(fill_action(action, 0, get_prop(Результат, "ИмяИС")));
		
		object = Новый Структура("ClientType, ClientId",
		get_prop(Результат, "ИмяИС"),
		get_prop(Результат, "ИдИС")
		); 
		object.Вставить("Actions", actions);
		report_add_objects(object);
	Исключение 
		ИнфОбОшибке = ОписаниеОшибки(); 
		ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
		Data = Новый Структура;
		Data.Вставить("message", get_prop(ОшибкаСтруктура, "message"));
		Data.Вставить("detail", get_prop(ОшибкаСтруктура, "detail"));
		end = ДатаВМиллисекундах();
		block_saby_execute_action_write_esoaction_on_obj(begin, end, Title, "", Data,, 100);	
	КонецПопытки;
	Возврат Результат;
КонецФункции
