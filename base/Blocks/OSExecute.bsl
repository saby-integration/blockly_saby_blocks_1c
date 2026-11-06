
// Функция block_os_execute_calc_value
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
Функция block_os_execute_calc_value(block_type, node, path, context, block_context)
	Если get_prop(block_context, "__deferred") = Неопределено Тогда
		Данные = block_context.COMMAND;
		__deferred = Новый УникальныйИдентификатор(); 
		block_context.Вставить("__deferred", Строка(__deferred)); // кладем новый уид в   __deferred
		command = Новый Структура("name, params, uuid, data",
			"ВыполнитьвОС",
			Данные,
			block_context["__deferred"]); // формируем структуру command, в которую кладем "name, params, uid"
		context.commands.Добавить(command);
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS:UnusedLocalVariable-off
		Currentblock_context = block_context;
// BSLLS:UnusedLocalVariable-on
		_ДанныеИсключения = Новый Структура("uuid, context, block_context", block_context["__deferred"], context, block_context);
		_ДанныеИсключения.Вставить("multi_thread_loop_block_context", Saby_КопияСтруктуры(block_context));			
		_ДанныеИсключения.Вставить("multi_thread_loop_variable_scopes", Saby_КопияМассива(context.variable_scopes, context.variable_scope_current));
		ВызватьИсключение NewExtExceptionСтрока(, "DeferredOperation", , , _ДанныеИсключения, "DeferredOperation");
	Иначе
		command_result = get_prop(context.command_result, block_context.__deferred);
		Если command_result.status = "complete" Тогда
			block_context.Вставить("result", Истина);
			ВызватьИсключение NewExtExceptionСтрока( , , , , , "DeferredComplete");	
		Иначе
			Если command_result.status = "error" Тогда	
				ВызватьИсключение NewExtExceptionСтрока(command_result.result, , , "ВыполнитьвОС");	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецФункции
