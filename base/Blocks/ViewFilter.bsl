
//DynamicDirective

Функция block_view_filter_number_calc_value(block_type, node, path, context, block_context)
	filter = Новый Соответствие;
	copy_block_context(filter, block_context);
	filter["TEMPLATE"] = "filter_number";
	Возврат filter;	
КонецФункции

//DynamicDirective

Функция block_view_filter_string_calc_value(block_type, node, path, context, block_context)
	filter = Новый Соответствие;
	copy_block_context(filter, block_context);
	filter["TEMPLATE"] = "filter_string";
	Возврат filter;		
КонецФункции

//DynamicDirective

Функция block_view_filter_chips_calc_value(block_type, node, path, context, block_context)
	filter = Новый Соответствие;
	filter["NAME"] = block_context["NAME"];
	Items = Новый Массив;
	mutation_count = Число(workspace_find_mutation_by_name(node, "items", 0));
	Если mutation_count Тогда
		Для j = 0 По mutation_count - 1 Цикл
			Item = Новый Соответствие;
			Item.Вставить("KEY", block_context["PARAM" + j + "_KEY"]);
			Item.Вставить("TITLE", block_context["PARAM" + j + "_TITLE"]);
			Если block_context["PARAM" + j + "_DEFAULT_VALUE"] = "TRUE" Тогда
				Item.Вставить("DEFAULT_VALUE", Истина); 
			Иначе
				Item.Вставить("DEFAULT_VALUE", Ложь); 
			КонецЕсли;
			Items.Добавить(Item);
		КонецЦикла;	
	КонецЕсли;
	filter["BUTTONS"] = Items;
	filter["TEMPLATE"] = "filter_chips";
	Возврат filter;
КонецФункции

//DynamicDirective

Функция block_view_filter_period_calc_value(block_type, node, path, context, block_context)
	filter = Новый Соответствие;
	copy_block_context(filter, block_context);
	filter["DEFAULT_VALUE"] = Число(filter["DEFAULT_VALUE"]);
	filter["TEMPLATE"] = "filter_period";
	Возврат filter;
КонецФункции

//DynamicDirective

Функция block_view_filter_link_calc_value(block_type, node, path, context, block_context)
	filter = Новый Соответствие;
	copy_block_context(filter, block_context);
	filter["TEMPLATE"] = "filter_link";
	Если filter["MULTI_SELECT"] = "TRUE" Тогда
		filter["MULTI_SELECT"] = Истина;
	КонецЕсли;
	Возврат filter;
КонецФункции

//DynamicDirective

Функция block_view_filter_enumeration_with_date_calc_value(block_type, node, path, context, block_context)
	filter = Новый Соответствие;
	filter["NAME"] = block_context["NAME"];
	filter["TITLE"] = block_context["TITLE"];
	filter["DEFAULT_VALUE"] = block_context["DEFAULT_VALUE"];
	Items = Новый Массив;
	mutation_count = Число(workspace_find_mutation_by_name(node, "items", 0));
	Если mutation_count Тогда
		Для j = 0 По mutation_count - 1 Цикл
			Item = Новый Соответствие;
			Item.Вставить("VALUE", block_context["PARAM" + j + "_VALUE"]);
			Item.Вставить("TITLE", block_context["PARAM" + j + "_TITLE"]);
			Item.Вставить("PARENT", block_context["PARAM" + j + "_PARENT"]);
			Item.Вставить("IS_FOLDER", block_context["PARAM" + j + "_IS_FOLDER"]);
			Items.Добавить(Item);
		КонецЦикла;	
	КонецЕсли;
	filter["ITEMS"] = Items;
	filter["TEMPLATE"] = "filter_enumeration_with_date";
	Возврат filter;
КонецФункции

//DynamicDirective

Функция block_view_filter_enumeration_calc_value(block_type, node, path, context, block_context)
	filter = Новый Соответствие;
	filter["NAME"] = block_context["NAME"];
	filter["TITLE"] = block_context["TITLE"];
	filter["DEFAULT_VALUE"] = block_context["DEFAULT_VALUE"];
	filter["TEMPLATE"] = "filter_enumeration";
	Items = Новый Массив;
	СчетчикПараметров = 0;
	Пока Истина Цикл
		Ключ = "PARAM"+СчетчикПараметров+"_VALUE";
		ЕстьЗначение = ?(ЗначениеЗаполнено(get_prop(block_context, Ключ)), Истина, Ложь);
		Если ЕстьЗначение Тогда 
			Item = Новый Соответствие;
			Item.Вставить("VALUE", block_context["PARAM"+СчетчикПараметров+"_VALUE"]);
			Item.Вставить("TITLE", block_context["PARAM"+СчетчикПараметров+"_TITLE"]);
			Если block_context["PARAM"+СчетчикПараметров+"_IS_FOLDER"] = "TRUE" Тогда
				Item.Вставить("IS_FOLDER", Истина); 
			Иначе
				Item.Вставить("IS_FOLDER", Ложь); 
			КонецЕсли;	
			Item.Вставить("PARENT", block_context["PARAM"+СчетчикПараметров+"_PARENT"]);
			СчетчикПараметров = СчетчикПараметров + 1;
		Иначе
			Прервать
		КонецЕсли;
		Items.Добавить(Item);
	КонецЦикла;
	filter["ITEMS"] = Items;
	Возврат filter; 
КонецФункции
