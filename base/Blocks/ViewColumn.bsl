
// Функция block_view_column_default_calc_value
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
Функция block_view_column_default_calc_value(block_type, node, path, context, block_context)
	param = Новый Соответствие;
	copy_block_context(param, block_context);
	param["TEMPLATE"] = "column_default";
	param["MORE_LOAD"] = (param["MORE_LOAD"] = "TRUE"); 
	param["VISIBLE"] = (param["VISIBLE"] = "TRUE");
	Возврат param;
КонецФункции

// Функция block_view_column_date_number_calc_value
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
Функция block_view_column_date_number_calc_value(block_type, node, path, context, block_context)
	param = Новый Соответствие;
	copy_block_context(param, block_context);
	param["TEMPLATE"] = "column_date_number";
	param["LADDER"] = (param["LADDER"] = "TRUE");
	param["VISIBLE"] = (param["VISIBLE"] = "TRUE");
	Возврат param;
КонецФункции

// Функция block_view_column_document_kedo_calc_value
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
Функция block_view_column_document_kedo_calc_value(block_type, node, path, context, block_context)
	param = Новый Соответствие;
	copy_block_context(param, block_context);
	param["TEMPLATE"] = "column_document_kedo";
	param["VISIBLE"] = (param["VISIBLE"] = "TRUE");
	Возврат param;
КонецФункции

// Функция block_view_column_employee_calc_value
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
Функция block_view_column_employee_calc_value(block_type, node, path, context, block_context)
	param = Новый Соответствие;
	copy_block_context(param, block_context);
	param["TEMPLATE"] = "column_employee";
	param["VISIBLE"] = (param["VISIBLE"] = "TRUE");
	Возврат param;
КонецФункции

// Функция block_view_column_icon_calc_value
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
Функция block_view_column_icon_calc_value(block_type, node, path, context, block_context)
	param = Новый Соответствие;
	copy_block_context(param, block_context);
	param["TEMPLATE"] = "column_icon";
	param["VISIBLE"] = (param["VISIBLE"] = "TRUE");
	Возврат param;
КонецФункции

