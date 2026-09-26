
// Функция block_fed_convert_xml_to_object_calc_value
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
Функция block_fed_convert_xml_to_object_calc_value(block_type, node, path, context, block_context)
	begin = ДатаВМиллисекундах();
	Title = "Получение XML из подстановки";
	Попытка
	result = ТранспортИнтеграции.local_helper_fed_convert_xml_to_obj(
				context.params,
				block_context["pattern"],
				block_context["data"]
				);
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
		block_saby_execute_action_write_esoaction(begin, end, Title, Неопределено, Data, , 100);		
		ВызватьИсключение ИнфОбОшибке.Описание;	
	КонецПопытки;		
	end = ДатаВМиллисекундах();
	block_saby_execute_action_write_esoaction(begin, end, Title, Неопределено);			
	Возврат result;
КонецФункции	
