Функция block_extsys_calc_ini_calc_value(block_type, node, path, context, block_context)
	block_context.Вставить("NAME", block_context.INI_NAME);
	Возврат block_execute_workspace_calc_value(block_type, node, path, context, block_context);
КонецФункции      
