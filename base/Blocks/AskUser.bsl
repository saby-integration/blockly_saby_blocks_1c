
// Функция block_ask_user_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Строка - ответ пользователя
//
//DynamicDirective
Функция block_ask_user_calc_value(block_type, node, path, context, block_context)
	// Проверка на наличие обязательных параметров
	required_param = Новый Массив;
	required_param.Добавить("QUESTION");
	block_check_required_param_in_block_context(required_param, block_context);
	// Для автоматических операций возвращаем значение по умолчанию, если не указано валимся
	Попытка
		ЗначениеПоУмолчанию = block_context.ANSWERS[0];
	Исключение
		ЗначениеПоУмолчанию = Неопределено;
	КонецПопытки;
	Если НЕ ЗначениеЗаполнено(ЗначениеПоУмолчанию) Тогда
		ВызватьИсключение "ask_user: Не указан ответ по умолчанию";
	КонецЕсли;
	Робот = get_prop(context.operation, "isRobot", Ложь);
	Если Робот Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	// Прерываемся на вопрос пользователю
	Если get_prop(block_context, "__deferred") = Неопределено Тогда
		Данные = Новый Структура;
		Данные.Вставить("ТекстВопроса", block_context.QUESTION);
		Данные.Вставить("Ответы", block_context.ANSWERS);
		__deferred = Новый УникальныйИдентификатор();
		block_context.Вставить("__deferred", Строка(__deferred)); // кладем новый уид в   __deferred
		command = Новый Структура("name, params, uuid, data",
			"СпроситьПользователя",
			Данные,
			block_context["__deferred"]); // формируем структуру command, в которую кладем "name, params, uid"
		context.commands.Добавить(command);
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS:UnusedLocalVariable-off
		Currentblock_context = block_context;
// BSLLS:UnusedLocalVariable-on
		_ДанныеИсключения = Новый Структура("context, block_context", context, block_context);
		ВызватьИсключение NewExtExceptionСтрока(, "DeferredOperation", , , _ДанныеИсключения, "DeferredOperation");
	Иначе
		command_result = get_prop(context.command_result, block_context.__deferred);
		Если command_result.status = "complete" Тогда
			Возврат command_result.result; // Ответ пользователя
		Иначе
			Если command_result.status = "error" Тогда
				ВызватьИсключение NewExtExceptionСтрока(command_result.result, , , "СпроситьПользователя");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецФункции

