
//DynamicDirective

Функция block_extsyncaction_calc_value(block_type, node, path, context, block_context)
	Результат = Новый Соответствие;
	Результат.Вставить("Title", get_prop(block_context, "Title")); 
	Subtitle = get_prop(block_context, "Subtitle");
	Если ЗначениеЗаполнено(Subtitle) Тогда                                           
		Результат.Вставить("Subtitle", Subtitle); 
	КонецЕсли;	
	Status = get_prop(block_context, "Status");
	Если ЗначениеЗаполнено(Status) Тогда                                           
		Результат.Вставить("Status", Status); 
	КонецЕсли;	
	Begin = get_prop(block_context, "Begin");
	Если ЗначениеЗаполнено(Begin) Тогда                                           
		Результат.Вставить("Begin", Begin); 
	КонецЕсли;	
	Data = get_prop(block_context, "Data");
	Если ЗначениеЗаполнено(Data) Тогда                                           
		Результат.Вставить("Data", Data); 
	КонецЕсли;	
	Возврат Результат;
КонецФункции
