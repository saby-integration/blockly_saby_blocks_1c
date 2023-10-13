Функция block_c1_call_select_execute(block_type, node, path, context, block_context)
	УстановитьПривилегированныйРежим(Истина);
	_select_node = block_c1_call_select_get_select(node);
	res = block_execute_all_next(_select_node, path + "." + "main", context, block_context);
	ТекстЗапроса = res;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВЫБРАТЬ", Символы.ВК+"ВЫБРАТЬ");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ";", ";"+Символы.ВК);
	
	Если ЗначениеЗаполнено(ТекстЗапроса) Тогда		
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапроса;
		param = block_c1_call_select_get_param(node, path, context, block_context);
		Для каждого _param Из param Цикл
			Запрос.УстановитьПараметр(_param.Ключ, _param.Значение);
		КонецЦикла;	
		Возврат Запрос.Выполнить().Выгрузить();
	КонецЕсли;
	
	Возврат Неопределено;
		
КонецФункции

Функция block_c1_call_select_get_select(node)
	Возврат Root.ВычислитьВыражениеXpath("./b:value[@name='select']", node, размыватель).ПолучитьСледующий();		
КонецФункции

Функция block_c1_call_select_get_value(node)	               
	Возврат node.ПервыйДочерний.ТекстовоеСодержимое;
КонецФункции

Функция block_c1_call_select_get_param(node, path, context, block_context)
	param = Новый Структура;
	РезультатXpath_PARAM = Root.ВычислитьВыражениеXpath("./b:value[contains(@name,'PARAM')]", node, размыватель);
	РезультатXpath_FIELD = Root.ВычислитьВыражениеXpath("./b:field[contains(@name,'FIELD')]", node, размыватель);
	Пока Истина Цикл
		Узел_PARAM = РезультатXpath_PARAM.ПолучитьСледующий();
		Если Узел_PARAM = Неопределено Тогда Прервать КонецЕсли;
		Узел_FIELD = РезультатXpath_FIELD.ПолучитьСледующий();
		Если Узел_FIELD = Неопределено Тогда Прервать КонецЕсли;
		res = block_execute_all_next(Узел_PARAM, path + "." + "main", context, block_context);
		param_name = Узел_FIELD.ТекстовоеСодержимое;
		param.Вставить(param_name, res);
	КонецЦикла;
	Возврат param; 
КонецФункции
