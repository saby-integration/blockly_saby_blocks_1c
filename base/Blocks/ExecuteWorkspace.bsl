
// Функция block_execute_workspace_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Соответствие - Результат выполения функции
//
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS:FunctionOutParameter-off
//DynamicDirective
Функция block_execute_workspace_calc_value(block_type, node, path, context, block_context)
	params_count = Число(workspace_find_mutation_by_name(node, "items", 0)) - 1;
	workspace_name = block_context["NAME"];
	endpoint = get_prop(block_context, "ENDPOINT");
	Если get_prop(block_context, "_previous_workspace") = Неопределено Тогда
	    block_context.Вставить("_previous_workspace", BlocklyExecutor.workspace.name);
	КонецЕсли;
	Если get_prop(block_context, "_child") = Неопределено Тогда
	    block_context.Вставить("_child", Новый Структура("variable_scopes", Новый Массив));
		block_context["_child"]["variable_scopes"].Добавить(Новый Соответствие);
	    Для i = 0 по params_count Цикл
	        name = block_context["PARAM" + Строка(i) + "_NAME"];
	        value = block_context["PARAM" + Строка(i) + "_VALUE"];
	        block_context["_child"]["variable_scopes"][0].Вставить(name, value);
		КонецЦикла;	
	КонецЕсли;
	Возврат block_execute_workspace(workspace_name, endpoint, context, block_context);
КонецФункции

//DynamicDirective

Функция block_execute_workspace(workspace_name, endpoint, context, block_context)
	Попытка
		save_last_context();
		context = context_init_nested(block_context, workspace_name);
		// ???
		block_context["_child"] = context.data; 
		result = blockly_executor_execute_nested(context, endpoint, BlocklyExecutor.commands_result);
		delete_last_context();
		BlocklyExecutor.Вставить("current_algorithm_breakpoints",
			BlocklyExecutor.breakpoints[BlocklyExecutor.workspace.name]);
		context_set_next_step();
		Возврат result;
	Исключение
		// ???
		block_context["_child"] = context.data;
		delete_last_context();
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));
	КонецПопытки;
КонецФункции
// BSLLS:FunctionOutParameter-on

Функция ПолучитьСтруктуруИзСоответствия(ЗначВход)
	Если ТипЗнч(ЗначВход)=Тип("Соответствие") Тогда
		Возврат ТипЗначенияСоответствие(ЗначВход);
	Иначе
		Если ТипЗнч(ЗначВход)=Тип("Массив") Тогда
			Возврат ТипЗначенияМассив(ЗначВход);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЗначВход; 
КонецФункции

Функция ТипЗначенияСоответствие(ЗначВход)
	СтруктураВозврат=Новый Структура;
	ФлагОшибка=Ложь;
	
	Для Каждого р Из ЗначВход Цикл
		Попытка
			СтруктураВозврат.Вставить(р.Ключ,ПолучитьСтруктуруИзСоответствия(р.Значение));
		Исключение
			ФлагОшибка=Истина;
			Прервать;
		КонецПопытки;
	КонецЦикла;
	
	Если ФлагОшибка Тогда // пришел ключ, который не возможно поместить в структуру
		СтруктураВозврат = Новый Массив;
		Для Каждого р Из ЗначВход Цикл
			ДопСтруктура=Новый Структура;
			ДопСтруктура.Вставить("Ключ",р.Ключ);
			ДопСтруктура.Вставить("Значение",ПолучитьСтруктуруИзСоответствия(р.Значение));
			СтруктураВозврат.Добавить(ДопСтруктура);
		КонецЦикла;
	КонецЕсли;
	Возврат СтруктураВозврат;
КонецФункции

Функция ТипЗначенияМассив(ЗначВход)
	НовыйМассив=Новый Массив;
	Для Каждого ЭлМ Из ЗначВход Цикл
		НовыйМассив.Добавить(ПолучитьСтруктуруИзСоответствия(ЭлМ));
	КонецЦикла;
	Возврат НовыйМассив;	
КонецФункции
