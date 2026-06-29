
// Функция block_c1_ref_from_api3_calc_value
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
Функция block_c1_ref_from_api3_calc_value(block_type, node, path, context, block_context)
	begin = ДатаВМиллисекундах();
	Title = "Получение ссылки из API3";
	Если get_prop(block_context.API3,"ИдИС") = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Если Найти(block_context.API3["ИмяИС"], ".") > 0 Тогда
		ИмяИС = block_context.API3["ИмяИС"];
	Иначе
		ИмяИС = block_context.API3["ТипИС"] + "." + block_context.API3["ИмяИС"];
	КонецЕсли;
	ИдИС = block_context.API3["ИдИС"];
	Subtitle = Строка(ИмяИС) + " " + Строка(ИдИС); 
	Попытка
		СсылкаНаобъект = ПолучитьСсылкуПоИдИС(ИмяИС, block_context.API3["ИдИС"]);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
		Если ЭтоСлужебнаяОшибкаБлока(ОшибкаСтруктура.type) Тогда
			ВызватьИсключение ИнфОбОшибке.Описание; // (исходное исключение)
		КонецЕсли;
        Data = Новый Структура;
		Data.Вставить("message", get_prop(ОшибкаСтруктура, "message"));
		Data.Вставить("detail", get_prop(ОшибкаСтруктура, "detail"));
        end = ДатаВМиллисекундах();
		block_saby_execute_action_write_esoaction(begin, end, Title, Subtitle, Data, , 100);		
		ИдИС = block_context.API3["ИдИС"];
		МассивИС = Новый Массив();
		МассивИС.Добавить(ИдИС);
		remove_mapping = Новый Соответствие;
		remove_mapping.Вставить(ИмяИС, МассивИС);
		dump = Новый Соответствие;
		dump.Вставить("remove_mapping", remove_mapping); 
		detail = Строка(ИмяИС) + " - " + Строка(ИдИС);
		ВызватьИсключение NewExtExceptionСтрока(, "Объект не найден в ИС", detail, , dump, "NotFound");
	КонецПопытки;
	Subtitle = Строка(СсылкаНаобъект); 
	end = ДатаВМиллисекундах();
	block_saby_execute_action_write_esoaction(begin, end, Title, Subtitle);	
	Возврат СсылкаНаобъект;
КонецФункции
