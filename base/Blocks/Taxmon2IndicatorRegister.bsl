
//DynamicDirective

Функция block_taxmon2_indicator_register_calc_value(block_type, node, path, context, block_context)
	filter = context_variables_get(context);
	filter.Вставить("_api3_taxmon_report", block_context["_api3_taxmon_report"]);
	ИдЭлементаФормулы = block_context["NAME"];
	Для Каждого Парам Из get_prop(block_context, "EXTRA_FILTER", Новый Массив) Цикл
		filter.Вставить(Парам.Ключ, Парам.Значение);
		ИдЭлементаФормулы = ИдЭлементаФормулы + " " + Парам.Ключ + " = " + Строка(Парам.Значение);
	КонецЦикла;
	filter.Вставить("ИмяПоляПодстановки", block_context["_declaration_indicator_id"]);
	filter.Вставить("ИдЭлементаФормулы", ИдЭлементаФормулы);
	workspace_name = block_context["NAME"] + "_list";
	endpoint = "main";

	Если get_prop(block_context, "_child") = Неопределено Тогда
	    block_context.Вставить("_child", Новый Структура("variable_scopes", Новый Массив));
		block_context["_child"]["variable_scopes"].Добавить(Новый Соответствие);
        block_context["_child"]["variable_scopes"][0].Вставить("Filter", filter);
	КонецЕсли;
	res = block_execute_workspace(workspace_name, endpoint, context, block_context);
	ЭлемФормулы = Новый Структура("Ид, Операция", ИдЭлементаФормулы, "+");
	Формула = Новый Массив;
	Формула.Добавить(ЭлемФормулы);
	result = Новый Структура("Сумма, Формула", res["Totals"]["Сумма"], Формула);
	Возврат result;
КонецФункции
