Функция block_fed_convert_object_to_xml_calc_value(block_type, node, path, context, block_context)
	result = local_helper_fed_convert_obj_to_xml(
				context.params,
				block_context["data"],
				block_context["format"],
				block_context["version"],
				block_context["pattern"]
				);
	Возврат result;	
КонецФункции	
