
// Функция block_obj_update_calc_value
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
Функция block_obj_update_calc_value(block_type, node, path, context, block_context)
	variable_name = block_context["VAR"];
	obj = block_get_variable(context, variable_name);
	value = block_context["VALUE"];
    res = Новый Структура();
	Если ТипЗнч(obj) = Тип("Структура") или ТипЗнч(obj) = Тип("Соответствие") Тогда
		res = ОбновитьСтруктуруРекурсивно(obj, value);	
	Иначе   
		ТекстОшибки = "Не удалось обновить "+ variable_name + ". Проверьте корректность типов данных";
		ВызватьИсключение NewExtExceptionСтрока(, ТекстОшибки);		
	КонецЕсли;
	
	Возврат res;
	
КонецФункции
