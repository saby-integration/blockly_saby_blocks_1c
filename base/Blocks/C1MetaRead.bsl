Функция block_c1_meta_read_calc_value(block_type, node, path, context, block_context)
	variable = block_context.variable;
	НовыйОбъект = context_variables_get(context)[variable];
	Попытка
		context_variables_get(context)[variable] = НовыйОбъект.ПолучитьОбъект();
	Исключение
		ИнфОбОшибке	= ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Переменная " + variable + " не возвращает объекта по ссылке.", " ИмяSABY в блоке " + block_type,, add_block_to_dump(block_context)));
	КонецПопытки;	
	Возврат Неопределено;
КонецФункции
