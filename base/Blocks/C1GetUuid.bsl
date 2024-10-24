//DynamicDirective
Функция block_c1_get_uuid_calc_value(block_type, node, path, context, block_context)
	Если ЗначениеЗаполнено(block_context.REF) Тогда
		Возврат Строка(block_context.REF.УникальныйИдентификатор());
	Иначе
		Возврат Неопределено;
	КонецЕсли;	
КонецФункции	

//DynamicDirective
Функция block_c1_get_uuid_get_value_node(node)
	Возврат Workspace.ВычислитьВыражениеXpath("./b:value", node, размыватель).ПолучитьСледующий();	
КонецФункции	
