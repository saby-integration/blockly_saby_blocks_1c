Функция block_api3_timesheets_calc_value(block_type, node, path, context, block_context)
	Возврат ЗаполнитьЗначенияApi3Objects("Документы", "Табель",  block_context);
КонецФункции

Функция block_api3_timesheets_table_calc_value(block_type, node, path, context, block_context)
	Возврат ЗаполнитьЗначенияApi3Objects(Неопределено, Неопределено,  block_context);
КонецФункции

Функция block_api3_timesheets_time_calc_value(block_type, node, path, context, block_context)
	Возврат ЗаполнитьЗначенияApi3Objects(Неопределено, Неопределено,  block_context);
КонецФункции

//Функция block_api3_timesheets_table_execute(block_type, node, path, context, block_context)
//	
//	Если Не block_context.свойство("value") Тогда
//		block_context.Вставить("value", Новый Массив);
//	КонецЕсли;	

//	args = simple_block_get_nodes_args(node);
//	Если args = Неопределено Тогда 
//		Возврат block_context["value"];	
//	КонецЕсли;
//	
//	ВставитьСвойствоЕслиНет(block_context, "Index", 0);
//	simple_block_get_fields(node, path, context, block_context);
//	
//	ArgItems = "_ТаблДок";
//	complete = ?(block_context.Свойство(ArgItems), Истина, Ложь);
//	Если complete Тогда
//		Items = block_context[ArgItems];
//	Иначе
//		ItemsNode = Root.ВычислитьВыражениеXpath("./b:value[@name='"+ArgItems+"']", node, размыватель).ПолучитьСледующий();
//		Items = block_execute_all_next(ItemsNode, path +"."+ArgItems, context, block_context);
//		Если ТипЗнч(Items) <> Тип("Массив") Тогда
//			//TODO бросить исключение
//		ИначеЕсли Items.Количество() = 0 Тогда
//			Возврат block_context["value"];
//		КонецЕсли;
//		ВставитьСвойствоЕслиНет(block_context, ArgItems, Items);
//	КонецЕсли;	

//	blockType =  block_context.__type;
//	ItemVarName = block_context["_ITEM"];
//    
//	Пока Истина Цикл
//		
//		Item = Items[block_context["Index"]];
//		block_set_variable(context, ItemVarName, Item);

//		Для i=0 По args.Количество()-1 Цикл
//			_param_name = args[i].ПолучитьАтрибут("name");
//			Если _param_name = ArgItems Тогда
//				Продолжить;
//			КонецЕсли;
//			
//			Если Не block_context.Свойство(_param_name) Тогда
//				Попытка
//					value = block_execute_all_next(Args[i], path +"."+_param_name, context, block_context)
//				Исключение
//					ИнфОбОшибке = ИнформацияОбОшибке();
//					ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Ошибка в расчете параметра блока", "(" + blockType + "."+_param_name+")",, add_block_to_dump(block_context)));
//				КонецПопытки;
//				Попытка
//					ВставитьСвойствоЕслиНет(block_context, _param_name, value);
//				Исключение
//					ИнфОбОшибке = ИнформацияОбОшибке();
//					ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Невалидное имя параметра блока", " (" + blockType + "."+_param_name+ ")",, add_block_to_dump(block_context)));
//				КонецПопытки;
//			КонецЕсли;
//		КонецЦикла;		
//		block_check_step(context, block_context);
//		block_context["Index"] = block_context["Index"]+1;
//		Если Items.Количество() <= block_context["Index"] Тогда
//			Прервать;
//		Иначе
//			ResultItem = Новый Структура;
//			Для i=0 По args.Количество()-1 Цикл
//				_param_name = args[i].ПолучитьАтрибут("name");
//				Если _param_name = ArgItems Тогда
//					Продолжить;
//				КонецЕсли;
//				ResultItem.Вставить(_param_name, block_context[_param_name]);
//				block_context.Удалить(_param_name);
//			КонецЦикла;		
//			block_context["value"].Добавить(ResultItem);
//		КонецЕсли;
//	КонецЦикла;

//	Возврат block_context["value"];	

//КонецФункции

