
//DynamicDirective

Функция block_ext_sync_obj_client2_calc_value(block_type, node, path, context, block_context) 
	Api3Obj = get_prop(block_context, "Api3Obj");
	Если Не ЗначениеЗаполнено(Api3Obj) Тогда
		ВызватьИсключение(NewExtExceptionСтрока(,"Не заполнен обязательный параметр Api3Obj в блоке ext_sync_obj_client2"));
	КонецЕсли;
	ESO = Новый Соответствие;
	ESO.Вставить("Action", 1);
	ESO.Вставить("StatusId", get_prop(block_context, "StatusId"));
	ИмяИС = get_prop(Api3Obj, "ИмяИС");
	ТипИС = get_prop(Api3Obj, "ТипИС");
	Если ЗначениеЗаполнено(ИмяИС) И ЗначениеЗаполнено(ТипИС) И Найти(ИмяИС, ".") = 0 Тогда
		ИмяИС = ТипИС + "." + ИмяИС;
	КонецЕсли;
	Если ЗначениеЗаполнено(ИмяИС) Тогда
		ESO.Вставить("ClientType", ИмяИС);
	КонецЕсли;	
	ESO.Вставить("ClientId", get_prop(Api3Obj, "ИдИС"));
	ESO.Вставить("SbisType", get_prop(Api3Obj, "ИмяСБИС"));
	ESO.Вставить("SbisId", get_prop(Api3Obj, "ИдСБИС"));
	
	Data = Новый Соответствие;
	Data.Вставить("data_is", Api3Obj);
	ClientType = get_prop(ESO, "ClientType");
	Если ЗначениеЗаполнено(ClientType) Тогда
		ESO.Вставить("Type", ClientType);
	КонецЕсли;	
	ESO.Вставить("Data", Data);
	ActionsInput = get_prop(block_context, "Actions");
	Если ЗначениеЗаполнено(ActionsInput) Тогда 
		Если ТипЗнч(ActionsInput) <> Тип("Массив") Тогда 
			Actions = Новый Массив;
			Actions.Добавить(ActionsInput);	
		Иначе
			Actions = ActionsInput;
		КонецЕсли;	               
		ESO.Вставить("Actions", Actions);	
	КонецЕсли;	
	Возврат ESO;	
КонецФункции
