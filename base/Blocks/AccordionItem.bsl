
// Функция block_accordion_item_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Массив - Результат выполения функции
//
//DynamicDirective
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

// Процедура simple_block_execute_indicator
//
// Параметры:
// children - XML - Дочерний блок
// parent - XML - Родительский блок
// result - Структура - Результат выполнения метода
//
//DynamicDirective
Процедура accordion_fill_children(children, parent, result)
	Для Каждого childs Из children Цикл
		Для Каждого child Из childs Цикл
			child["level"] = child["level"] + 1;
			child["parent"] = parent;
			result.Добавить(child);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры
