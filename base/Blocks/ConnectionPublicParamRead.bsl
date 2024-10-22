//DynamicDirective
Функция block_connection_public_param_read_calc_value(block_type, node, path, context, block_context)
	
	Возврат block_obj_get_path_value(context,"operation.data.public_params."+block_context["NAME"],"") 	
	
КонецФункции

