Функция block_try_calc_value(block_type, node, path, context, block_context)
	Попытка
		node_try = block_try_get_node_try(node);
		Если node_try = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		block_execute_all_next(node_try, path, context, block_context, True);	
	Исключение
		Если block_context.Свойство("child") Тогда
			block_context.Удалить("child");	
		КонецЕсли;	
		node_except = block_try_get_node_except(node);
		Если node_except = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		block_execute_all_next(node_except, path, context, block_context, True);	
	КонецПопытки;
	Возврат Неопределено;
КонецФункции

Функция block_try_get_node_try(node)	
	Возврат Root.ВычислитьВыражениеXpath("./b:statement[@name='try']", node, размыватель).ПолучитьСледующий();	
КонецФункции 

Функция block_try_get_node_except(node)	
	Возврат Root.ВычислитьВыражениеXpath("./b:statement[@name='except']", node, размыватель).ПолучитьСледующий();	
КонецФункции

