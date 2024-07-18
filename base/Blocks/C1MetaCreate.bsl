Функция block_c1_meta_create_execute(block_type, node, path, context, block_context)
	type = block_c1_meta_create_get_node_field(node);
	subtype = block_c1_meta_create_get_node_subtype(node);
	res = block_execute_all_next(subtype, path + "." + "main", context, block_context);
	Если type = "Документ" Тогда
		НовыйОбъект = Новый (type + "Менеджер" + "." + res);
		Возврат НовыйОбъект.СоздатьДокумент();
	ИначеЕсли type = "Справочник" Тогда
		НовыйОбъект = Новый (type + "Менеджер" + "." + res);
		Возврат НовыйОбъект.СоздатьЭлемент();
	ИначеЕсли type = "ПланВидовХарактеристик" Тогда
		НовыйОбъект = Новый ("ПланВидовХарактеристикМенеджер" + "." + res);
		Возврат НовыйОбъект.СоздатьЭлемент();
	ИначеЕсли type = "СправочникГруппа" Тогда
		НовыйОбъект = Новый ("СправочникМенеджер" + "." + res);
		Возврат НовыйОбъект.СоздатьГруппу();
	Иначе
		ВызватьИсключение NewExtExceptionСтрока(,"Не реализовано создание объекта",type,,add_block_to_dump(block_context))
	КонецЕсли;	
	Возврат Неопределено;
КонецФункции

Функция block_c1_meta_create_get_node_field(node)	
	Возврат Root.ВычислитьВыражениеXpath("./b:field", node, размыватель).ПолучитьСледующий().ТекстовоеСодержимое; 
КонецФункции

Функция block_c1_meta_create_get_node_subtype(node)
	
	Возврат Root.ВычислитьВыражениеXpath("./b:value[@name='SUBTYPE']", node, размыватель).ПолучитьСледующий(); 
КонецФункции
