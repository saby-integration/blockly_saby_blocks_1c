//DynamicDirective
Функция block_saby_read_document_get_value(block_context, context, ПараметрыВызова, multithread_mode)
	Если has_prop(block_context,"Результат") Тогда
		Возврат get_prop(block_context,"Результат"); 
	КонецЕсли;	
	QueryId = get_prop(block_context,"AsyncRequest"); 
	Если QueryId = Неопределено Тогда  		
		Попытка
			Результат = local_helper_read_document(context.params, ПараметрыВызова, multithread_mode, 120);
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();
			ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
			Если ЭтоСлужебнаяОшибкаБлока(ОшибкаСтруктура.type) Тогда 
				Если ОшибкаСтруктура.type = "AsyncRequest" Тогда
					set_prop(ОшибкаСтруктура.dump,block_context,"QueryId","AsyncRequest",Неопределено);
				КонецЕсли;
				ВызватьИсключение ИнфОбОшибке.Описание; 
			КонецЕсли;
			Возврат Ложь;
		КонецПопытки;
	Иначе 
		responce = local_helper_exec_method_process_responce_async(context.params, QueryId);
		Результат = local_helper_read_document_process_responce(responce);
		block_context.Удалить("AsyncRequest");
	КонецЕсли;
	block_context.Вставить("Результат", Результат);
    Возврат Результат;
КонецФункции

//DynamicDirective
Функция block_saby_read_document_calc_value(block_type, node, path, context, block_context)
	Попытка
		multithread_mode = get_prop(context,"multithread_mode",ЛОЖЬ);
		doc = get_prop(block_context, "doc");
		ПараметрыВызова = Новый Структура();
		Если ТипЗнч(doc) = Тип("Структура") или ТипЗнч(doc) = Тип("Соответствие") Тогда
			Если get_prop(doc, "Идентификатор") <> Неопределено Тогда 
				ПараметрыВызова = Новый Структура("Идентификатор", get_prop(doc, "Идентификатор"));
			ИначеЕсли get_prop(doc, "ИдСБИСВИ") <> Неопределено Тогда 
				ПараметрыВызова = Новый Структура("Идентификатор", get_prop(doc, "ИдСБИСВИ"));
			ИначеЕсли get_prop(doc, "ИдСБИС") <> Неопределено Тогда 
				ПараметрыВызова = Новый Структура("ПервичныйКлюч", get_prop(doc, "ИдСБИС"));
			Иначе
			КонецЕсли;
		ИначеЕсли ТипЗнч(doc) = Тип("Строка") Тогда
			ПараметрыВызова = Новый Структура("Идентификатор", doc);
		Иначе
			ВызватьИсключение NewExtExceptionСтрока(,"Отсутствует идентификатор объекта");
		КонецЕсли;
		ПараметрыВызова.Вставить("ДопПоля", "ЭтапВернутьВсеСертификаты");
		Результат = block_saby_read_document_get_value(block_context, context, ПараметрыВызова, multithread_mode);
		Возврат Результат;
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
		Если ЭтоСлужебнаяОшибкаБлока(ОшибкаСтруктура.type) Тогда
			ВызватьИсключение ИнфОбОшибке.Описание; 
		КонецЕсли;	
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,add_block_to_dump(block_context));
	КонецПопытки;
КонецФункции


