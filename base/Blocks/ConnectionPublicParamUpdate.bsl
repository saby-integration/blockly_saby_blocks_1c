//DynamicDirective
Функция block_connection_public_param_update_calc_value(block_type, node, path, context, block_context)
	NAME = block_context["NAME"];
	VALUE = block_context["VALUE"];	
	block_obj_set_path_value(context,"operation.data.public_params."+NAME, VALUE);	
	block_obj_set_path_value(context,"operation.update_public_params."+NAME, VALUE);		
КонецФункции

