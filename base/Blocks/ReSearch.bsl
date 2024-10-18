//DynamicDirective
Функция block_re_search_calc_value(block_type, node, path, context, block_context)
	_Строка = get_prop(block_context, "value");
	_ПодстрокаПоиска = get_prop(block_context, "re");
	Если _Строка <> Неопределено И _ПодстрокаПоиска <> Неопределено Тогда
		Возврат Найти(Строка(_Строка), Строка(_ПодстрокаПоиска));
	КонецЕсли;
	Возврат Неопределено;	
КонецФункции	
