//DynamicDirective
Функция block_view_column_icon_calc_value(block_type, node, path, context, block_context)
	param = Новый Соответствие;
	copy_block_context(param, block_context);
	param["TEMPLATE"] = "column_icon";
	Если param["VISIBLE"] = "TRUE" Тогда
		param["VISIBLE"] = Истина;
	КонецЕсли;
	Возврат param;
КонецФункции
