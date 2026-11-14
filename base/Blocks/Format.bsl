
// Функция block_format_calc_value
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
Функция block_format_calc_value(block_type, node, path, context, block_context)
	value = Неопределено;
	block_context.Свойство("value", value);
	operation = block_context["type"];
	format_string = block_context["template"];
	УбратьПрефиксыИзФормата(format_string);
	Если operation = "to_date" Тогда
	    result = ПреобразоватьСтрокуВДату(format_string, value);
		ВставитьСвойствоЕслиНет(block_context, "result", result);	
	ИначеЕсли operation = "from_date" Тогда
		ВставитьСвойствоЕслиНет(block_context, "result", Формат(value, "ДФ=" + format_string));
	ИначеЕсли operation = "to_string" Тогда
		Если значениеЗаполнено(format_string) Тогда
			result = Формат(value, format_string);
		Иначе
			result = Строка(value);	
		КонецЕсли;
		ВставитьСвойствоЕслиНет(block_context, "result", result);
	Иначе
		Если operation = "to_number" Тогда
			Если ЗначениеЗаполнено(value) Тогда
				ВставитьСвойствоЕслиНет(block_context, "result", Число(value));
			Иначе
				ВставитьСвойствоЕслиНет(block_context, "result", 0);
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;	
	Возврат block_context["result"];
КонецФункции

// Функция УбратьПрефиксыИзФормата
//
// Параметры:
// format_string - Строка - Строка формата
//
//DynamicDirective
Процедура УбратьПрефиксыИзФормата(format_string)
	format_string = СтрЗаменить(format_string, "ДФ=", "");
	format_string = СтрЗаменить(format_string, "ДЛФ=", "");
КонецПроцедуры	

// Функция block_format_get_node_field
//
// Параметры:
// node - XML - Текущий обрабатываемый узел XML
//
// Возвращаемое значение:
//  Соответствие - Результат выполения функции
//
//DynamicDirective
Функция block_format_get_node_field(node)	
	Возврат Workspace.ВычислитьВыражениеXpath("./b:field", node, размыватель).ПолучитьСледующий().ТекстовоеСодержимое; 
КонецФункции
