//DynamicDirective
Функция block_text_charAt_calc_value(block_type, node, path, context, block_context)
	result = "";
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
