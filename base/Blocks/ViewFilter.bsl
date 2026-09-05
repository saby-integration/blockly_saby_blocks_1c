
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
	ЭлементыСписка = Новый Массив;
	mutation_count = Число(workspace_find_mutation_by_name(node, "items", 0));
	Если mutation_count Тогда
		Для j = 0 По mutation_count - 1 Цикл
			ЭлементСписка = Новый Соответствие;
			ЭлементСписка.Вставить("KEY", block_context["PARAM" + j + "_KEY"]);
			ЭлементСписка.Вставить("TITLE", block_context["PARAM" + j + "_TITLE"]);
			Если block_context["PARAM" + j + "_DEFAULT_VALUE"] = "TRUE" Тогда
				ЭлементСписка.Вставить("DEFAULT_VALUE", Истина); 
			Иначе
				ЭлементСписка.Вставить("DEFAULT_VALUE", Ложь); 
			КонецЕсли;
			ЭлементыСписка.Добавить(ЭлементСписка);
		КонецЦикла;	
	КонецЕсли;
	filter["BUTTONS"] = ЭлементыСписка;
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
	ЭлементыСписка = Новый Массив;
	mutation_count = Число(workspace_find_mutation_by_name(node, "items", 0));
	Если mutation_count Тогда
		Для j = 0 По mutation_count - 1 Цикл
			ЭлементСписка = Новый Соответствие;
			ЭлементСписка.Вставить("VALUE", block_context["PARAM" + j + "_VALUE"]);
			ЭлементСписка.Вставить("TITLE", block_context["PARAM" + j + "_TITLE"]);
			ЭлементСписка.Вставить("PARENT", block_context["PARAM" + j + "_PARENT"]);
			ЭлементСписка.Вставить("IS_FOLDER", block_context["PARAM" + j + "_IS_FOLDER"]);
			ЭлементыСписка.Добавить(ЭлементСписка);
		КонецЦикла;	
	КонецЕсли;
	filter["ITEMS"] = ЭлементыСписка;
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
	ЭлементыСписка = Новый Массив;
	СчетчикПараметров = 0;
	Пока Истина Цикл
		Ключ = "PARAM" + СчетчикПараметров + "_TITLE";
		ЕстьЗначение = ?(ЗначениеЗаполнено(get_prop(block_context, Ключ)), Истина, Ложь);
		Если ЕстьЗначение Тогда 
			ЭлементСписка = Новый Соответствие;
			ЭлементСписка.Вставить("VALUE", block_context["PARAM" + СчетчикПараметров + "_VALUE"]);
			ЭлементСписка.Вставить("TITLE", block_context["PARAM" + СчетчикПараметров + "_TITLE"]);
			Если block_context["PARAM" + СчетчикПараметров + "_IS_FOLDER"] = "TRUE" Тогда
				ЭлементСписка.Вставить("IS_FOLDER", Истина); 
			Иначе
				ЭлементСписка.Вставить("IS_FOLDER", Ложь); 
			КонецЕсли;	
			ЭлементСписка.Вставить("PARENT", block_context["PARAM" + СчетчикПараметров + "_PARENT"]);
			СчетчикПараметров = СчетчикПараметров + 1;
		Иначе
			Прервать
		КонецЕсли;
		ЭлементыСписка.Добавить(ЭлементСписка);
	КонецЦикла;
	filter["ITEMS"] = ЭлементыСписка;
	Возврат filter; 
КонецФункции

//DynamicDirective

Функция block_view_filter_bool_calc_value(block_type, node, path, context, block_context)
	filter = Новый Соответствие;
	copy_block_context(filter, block_context);
	Если filter["DEFAULT_VALUE"] = "TRUE" Тогда
		filter["DEFAULT_VALUE"] = Истина;
	Иначе
		filter["DEFAULT_VALUE"] = Ложь;	
	КонецЕсли;
	filter["TEMPLATE"] = "filter_bool";
	Возврат filter;
КонецФункции
