Функция block_c1_doc_read_print_forms_calc_value(block_type, node, path, context, block_context)
	Возврат ПолучитьПечатныеФормы(block_context.DOC, block_context.PRINT_FORMS);
КонецФункции

Функция ПривестиСтрокуКВалидномуИмениФайла(ИсходнаяСтрока)
	СимволыИсключения = "\/:*?""<>|+%!@";
	СтрокаРезультат = "";
	Для ИндексСимвола = 1 По СтрДлина(ИсходнаяСтрока) Цикл
		СимволСтроки = Сред(ИсходнаяСтрока, ИндексСимвола, 1);
		Если Найти(СимволыИсключения, СимволСтроки) > 0 Тогда Продолжить; КонецЕсли;
		СтрокаРезультат = СтрокаРезультат + СимволСтроки;
	КонецЦикла;
	
	Возврат СокрЛП(СтрокаРезультат);
КонецФункции
