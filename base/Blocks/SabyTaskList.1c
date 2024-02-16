Функция saby_task_list_items(context, block_context)
	result = local_helper_task_list(context.params);
	Если result = Неопределено Тогда
		result = Новый Массив;
	КонецЕсли;
	Если block_context.index < result["Реестр"].Количество() - 1 Тогда 
		Возврат result["Реестр"];
	Иначе
		Возврат Новый Массив;
	КонецЕсли	
КонецФункции	
