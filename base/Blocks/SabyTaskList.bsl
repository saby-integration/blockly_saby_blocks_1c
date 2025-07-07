
// Функция saby_task_list_items
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Массив - Результат выполения функции
//
//DynamicDirective
Функция saby_task_list_items(context, block_context)
	result = ТранспортИнтеграции.local_helper_task_list(context.params);
	Если result = Неопределено Тогда
		result = Новый Массив;
	КонецЕсли;
	Если block_context.index < result["Реестр"].Количество() - 1 Тогда 
		Возврат result["Реестр"];
	Иначе
		Возврат Новый Массив;
	КонецЕсли	
КонецФункции	
