//DynamicDirective
Функция block_saby_write_document_calc_value(block_type, node, path, context, block_context) 
	Попытка
		doc = get_prop(block_context, "doc");
		Результат = Транспорт.local_helper_write_document(context.params, doc);
		Возврат Результат;
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,add_block_to_dump(block_context));	
	КонецПопытки		
КонецФункции	
