//DynamicDirective
Функция block_saby_find_calc_value(block_type, node, path, context, block_context)
	result = local_helper_find_sbis_object(context.params, block_context.type, block_context.object);
	Возврат result["result"];
КонецФункции
