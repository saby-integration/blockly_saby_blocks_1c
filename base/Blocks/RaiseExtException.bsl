Функция block_raise_ext_exception_calc_value(block_type, node, path, context, block_context)
	ВызватьИсключение NewExtExceptionСтрока(get_prop(block_context, "parent"), 
											get_prop(block_context, "message"), 
											get_prop(block_context, "detail"),
											get_prop(block_context, "action"),
											get_prop(block_context, "dump"),
											get_prop(block_context, "type"));

КонецФункции

