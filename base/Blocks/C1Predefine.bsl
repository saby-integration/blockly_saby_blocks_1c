Функция block_c1_predefine_calc_value(block_type, node, path, context, block_context)
	type_list = СтрРазделить82(block_context.ИмяИС,".");
	Возврат ПолучитьСоответсвиеПредопределенных(type_list[0], type_list[1]); //TODO в ини predefine перейти на c1_predefine
КонецФункции

Функция ПолучитьСоответсвиеПредопределенных(type, subtype)
	
	СоответствиеПредопределенных = Новый Соответствие;
	МассивИменПредопределенных = Новый Массив;
	
	Если type = "Справочник" или type = "Справочники" Тогда //TODO это работать не будет
		ОбъектМетаданных = Метаданные.Справочники[subtype];
		МассивИменПредопределенных = ОбъектМетаданных.ПолучитьИменаПредопределенных();
		type = "Справочник";
	ИначеЕсли type = "Перечисление" или type = "Перечисления" Тогда
		ОбъектМетаданных = Метаданные.Перечисления[subtype];
		Для каждого Перечисление Из ОбъектМетаданных.ЗначенияПеречисления Цикл
			МассивИменПредопределенных.Добавить(Перечисление.Имя);
		КонецЦикла;    
		type = "Перечисление";
	ИначеЕсли type = "ПланВидовРасчета" или type = "ПланыВидовРасчета" Тогда
		ОбъектМетаданных = Новый (type + "Менеджер");
		ОбъектМетаданных = ОбъектМетаданных[subtype];	
		
		ИменаПредопределенных = ОбъектМетаданных.Выбрать();
		Пока ИменаПредопределенных.Следующий() Цикл
			МассивИменПредопределенных.Добавить(ИменаПредопределенных.Код);
			СоответствиеПредопределенных.Вставить(СокрЛП(ИменаПредопределенных.Код), ИменаПредопределенных.Ссылка);
		КонецЦикла;
		Возврат СоответствиеПредопределенных; 
	Иначе
		Возврат СоответствиеПредопределенных;
	КонецЕсли;
	
	МенеджерОбъекта = Новый(type + "Менеджер" + "." + subtype);
	Для каждого ИмяПредопределенного Из МассивИменПредопределенных Цикл
		Попытка
			СоответствиеПредопределенных.Вставить(ИмяПредопределенного, МенеджерОбъекта[ИмяПредопределенного]);
		Исключение
			Продолжить;
		КонецПопытки;
	КонецЦикла;
	
	Возврат СоответствиеПредопределенных;
	
КонецФункции
