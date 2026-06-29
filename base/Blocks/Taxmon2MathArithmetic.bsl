
//DynamicDirective

Функция block_taxmon2_math_arithmetic_calc_value(block_type, node, path, context, block_context)
	workspace_find_fields(node, block_context);
	сч = 0;
	Сумма = 0;
	Формула = Новый Массив;
	Пока Истина Цикл
		node_val = workspace_find_input_by_name(node, "VALUE" + Строка(сч));
		Если node_val = Неопределено Тогда
			Прервать;
		КонецЕсли;
		default_child_context = Новый Структура("_declaration_indicator_id, _api3_taxmon_report", block_context["_declaration_indicator_id"], block_context["_api3_taxmon_report"]);
		input_result = block_execute_all_next(node_val, path+"."+"value" + Строка(сч), context, block_context, , default_child_context);
		ОперацияСтр = block_context["OPERATION" + Строка(сч)];
		Если ОперацияСтр = "ADD" Тогда
			Сумма = Сумма + input_result["Сумма"];
			Операция = "+";
		Иначе
			Сумма = Сумма - input_result["Сумма"];
			Операция = "-";
		КонецЕсли;
		Для Каждого ЭлемФормулы Из input_result["Формула"] Цикл
			ЭлемФормулы["Операция"] = Операция;
			Формула.Добавить(ЭлемФормулы);
		КонецЦикла;
		сч = сч + 1;
	КонецЦикла;
	block_check_step(context, block_context);
	result = Новый Структура("Сумма, Формула", Сумма, Формула);
	Возврат result;
КонецФункции
