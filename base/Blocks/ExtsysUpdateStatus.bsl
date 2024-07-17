Функция block_extsys_update_status2_calc_value(block_type, node, path, context, block_context)
	СтатусыДокументовОбновитьПоUID(
		get_prop(block_context, "UID"),
		get_prop(block_context, "ACTIVE_STAGE"), 
		get_prop(block_context, "STATE_CODE"),
		,
		get_prop(block_context, "ИмяИС"),
		get_prop(block_context, "ИдИС"), 
		get_prop(block_context, "SbisID")
	);
	Возврат Неопределено;
КонецФункции
