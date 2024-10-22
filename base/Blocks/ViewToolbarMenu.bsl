//DynamicDirective
Функция block_view_toolbar_menu_calc_value(block_type, node, path, context, block_context)
	param = Новый Соответствие;
	command_count = Число(workspace_find_mutation_by_name(node, "items", 0))-1;
	copy_block_context(param, block_context);
	commands = Новый Массив();
	Для i = 0 по command_count Цикл
        commands.Добавить(block_context["PARAM" + Строка(i) + "_COMMAND"]);
	КонецЦикла;
	param["Commands"] = commands;
	param["Type"] = "Menu";
	Возврат param;
КонецФункции	
