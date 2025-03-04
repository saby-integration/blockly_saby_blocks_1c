
// Функция block_raise_ext_exception_calc_value
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
// Возврата ни когда не будет
// BSLLS:FunctionShouldHaveReturn-off
Функция block_raise_ext_exception_calc_value(block_type, node, path, context, block_context)
	ВызватьИсключение NewExtExceptionСтрока(get_prop(block_context, "parent"), 
											get_prop(block_context, "message"), 
											get_prop(block_context, "detail"),
											get_prop(block_context, "action"),
											get_prop(block_context, "dump"),
											get_prop(block_context, "type"));

КонецФункции
// BSLLS:FunctionShouldHaveReturn-on
