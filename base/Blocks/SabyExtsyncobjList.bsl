//DynamicDirective		
Функция	saby_extsyncobj_list_items(context, block_context)
	extsyncdoc_uuid = context.operation.operation_uuid;
	extra_fields = Новый Массив;
	extra_fields.Добавить("ClientType");

	filter = Новый Структура("SyncDocId", extsyncdoc_uuid);
	
	sorting = Новый Массив;
	Страниц	= 0;
	Если НЕ block_context.Свойство("page", Страниц) Тогда
		Страниц = 0;
	КонецЕсли;
	pagination = Новый Структура("PageSize, Page", 15, Страниц );

	result = Транспорт.local_helper_extsyncobj_list(context.params, extra_fields, filter, sorting, pagination);
	result = result["Result"];
	Если result = Неопределено Тогда
		result = Новый Массив;
	КонецЕсли;
	return result;
КонецФункции
