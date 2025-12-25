
// Функция block_fed_convert_xml_to_object_calc_value
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
Функция block_fed_convert_xml_to_object_calc_value(block_type, node, path, context, block_context)
	result = ТранспортИнтеграции.local_helper_fed_convert_xml_to_obj(
				context.params,
				block_context["pattern"],
				block_context["data"]
				);
	Возврат result;
КонецФункции	
