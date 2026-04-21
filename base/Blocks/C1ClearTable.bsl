
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
	begin = ДатаВМиллисекундах();
	Title = "Очистка таблицы";
	Subtitle = get_subtitle_from_comment_id(node, block_context);
	var_name = block_c1_clear_table_get_var_name(node);
	res = block_c1_clear_table_get_get_variable(var_name);
	Попытка
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
	Исключение 
		ИнфоОбОшибке = ИнформацияОбОшибке();
		ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфоОбОшибке);
		Если ЭтоСлужебнаяОшибкаБлока(ОшибкаСтруктура.type) Тогда
			ВызватьИсключение ИнфоОбОшибке.Описание; // (исходное исключение)
		КонецЕсли;
        DataAction = Новый Структура;
		DataAction.Вставить("message", get_prop(ОшибкаСтруктура, "message"));
		DataAction.Вставить("detail", get_prop(ОшибкаСтруктура, "detail"));
        end = ДатаВМиллисекундах();
		block_saby_execute_action_write_esoaction(begin, end, Title, Subtitle, DataAction, , 100);		
		ВызватьИсключение ИнфоОбОшибке.Описание;		
	КонецПопытки;
	end = ДатаВМиллисекундах();
	block_saby_execute_action_write_esoaction(begin, end, Title, Subtitle);			
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
