
// Функция block_connection_public_param_update_calc_value
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
Функция block_connection_public_param_update_calc_value(block_type, node, path, context, block_context)
	NAME = block_context["NAME"];
	VALUE = block_context["VALUE"];	
	block_obj_set_path_value(context,"operation.data.public_params."+NAME, VALUE);	
	block_obj_set_path_value(context,"operation.update_public_params."+NAME, VALUE);		
	Возврат Неопределено;
КонецФункции
