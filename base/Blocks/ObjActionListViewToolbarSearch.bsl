Функция block_obj_action_list_view_toolbar_search_calc_value(block_type, node, path, context, block_context)
	param = Новый Соответствие;
	copy_block_context(param, block_context);
	param["Type"] = "Search";
	Возврат param;
КонецФункции	