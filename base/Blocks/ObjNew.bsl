// Создает новое Соответствие
//
// Параметры:
//  block_type - Строка - Название блока
// 	node - Структура - Dom структура хмл
//  path - Строка - Пусть до блока по алгоритму
//  context - Структура - Общий контекст алгоритма
//	block_context - Структура - Контекст исполняемого блока
//  
// Возвращаемое значение:
//  Структура - Результат обсчета алгоритма
//
//DynamicDirective
Функция block_obj_new_execute(block_type, node, path, context, block_context)
	РеквизитРезультат = "result";
	Если get_prop(block_context, РеквизитРезультат) <>  Неопределено Тогда  
		Возврат get_prop(block_context, РеквизитРезультат, Неопределено);
	КонецЕсли;

	mutation_count = Число((workspace_find_mutation_by_name(node, "items", 0)));
	result =  Новый Соответствие;
	Если mutation_count Тогда
		Для j = 0 По mutation_count - 1 Цикл
			СтрокаВычисления = "./b:field[@name='PARAM" + j + "_NAME']";
			prop_name = Workspace.ВычислитьВыражениеXpath(СтрокаВычисления, node, размыватель).ПолучитьСледующий().ТекстовоеСодержимое;
			Если Не ЗначениеЗаполнено(prop_name) Или result["prop_name"] <> Неопределено Тогда
				Продолжить;
			КонецЕсли;	
			node_prop_value = workspace_find_input_by_name(node, "PARAM" + j + "_VALUE");
			prop_value = block_execute_all_next(node_prop_value, path + ".PARAM" + j + "_VALUE", context, block_context);
			ВставитьСвойствоЕслиНет(result, prop_name, prop_value);
		КонецЦикла;	
	КонецЕсли;		
	block_check_step(context, block_context);		
	block_context.Вставить(РеквизитРезультат, result);
	Возврат block_context.result;	
КонецФункции
