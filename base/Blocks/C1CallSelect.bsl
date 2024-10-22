
Функция ВыполнитьЗапросНаСервере(ТекстЗапроса, param)  
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Для каждого _param Из param Цикл
		Запрос.УстановитьПараметр(_param.Ключ, _param.Значение);
	КонецЦикла;
	Возврат ТаблицаЗначенийВМассив(Запрос.Выполнить().Выгрузить());	
КонецФункции

//DynamicDirective
Функция block_c1_call_select_execute(block_type, node, path, context, block_context)
	Если block_context.Свойство("result") Тогда
		Возврат block_context["result"];
	КонецЕсли;

	_select_node = workspace_find_input_by_name(node, "select");
	res = block_execute_all_next(_select_node, path + "." + "main", context, block_context);
	ТекстЗапроса = res;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВЫБРАТЬ", Символы.ВК+"ВЫБРАТЬ");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ";", ";"+Символы.ВК);
	param = block_c1_call_select_get_param(node, path, context, block_context);
	block_check_step(context, block_context);

	Если ЗначениеЗаполнено(ТекстЗапроса) Тогда		
		Результат = ВыполнитьЗапросНаСервере(ТекстЗапроса, param) ; 
		block_context.Вставить("result", Результат);
	Иначе
		block_context.Вставить("result", Неопределено);
	КонецЕсли;
		
	Возврат block_context["result"];

		
КонецФункции

//DynamicDirective
Функция block_c1_call_select_get_value(node)	               
	Возврат node.ПервыйДочерний.ТекстовоеСодержимое;
КонецФункции

//DynamicDirective
Функция block_c1_call_select_get_param(node, path, context, block_context)
	param = Новый Структура;
	РезультатXpath_PARAM = Workspace.ВычислитьВыражениеXpath("./b:value[contains(@name,'PARAM')]", node, размыватель);
	РезультатXpath_FIELD = Workspace.ВычислитьВыражениеXpath("./b:field[contains(@name,'FIELD')]", node, размыватель);
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
