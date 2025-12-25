
// Функция block_saby_write_document_calc_value
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
Функция block_saby_write_document_calc_value(block_type, node, path, context, block_context) 
	Попытка
		doc = get_prop(block_context, "doc");
		Результат = ТранспортИнтеграции.local_helper_write_document(context.params, doc);
		Возврат Результат;
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,add_block_to_dump(block_context));	
	КонецПопытки		
КонецФункции	
