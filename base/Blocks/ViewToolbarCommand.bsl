//DynamicDirective
Функция block_view_toolbar_command_calc_value(block_type, node, path, context, block_context)
	param = Новый Соответствие;
	copy_block_context(param, block_context);
	params_count = Число(workspace_find_mutation_by_name(node, "items", 0))-1;
	ARGS = Новый Структура();
	Для i = 0 по params_count Цикл
        ARGS.Вставить(block_context["PARAM" + Строка(i) + "_KEY"], block_context["PARAM" + Строка(i) + "_VALUE"]);
	КонецЦикла;
	param["ARGS"] = ARGS;
	param["TEMPLATE"] = "command";
	Возврат param;
КонецФункции	
