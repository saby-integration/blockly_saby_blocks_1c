
// Функция block_get_current_datetime_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Дата - Результат выполения функции
//
// BSLLS:DeprecatedCurrentDate-off
//DynamicDirective
Функция block_get_current_datetime_calc_value(block_type, node, path, context, block_context)
	// ТекущаяДатаСеанса нельзя тк метод не поддерживается на клиенте
	Возврат ТекущаяДата();
КонецФункции
// BSLLS:DeprecatedCurrentDate-on
