
// Функция block_c1_predefine_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
// BSLLS:TooManyReturns-off
// BSLLS:AllFunctionPathMustHaveReturn-off
Функция block_c1_predefine_value_calc_value(block_type, node, path, context, block_context)
	// BSLLS:IfElseIfEndsWithElse-off
	Если block_context.TYPE = "Справочники" Тогда
		Возврат Справочники[block_context.SUBTYPE][block_context.NAME];
	ИначеЕсли block_context.TYPE = "ПланыВидовХарактеристик" Тогда
		Возврат ПланыВидовХарактеристик[block_context.SUBTYPE][block_context.NAME];
	ИначеЕсли block_context.TYPE = "ПланыСчетов" Тогда
		Возврат ПланыСчетов[block_context.SUBTYPE][block_context.NAME];
	ИначеЕсли block_context.TYPE = "ПланыВидовРасчета" Тогда
		Возврат ПланыВидовРасчета[block_context.SUBTYPE][block_context.NAME];
	ИначеЕсли block_context.TYPE = "Перечисления" Тогда
		Возврат Перечисления[block_context.SUBTYPE][block_context.NAME];
	КонецЕсли;
	// BSLLS:IfElseIfEndsWithElse-on
КонецФункции
// BSLLS:AllFunctionPathMustHaveReturn-on
// BSLLS:TooManyReturns-on


