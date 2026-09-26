
// Функция block_connection_public_param_read_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
//DynamicDirective
Функция block_connection_public_param_read_calc_value(block_type, node, path, context, block_context)
	Возврат block_obj_get_path_value(context,"operation.data.public_params."+block_context["NAME"],"") 	
КонецФункции
