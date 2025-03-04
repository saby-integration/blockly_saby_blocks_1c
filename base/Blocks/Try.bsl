
// Функция block_try_calc_value
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
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS:FunctionReturnsSamePrimitive-off
//DynamicDirective
Функция block_try_calc_value(block_type, node, path, context, block_context)
	Попытка
		node_try = workspace_find_statement_by_name(node, "try");
		Если node_try = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		block_execute_all_next(node_try, path, context, block_context, True);	
	Исключение
		Если block_context.Свойство("child") Тогда
			block_context.Удалить("child");	
		КонецЕсли;	
		node_except = workspace_find_statement_by_name(node, "except");
		Если node_except = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		block_execute_all_next(node_except, path, context, block_context, True);	
	КонецПопытки;
	Возврат Неопределено;
КонецФункции
// BSLLS:FunctionReturnsSamePrimitive-on
