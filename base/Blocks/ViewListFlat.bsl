
//DynamicDirective

Функция block_view_list_flat_calc_value(block_type, node, path, context, block_context)
	param = Новый Соответствие;
	copy_block_context(param, block_context);
	param.Вставить("TEMPLATE", "list_flat");
	РазмерСписка = get_prop(param, "PAGE_SIZE", 25);
	Если Не ЗначениеЗаполнено(РазмерСписка) Тогда
		РазмерСписка = 25;	
	КонецЕсли;
	ОписаниеТипа = Новый ОписаниеТипов("Число");
	PAGE_SIZE = ОписаниеТипа.ПривестиЗначение(РазмерСписка); 
	param.Вставить("PAGE_SIZE", PAGE_SIZE); 
	Возврат param;
КонецФункции	

