Функция block_append_status_from_is_calc_value(block_type, node, path, context, block_context)
	СписокОбъектовСбис = get_prop(block_context, "OBJECTS");
	
	ТаблицаИдентификаторов = ПолучитьТаблицуИдентификаторовОбъектовСбис(СписокОбъектовСбис);
	ТаблицаСсылок = СтатусыДокументовПолучитьСостоянияОбъектов(ТаблицаИдентификаторов);
	Для Каждого ОбъектСбис Из СписокОбъектовСбис Цикл
		Если get_prop(ОбъектСбис, "Документ") <> Неопределено Тогда
			Ид = get_prop(ОбъектСбис["Документ"],"Идентификатор");
		Иначе
			Ид = get_prop(ОбъектСбис,"Идентификатор");	
		КонецЕсли;
		Данные = ТаблицаСсылок.Найти(Ид, "UID");
		Если ЗначениеЗаполнено(Данные.LINK) Тогда
			Если Данные.LINK.Проведен Тогда 
				Статус1С = 0;
			ИначеЕсли Данные.LINK.ПометкаУдаления Тогда 
				Статус1С = 2;
			Иначе
				Статус1С = 1;
			КонецЕсли;
		Иначе
			Статус1С = -1;
		КонецЕсли;			
		ОбъектСбис.Вставить("Статус1С", Статус1С);
		ОбъектСбис.Вставить("ДокументИС", Данные.LINK);
	КонецЦикла;
	Возврат СписокОбъектовСбис;

КонецФункции

Функция ПолучитьТаблицуИдентификаторовОбъектовСбис(СписокОбъектовСбис)
	tUID = Новый ТаблицаЗначений;
	tUID.Колонки.Добавить("UID", Новый ОписаниеТипов("Строка") );
	Для Каждого ОбъектСбис Из СписокОбъектовСбис Цикл
		Если get_prop(ОбъектСбис, "Документ") <> Неопределено Тогда
			ОбъектСбис = ОбъектСбис["Документ"];
		КонецЕсли;
		НовСтрока = tUID.Добавить();
		UID = get_prop(ОбъектСбис,"Идентификатор");    
		НовСтрока.UID = Формат(UID, "ЧГ=0");
	КонецЦикла;
	Возврат tUID; 
КонецФункции

