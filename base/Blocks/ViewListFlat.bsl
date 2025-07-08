
//DynamicDirective

Функция block_view_list_flat_calc_value(block_type, node, path, context, block_context)
	param = Новый Соответствие;
	copy_block_context(param, block_context);
	param.Вставить("TEMPLATE", "list_flat"); 
	Возврат param;
КонецФункции	

