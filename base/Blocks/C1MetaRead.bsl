
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
	begin = ДатаВМиллисекундах();
	Title = "Чтение объекта метаданных";
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
	    Subtitle = get_prop(block_get_variable(context, variable), "ИмяИС");
	Исключение
		ИнфОбОшибке	= ИнформацияОбОшибке();
		ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
		Если ЭтоСлужебнаяОшибкаБлока(ОшибкаСтруктура.type) Тогда
			ВызватьИсключение ИнфОбОшибке.Описание; // (исходное исключение)
		КонецЕсли;
        Data = Новый Структура;
		Data.Вставить("message", get_prop(ОшибкаСтруктура, "message"));
		Data.Вставить("detail", get_prop(ОшибкаСтруктура, "detail"));
        end = ДатаВМиллисекундах();
		block_saby_execute_action_write_esoaction(begin, end, Title, Subtitle, Data, , 100);		
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Переменная " + variable + " не возвращает объекта по ссылке.", " ИмяSABY в блоке " + block_type,, add_block_to_dump(block_context)));
	КонецПопытки;
	end = ДатаВМиллисекундах();
	block_saby_execute_action_write_esoaction(begin, end, Title, Subtitle);			
	Возврат Неопределено;
КонецФункции
