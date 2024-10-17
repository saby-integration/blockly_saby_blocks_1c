//DynamicDirective
Функция block_obj_prop_set_calc_value(block_type, node, path, context, block_context)
	//TODO обернуть в попытку. указать имя полей объекта куда не смогли вставить
	variable_name = block_context["VAR"];
	obj = block_get_variable(context, variable_name);
	Попытка
		Если ТипЗнч(obj) = Тип("Структура") или ТипЗнч(obj) = Тип("Соответствие") Тогда
			block_obj_set_path_value(obj, block_context["PATH"], block_context["VALUE"]);
		Иначе
			obj[block_context["PATH"]] = block_context["VALUE"];
		КонецЕсли;
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Не удалось присвоить значение переменной ", variable_name+ "." + block_context["PATH"]+ " - " + ИнфОбОшибке.Описание,, add_block_to_dump(block_context)));
	КонецПопытки;
	block_set_variable(context, variable_name, obj);
	Возврат Неопределено;
КонецФункции
