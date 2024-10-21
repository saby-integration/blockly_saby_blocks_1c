//DynamicDirective
Функция block_new_obj_execute(block_type, node, path, context, block_context)
	Если get_prop(block_context,"result") <>  Неопределено Тогда  
		Возврат get_prop(block_context,"result",Неопределено);
	КонецЕсли;

	mutation_count = Число((workspace_find_mutation_by_name(node, "PROP", 0)));
	result =  Новый Соответствие;
	Если mutation_count Тогда
		Для j = 0 По mutation_count - 1 Цикл
			prop_name = Workspace.ВычислитьВыражениеXpath("./b:field[@name='PROP"+j+"_NAME']", node, размыватель).ПолучитьСледующий().ТекстовоеСодержимое;
			Если Не ЗначениеЗаполнено(prop_name) или result["prop_name"] <> Неопределено Тогда
				Продолжить;
			КонецЕсли;	
			node_prop_value = workspace_find_input_by_name(node, "PROP" + j+"_VALUE");
			prop_value = block_execute_all_next(node_prop_value, path+".PROP"+j+"_VALUE", context, block_context);
			ВставитьСвойствоЕслиНет(result, prop_name, prop_value);
		КонецЦикла;	
	КонецЕсли;		
	block_check_step(context, block_context);		
	block_context.Вставить("result",result);
	Возврат block_context.result;
КонецФункции	
