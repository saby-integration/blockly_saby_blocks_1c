
// Функция block_extsys_calc_ini_calc_value
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

Функция block_extsys_calc_ini_calc_value(block_type, node, path, context, block_context)
	block_context.Вставить("NAME", block_context.INI_NAME);
	Возврат block_execute_workspace_calc_value(block_type, node, path, context, block_context);
КонецФункции      
