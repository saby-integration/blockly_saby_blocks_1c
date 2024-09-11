Функция block_c1_call_filter_calc_value(block_type, node, path, context, block_context)
	
	ПорядокСортировки = get_prop(block_context, "ORDERED_DIRECTION");
	ПолеСортировки = get_prop(block_context, "ORDERED_FIELD");
	
	ВернутьПервоеЗначение = workspace_find_mutation_by_name(node, "LIMIT_ONE");
	
	КоличествоВернуть = ?(ВернутьПервоеЗначение = "TRUE", "1", "1000");
	
	ИсточникДанных = block_context["filter"];
	
	ИспользоватьВрТбл = ТипЗнч(ИсточникДанных) = Тип("Массив") ИЛИ ТипЗнч(ИсточникДанных) = Тип("ТаблицаЗначений");
	Если ТипЗнч(ИсточникДанных) = Тип("Массив") Тогда
		ИсточникДанных = МассивВТаблицуЗначений(ИсточникДанных);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	ТекстУсловия = "";
	i = 0;
	Пока Истина Цикл
		Ключ = "PARAM"+i+"_TYPE";
		ЕстьЗначение = ?(ЗначениеЗаполнено(get_prop(block_context, Ключ)), Истина, Ложь);
		Если ЕстьЗначение Тогда
			_Имя = get_prop(block_context,"FIELD"+i+"_NAME");
			_Вид = get_prop(block_context,"PARAM"+i+"_TYPE");
			_Значение = get_prop(block_context,"PARAM"+i);
			ТекстУсловия = ТекстУсловия+?(ПустаяСтрока(ТекстУсловия)," ГДЕ ", " И ")+"Данные."+_Имя+" "+_Вид+" &"+_Имя;
			Запрос.УстановитьПараметр(_Имя, _Значение);
			i = i + 1;
		Иначе
			Прервать
		КонецЕсли;
	КонецЦикла;
	
	ТекстСортировки = "";
	Если ЗначениеЗаполнено(ПолеСортировки) Тогда
		ТекстСортировки = " УПОРЯДОЧИТЬ ПО " + "Данные."+ПолеСортировки+" "+ПорядокСортировки;
	КонецЕсли;
	
	ПрефиксЗапросаДляВрТбл = "";
	Если ИспользоватьВрТбл Тогда	
		Запрос.УстановитьПараметр("ТабДанных", ИсточникДанных);
		
		ИсточникДанных = "ВТ_Данные";
		
		ПрефиксЗапросаДляВрТбл =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		| *
		|ПОМЕСТИТЬ
		| ВТ_Данные
		|ИЗ
		| &ТабДанных КАК Таб
		|
		|;
		|";	
	КонецЕсли;
	
	Запрос.Текст = ПрефиксЗапросаДляВрТбл +  
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ "+КоличествоВернуть+"
		| *
		|ИЗ
		| "+ИсточникДанных+" КАК Данные
		|"+ТекстУсловия+"
		|"+ТекстСортировки+"
		|";
	
	времТЗ = Запрос.Выполнить().Выгрузить();
	
	Если ВернутьПервоеЗначение = "TRUE" Тогда
		Если времТЗ.Количество() > 0 Тогда
			Возврат СтрокаТаблицыЗначенийВСтруктуру(времТЗ[0]);
		Иначе
			Возврат Новый Структура;
		КонецЕсли;
	Иначе
		Возврат времТЗ;
	КонецЕсли;
	
КонецФункции

