Функция block_c1_execute2_calc_value(block_type, node, path, context, block_context)
	Если Не block_context.Свойство("PARAM0") Тогда
		Алгоритм = block_context.NAME;
		ОбщегоНазначения.ВыполнитьВБезопасномРежиме(Алгоритм);
	Иначе
		НомерПараметра = 1;
		Параметры = Новый Структура;
		АргументыВызова = "Параметры."+"PARAM0";
		Если ТипЗнч(get_prop(block_context,"PARAM0")) = Тип("Соответствие") Тогда
			ПарамЗначение = ПолучитьСтруктуруИзСоответствия(block_context["PARAM0"]);	
		Иначе
			ПарамЗначение = block_context["PARAM0"];	
		КонецЕсли;
		Параметры.Вставить("PARAM0", ПарамЗначение);
		Пока block_context.Свойство("PARAM" +Строка(НомерПараметра)) Цикл
			Если ТипЗнч(get_prop(block_context,"PARAM"+Строка(НомерПараметра))) = Тип("Соответствие") Тогда
				ПарамЗначение = ПолучитьСтруктуруИзСоответствия(get_prop(block_context,"PARAM"+Строка(НомерПараметра)));	
			Иначе
				ПарамЗначение = get_prop(block_context,"PARAM"+Строка(НомерПараметра));	
			КонецЕсли;	
			Параметры.Вставить("PARAM"+Строка(НомерПараметра), ПарамЗначение);
			АргументыВызова = АргументыВызова  + ", Параметры." + "PARAM"+Строка(НомерПараметра);
			НомерПараметра = НомерПараметра + 1;
		КонецЦикла;
		ОбщегоНазначения.ВыполнитьВБезопасномРежиме(block_context.NAME+"("+АргументыВызова+")", Параметры);
	КонецЕсли;	
	Возврат Неопределено;
КонецФункции
