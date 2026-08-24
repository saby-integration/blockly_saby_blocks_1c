
// Функция block_to_string_calc_value
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
Функция block_to_string_calc_value(block_type, node, path, context, block_context)
	Значение = get_prop(block_context, "VALUE");
	Если Не ЗначениеЗаполнено(Значение) Тогда
		Возврат "";
	КонецЕсли;
	Возврат ТранспортИнтеграции.local_helper_json_encode(Значение);
КонецФункции
