
//DynamicDirective

Функция block_view_list_hierarchical_calc_value(block_type, node, path, context, block_context)
	param = Новый Соответствие;
	copy_block_context(param, block_context);
	param.Вставить("TEMPLATE", "list_hierarchical"); 
	ОписаниеТипа = Новый ОписаниеТипов("Число");
	PAGE_SIZE = ОписаниеТипа.ПривестиЗначение(get_prop(param, "PAGE_SIZE", 25)); 
	param.Вставить("PAGE_SIZE", PAGE_SIZE); 
	Возврат param;
КонецФункции	

