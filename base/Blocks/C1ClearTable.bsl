Функция block_c1_clear_table_execute(block_type, node, path, context, block_context)
	var_name = block_c1_clear_table_get_var_name(node);
	res = block_c1_clear_table_get_get_variable(var_name);
	Если Найти(НРег(ТипЗнч(res)), " табличная часть") или ТипЗнч(res) = Тип("ТаблицаЗначений") Тогда
		res.Очистить();
	Иначе
		Сообщить("Неизвестный блок в методе c1_clear_table");
	КонецЕсли;	
	Возврат Неопределено;	
КонецФункции

Функция block_c1_clear_table_get_var_name(node)	
	Возврат node.ДочерниеУзлы[0].ТекстовоеСодержимое;
КонецФункции

Функция block_c1_clear_table_get_get_variable(name)
	Возврат context_variables_get(context)[name];	
КонецФункции		
