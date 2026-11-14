
// Функция block_c1_tab_doc_to_pdf_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Структура - Результат выполнения функции
//
//DynamicDirective
Функция block_c1_tab_doc_to_pdf_calc_value(block_type, node, path, context, block_context)
	begin = ДатаВМиллисекундах();
	Title = "Преобразование ТабличногоДокумента в PDF";
	Subtitle = get_prop(block_context, "__id");
	required_param = Новый Массив;
	required_param.Добавить("TAB_DOC");
	block_check_required_param_in_block_context(required_param, block_context);
	Попытка
		ТаблДокумент = block_context.TAB_DOC;
		ВложениеPDF = Неопределено;
		Если ТипЗнч(ТаблДокумент) <> Тип("ТабличныйДокумент") Тогда
			ВызватьИсключение ("Передан не ТабличныйДокумент");
		КонецЕсли;
		Если ТаблДокумент.ВысотаТаблицы > 0 Тогда
			// BSLLS:UsingSynchronousCalls-off - для совместимости со старыми платформами
			#Если ВебКлиент Тогда
				// BSLLS:TempFilesDir-off
				ИмяФайла = КаталогВременныхФайлов() + Строка(Новый УникальныйИдентификатор) + ".pdf";
				// BSLLS:TempFilesDir-on			
			#Иначе	
				ИмяФайла = ПолучитьИмяВременногоФайла(".pdf");
			#КонецЕсли
			ТаблДокумент.Записать(ИмяФайла, ТипФайлаТабличногоДокумента.PDF);
			ДвДанные = Новый ДвоичныеДанные(ИмяФайла);
			ФайлBase64 = Base64Строка(ДвДанные);
			УдалитьФайлы(ИмяФайла);
			// BSLLS:UsingSynchronousCalls-on
			ФайлПРМ = Новый Структура;
			ФайлПРМ.Вставить("ContentType", "application/pdf");
			ФайлПРМ.Вставить("ДвоичныеДанные", ФайлBase64);
			ВложениеPDF = Новый Структура;
			ВложениеPDF.Вставить("Файл", ФайлПРМ);
		КонецЕсли;
	Исключение 
		ИнформацияОбОшибкеБлока = ИнформацияОбОшибке();
		ОшибкаБлокаСтруктура = NewExtExceptionСтруктура(ИнформацияОбОшибкеБлока);
		Если ЭтоСлужебнаяОшибкаБлока(ОшибкаБлокаСтруктура.type) Тогда
			ВызватьИсключение ИнформацияОбОшибкеБлока.Описание; // (исходное исключение)
		КонецЕсли;
		ActionData = Новый Структура;
		ActionData.Вставить("message", get_prop(ОшибкаБлокаСтруктура, "message"));
		ActionData.Вставить("detail", get_prop(ОшибкаБлокаСтруктура, "detail"));
		end = ДатаВМиллисекундах();
		block_saby_execute_action_write_esoaction(begin, end, Title, Subtitle, ActionData, , 100);		
		ВызватьИсключение NewExtExceptionСтрока(ИнформацияОбОшибкеБлока,,,,add_block_to_dump(block_context));;	
	КонецПопытки;
	end = ДатаВМиллисекундах();
	block_saby_execute_action_write_esoaction(begin, end, Title, Subtitle);			
	Возврат ВложениеPDF;
КонецФункции
