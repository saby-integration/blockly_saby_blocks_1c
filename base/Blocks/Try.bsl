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

