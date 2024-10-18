//DynamicDirective
Функция block_saby_calc_value(block_type, node, path, context, block_context)
    result = Транспорт.local_helper_exec_method(context.params,block_context.METHOD, block_context.PARAMS);	
	Возврат Транспорт.local_helper_api_process_responce(result);
КонецФункции	
