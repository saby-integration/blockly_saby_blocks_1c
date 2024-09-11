Функция block_format_calc_value(block_type, node, path, context, block_context)
	value = block_context["value"];
	operation = block_context["type"];
	format_string = block_context["template"];
	УбратьПрефиксыИзФормата(format_string);
	Если operation = "to_date" Тогда
	    result = ПреобразоватьСтрокуВДату(format_string, value);
		ВставитьСвойствоЕслиНет(block_context, "result", result);	
	ИначеЕсли operation = "from_date" Тогда
		ВставитьСвойствоЕслиНет(block_context, "result", Формат(value, "ДФ="+format_string));
	ИначеЕсли operation = "to_string" Тогда
		Если значениеЗаполнено(format_string) Тогда
			result = Формат(value, format_string);
		Иначе
			result = Строка(value);	
		КонецЕсли;
		ВставитьСвойствоЕслиНет(block_context, "result", result);
	ИначеЕсли operation = "to_number" Тогда
		ВставитьСвойствоЕслиНет(block_context, "result", Число(value));
	КонецЕсли;	
	Возврат block_context["result"];
КонецФункции

Процедура УбратьПрефиксыИзФормата(format_string)
	format_string = СтрЗаменить(format_string, "ДФ=", "");
	format_string = СтрЗаменить(format_string, "ДЛФ=", "");
КонецПроцедуры	

Функция block_format_get_node_field(node)	
	Возврат Workspace.ВычислитьВыражениеXpath("./b:field", node, размыватель).ПолучитьСледующий().ТекстовоеСодержимое; 
КонецФункции
