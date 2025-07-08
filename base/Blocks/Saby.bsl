
// Функция block_saby_calc_value
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
Функция block_saby_calc_value(block_type, node, path, context, block_context)
    result = ТранспортИнтеграции.local_helper_exec_method(context.params,block_context.METHOD, block_context.PARAMS);	
	Возврат ТранспортИнтеграции.local_helper_api_process_responce(result);
КонецФункции	
