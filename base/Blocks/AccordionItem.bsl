Функция block_accordion_item_calc_value(block_type, node, path, context, block_context)
	result = Новый Массив();
	param = Новый Соответствие;
	copy_block_context(param, block_context);
	param.Вставить("level", 1);
	children = get_prop(block_context, "children");
	Если children <> Неопределено Тогда
		param.Вставить("parent@", Истина);
		accordion_fill_children(children, param["id"], result);
		param.Удалить("children");
	Иначе
		param.Вставить("parent@", Ложь);
	КонецЕсли;
	result.Добавить(param);
	Возврат result;
КонецФункции

Процедура accordion_fill_children(children, parent, result)
	Для Каждого childs Из children Цикл
		Для Каждого child Из childs Цикл
			child["level"] = child["level"] + 1;
			child["parent"] = parent;
			result.Добавить(child);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры
