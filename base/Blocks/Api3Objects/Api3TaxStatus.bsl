
// Функция block_api3_taxstatus_calc_value
//
// Параметры:
//   block_type - Строка - имя API3 блока.
//   node - ЭлементDOM - блок Blockly
//   path - Строка - Выполняемое действие функции.
//   context - Структура - Параметры инишки.
//   block_context - Структура - Параметры блока.
//
// Возвращаемое значение:
//   Соответствие - API3 объект.
//
//DynamicDirective
Функция block_api3_taxstatus_calc_value(block_type, node, path, context, block_context)
	Возврат ЗаполнитьЗначенияApi3Objects("Перечисления", "НалоговыйСтатус", block_context);
КонецФункции
