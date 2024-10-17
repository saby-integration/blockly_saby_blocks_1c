//DynamicDirective
Функция block_c1_ref_from_api3_calc_value(block_type, node, path, context, block_context)
	Если get_prop(block_context.API3,"ИдИС") = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Если Найти(block_context.API3["ИмяИС"], ".") > 0 Тогда
		ИмяИС = block_context.API3["ИмяИС"];
	Иначе
		ИмяИС = block_context.API3["ТипИС"] + "." + block_context.API3["ИмяИС"];
	КонецЕсли;
	Попытка
		СсылкаНаобъект = ПолучитьСсылкуПоИдИС(ИмяИС, block_context.API3["ИдИС"]);
		Возврат СсылкаНаобъект;  
	Исключение
		Возврат Неопределено;
	КонецПопытки;
КонецФункции
