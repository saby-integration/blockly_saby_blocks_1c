
// Функция block_to_number_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Строка - Результат выполения функции
//
//DynamicDirective
Функция block_to_number_calc_value(block_type, node, path, context, block_context)
	Попытка
		// BSLLS:TryNumber-off
		// Для идентичности реализации блока
		Результат = Число(get_prop(block_context, "VALUE"));
		// BSLLS:TryNumber-on
		Возврат Результат;
	Исключение
		Возврат 0;
	КонецПопытки;
КонецФункции
