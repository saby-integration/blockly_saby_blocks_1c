//DynamicDirective
Функция block_fed_convert_xml_to_object_calc_value(block_type, node, path, context, block_context)
	result = Транспорт.local_helper_fed_convert_xml_to_obj(
				context.params,
				block_context["pattern"],
				block_context["data"]
				);
	Возврат result;
КонецФункции	
