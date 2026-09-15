
// Функция block_api3_revocationreason_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Соответствие - Результат выполнения функции
//
//DynamicDirective
Функция block_api3_revocationreason_calc_value(block_type, node, path, context, block_context)
	Возврат ЗаполнитьЗначенияApi3Objects(Неопределено, "ПричинаОтзываИзОтпуска", block_context);
КонецФункции
