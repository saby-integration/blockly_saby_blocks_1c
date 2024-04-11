Функция block_c1_strip_calc_value(block_type, node, path, context, block_context)
	_Строка = get_prop(block_context, "STRING");
	Если _Строка <> Неопределено Тогда
		Возврат СокрЛП(Строка(_Строка));	
	КонецЕсли;
	Возврат Неопределено;	
КонецФункции	
