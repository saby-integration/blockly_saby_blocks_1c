
// Функция block_api3_link_calc_value
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
Функция block_api3_link_calc_value(block_type, node, path, context, block_context)
	param = Новый Структура("ИдИС, ТипИС, ИмяИС, ini_name, Название, _print_forms");
	ЗаполнитьЗначенияСвойств(param, block_context);
	Возврат param;	
КонецФункции
