Функция block_c1_ref_from_id_calc_value(block_type, node, path, context, block_context)

	Если block_context.Свойство("ИмяИС") И block_context.Свойство("ИдИС") И
		ЗначениеЗаполнено(block_context.ИмяИС) И ЗначениеЗаполнено(block_context.ИдИС) Тогда			
		Попытка
			СсылкаНаобъект = ПолучитьСсылкуПоИдИС(block_context.ИмяИС, block_context.ИдИС);
			Возврат СсылкаНаобъект;  
		Исключение
			Возврат Неопределено;
		КонецПопытки;
	КонецЕсли;
КонецФункции
