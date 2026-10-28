
// BSLLS:FunctionShouldHaveReturn-off

//DynamicDirective

Функция block_taxmon2_set_declaration_indicator_calc_value(block_type, node, path, context, block_context)
	workspace_find_fields(node, block_context);
	variable = block_context["VAR"];
	Отчет = block_get_variable(context, variable);
	default_child_context = Новый Структура("_declaration_indicator_id, _api3_taxmon_report", block_context["NAME"], Отчет);
	node_val = workspace_find_input_by_name(node, "VALUE");
	result = block_execute_all_next(node_val, path+"."+"value", context, block_context, , default_child_context);
	
	block_check_step(context, block_context);
	
	Если get_prop(Отчет, "Данные") = Неопределено Тогда
		Отчет.Вставить("Данные", Новый Массив);
	КонецЕсли;
	result = Новый Структура("Ид, Сумма, Формула", block_context["NAME"], get_prop(result, "Сумма", 0), get_prop(result, "Формула", Новый Массив));
	Отчет["Данные"].Добавить(result);
	block_set_variable(context, variable, Отчет);
КонецФункции
// BSLLS:FunctionShouldHaveReturn-on
