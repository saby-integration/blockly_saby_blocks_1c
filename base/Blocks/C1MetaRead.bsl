
// Функция block_c1_meta_read_calc_value
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
//DynamicDirective
Функция block_c1_meta_read_calc_value(block_type, node, path, context, block_context)
		variable = block_context.variable;
	НовыйОбъект = block_get_variable(context, variable);
	Попытка     
		#Если Сервер Тогда  
			block_set_variable(context, variable, НовыйОбъект.ПолучитьОбъект()); 
		//	context_variables_get(context)[variable] = НовыйОбъект.ПолучитьОбъект();
		#Иначе 
			block_set_variable(context, variable, ПолучитьСтруктуруИзОбъекта(НовыйОбъект)); 
		//	context_variables_get(context)[variable] = ПолучитьСтруктуруИзОбъекта(НовыйОбъект);	
		#КонецЕсли
	Исключение
		ИнфОбОшибке	= ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Переменная " + variable + " не возвращает объекта по ссылке.", " ИмяSABY в блоке " + block_type,, add_block_to_dump(block_context)));
	КонецПопытки;	
	Возврат Неопределено;
КонецФункции
