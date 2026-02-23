
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
	
	actions = Новый Массив();
	action = Новый Структура("Begin, End, Title", begin, end, "Обновление статусов ИС");
	actions.Добавить(fill_action(action, 0, get_prop(block_context, "ИмяИС")));
		
	object = Новый Структура("ClientType, ClientId",
		get_prop(block_context, "ИмяИС"),
		get_prop(block_context, "ИдИС")
	); 
	object.Вставить("Actions", actions);	
	report_add_objects(object);
	Возврат Неопределено;
КонецФункции
