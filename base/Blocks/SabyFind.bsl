
// Функция block_saby_find_calc_value
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
Функция block_saby_find_calc_value(block_type, node, path, context, block_context)
	result = ТранспортИнтеграции.local_helper_find_sbis_object(context.params, block_context.type, block_context.object);
	Возврат result["result"];
КонецФункции
