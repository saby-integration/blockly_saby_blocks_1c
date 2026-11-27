
// Функция block_try_catch2_calc_value
//
// Параметры:
//  block_type - Строка - Название блока
// 	node - Структура - Dom структура хмл
//  path - Строка - Пусть до блока по алгоритму
//  context - Структура - Общий контекст алгоритма
//  block_context - Структура - Контекст исполняемого блока
//  БлокВыполнен - Булево - Признак выполнения блока
//
// Возвращаемое значение:
//  - Неопределено - Результат обсчета алгоритма
//
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS-off
//DynamicDirective
Функция block_try_catch2_calc_value(block_type, node, path, context, block_context)

	Если Не block_context.Свойство("_try_complete") Тогда
		NodeTry = workspace_find_statement_by_name(node, "TRY");

		Попытка
			block_execute_all_next(
				NodeTry, path + ".try", 
				context, block_context, Истина);
			block_context.Вставить("_try_complete", Истина);
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();
			ОшибкаРасширенная = ExtExceptionAnalyse(ИнфОбОшибке);
			ОШИБКА = get_prop(block_context, "ERROR");	
			
			ПользовательскоеИсключение =  ЭтоПользовательскоеИсключение(ОшибкаРасширенная.type);
			Если ПользовательскоеИсключение Тогда

				Если Не block_context.Свойство("ERROR") Тогда

					block_context.Вставить("ERROR", ОшибкаРасширенная);
					block_context.Вставить("_try_complete", Истина);

					block_multithreadloop_clear_child_context(block_context);
					context_set_next_step();
					
					block_set_variable(context, block_context["VAR"], block_context["ERROR"]);
				КонецЕсли;

				ПерехватЗавершение = get_prop(block_context, "_catch_complete", Ложь);	
				Если Не block_context.Свойство("_catch_complete") Тогда
					block_context.Вставить("_catch_complete", Ложь);
				КонецЕсли;

			ИначеЕсли ЭтоСлужебнаяОшибкаБлока(ОшибкаРасширенная.type) Тогда

				ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке);
			Иначе

				ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке);
			КонецЕсли;

		КонецПопытки;
	КонецЕсли;

	ПерехватЗавершение = get_prop(block_context, "_catch_complete", Ложь);
	Если block_context.Свойство("_catch_complete")
			И Не ПерехватЗавершение = Истина Тогда

		CountCatch = workspace_find_mutation_by_name(node, "items", 0);
		ОШИБКА = get_prop(block_context, "ERROR");	
		ErrorType = get_prop(ОШИБКА, "type");

		CompletedCatches = Новый Соответствие;
		Для Счет = 0 По CountCatch - 1 Цикл
			СчетСтрокой = Формат(Счет, "ЧН=0; ЧГ=0");

			ИмяТипаОшибки = "PARAM" + СчетСтрокой + "_ERROR_TYPE";
			Если get_prop(block_context, ИмяТипаОшибки) <> ErrorType Тогда
				// Тип исключения не совпал
				Продолжить;
			КонецЕсли;

			Если CompletedCatches[ErrorType] = Истина Тогда
				// Такое исключение уже обработано
				Продолжить;
			КонецЕсли;

			NodeCatch = workspace_find_statement_by_name(node, "PARAM" + СчетСтрокой + "_CATCH");

			block_execute_all_next(
				NodeCatch, path + ".catch",
				context, block_context, Истина);
			CompletedCatches.Вставить(ErrorType, Истина);
		КонецЦикла;

		block_context.Вставить("_catch_complete", Истина);
	КонецЕсли;

	Возврат Неопределено;
КонецФункции
// BSLLS-on
