
//DynamicDirective

Процедура block_text_charAt_check_input(block_context) 
	Value = get_prop(block_context, "VALUE"); 
	Если  Value = Неопределено Тогда
		ВызватьИсключение "В блоке text_charAt не передан исходный текст отбора";
	КонецЕсли;
   	where = block_context["WHERE"]; 
	Если Не (where = "FROM_START" Или where = "FROM_END") Тогда  
		Возврат;
	КонецЕсли;
	ОписаниеТипа = Новый ОписаниеТипов("Число");
	AT = ОписаниеТипа.ПривестиЗначение(block_context["AT"]);
	Если AT <= 0 Тогда
		ВызватьИсключение "В блоке text_charAt передан не корректный номер символа";
	КонецЕсли;	
КонецПроцедуры

// Функция block_text_charAt_calc_value
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
//DynamicDirective
Функция block_text_charAt_calc_value(block_type, node, path, context, block_context)
	result = "";
	block_text_charAt_check_input(block_context);
	where = block_context["WHERE"];
	Если where = "FROM_START" Тогда
		result = Сред(block_context["VALUE"], block_context["AT"], 1);
	ИначеЕсли where = "FROM_END" Тогда
		Если СтрДлина(block_context["VALUE"]) >= block_context["AT"] Тогда
			result = Лев(Прав(block_context["VALUE"], block_context["AT"]), 1);
		Иначе
			result = "";
		КонецЕсли;
	ИначеЕсли where = "FIRST" Тогда
		result = Лев(block_context["VALUE"], 1);
	ИначеЕсли where = "LAST" Тогда
		result = Прав(block_context["VALUE"], 1);
	ИначеЕсли where = "RANDOM" Тогда
		ГСЧ = Новый ГенераторСлучайныхЧисел();
		СлучайныйИндекс = ГСЧ.СлучайноеЧисло(1, СтрДлина(block_context["VALUE"]));
		result = Сред(block_context["VALUE"], СлучайныйИндекс, 1);
	Иначе
		ВызватьИсключение "В блоке text_charAt не поддерживается "+ where;
	КонецЕсли;
	Возврат result;
КонецФункции
