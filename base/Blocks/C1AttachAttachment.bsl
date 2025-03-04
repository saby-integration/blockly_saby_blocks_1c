
// Функция block_c1_attach_attachment_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Неопределено - Результат выполения функции
//
//DynamicDirective
Функция block_c1_attach_attachment_calc_value(block_type, node, path, context, block_context)
	ЗагрузитьВложение(get_prop(block_context, "DOCUMENT"), get_prop(block_context, "FILE"), get_prop(block_context, "NAME"), context, block_context);
	Возврат Неопределено;
КонецФункции
