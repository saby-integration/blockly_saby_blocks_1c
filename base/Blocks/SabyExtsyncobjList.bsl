
// Функция saby_extsyncobj_list_items
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Массив - Результат выполения функции
//
//DynamicDirective		
Функция	saby_extsyncobj_list_items(context, block_context)
	extsyncdoc_uuid = context.operation.operation_uuid;
	extra_fields = Новый Массив;
	extra_fields.Добавить("ClientType");
	extra_fields.Добавить("Subobject");
	
	Если get_prop(block_context, "CountObjects") = Неопределено Тогда
		Операция = block_extsyncdoc_run_extsyncdoc_read_saby(context, block_context);
		block_context.Вставить("CountObjects", get_prop(Операция, "CountObjects", 0));
		block_context.Вставить("CountObjectsProcessed", 0);	
		block_context.Вставить("Notification", "Обработка объектов обмена ");	
	КонецЕсли;

	filter = Новый Структура("SyncDocId", extsyncdoc_uuid);
	
	sorting = Новый Массив;
	Страниц	= 0;
	Если НЕ block_context.Свойство("page", Страниц) Тогда
		Страниц = 0;
	КонецЕсли;
	pagination = Новый Структура("PageSize, Page", 15, Страниц );

	result = ТранспортИнтеграции.local_helper_extsyncobj_list(context.params, extra_fields, filter, sorting, pagination);
	result = result["Result"];
	Если result = Неопределено Тогда
		result = Новый Массив;
	КонецЕсли;
	Возврат result;
КонецФункции
