
// Функция block_c1_clear_table_execute
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Неопределено - Результат выполения функции
//
//DynamicDirective
Функция block_c1_clear_table_execute(block_type, node, path, context, block_context)
	var_name = block_c1_clear_table_get_var_name(node);
	res = block_c1_clear_table_get_get_variable(var_name);
	#Если Сервер Тогда
		Если Найти(НРег(ТипЗнч(res)), " табличная часть") Или ТипЗнч(res) = Тип("ТаблицаЗначений") 
			Или ТипЗнч(res) = Тип("Массив") Тогда
			res.Очистить();
		Иначе
			Сообщить("Неизвестный блок в методе c1_clear_table");
		КонецЕсли;
	#Иначе 
		Если ТипЗнч(res) = Тип("Массив") Тогда
			res.Очистить();
		Иначе
			Сообщить("Неизвестный блок в методе c1_clear_table");
		КонецЕсли;		
	#КонецЕсли
	
	Возврат Неопределено;	
КонецФункции

// Функция block_c1_clear_table_get_var_name
//
// Параметры:
// node - XML - Текущий обрабатываемый узел XML
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
//DynamicDirective
Функция block_c1_clear_table_get_var_name(node)	
	Возврат node.ДочерниеУзлы[0].ТекстовоеСодержимое;
КонецФункции

// Функция block_c1_clear_table_get_get_variable
//
// Параметры:
// name - Строка - name
//
// Возвращаемое значение:
//  Структура - Результат выполения функции
//
//DynamicDirective
Функция block_c1_clear_table_get_get_variable(name)
	Возврат context_variables_get(context)[name];	
КонецФункции		
