//DynamicDirective
Функция block_public_param_get_calc_value(block_type, node, path, context, block_context)
	path = block_context["PATH"];
	default = get_prop(block_context, "DEFAULT");
	obj_name = "context.params." + path;
	Попытка
		obj = context.params;
	Исключение
		ВызватьИсключение "context.params не определена"
	КонецПопытки;	
	Если ЗначениеЗаполнено(path) И Лев(path, 1) = """" Тогда
		path = Сред(path,2,СтрДлина(path));
		Если Прав(path, 1) = """" Тогда
			path = Сред(path,1,СтрДлина(path) - 1);
		КонецЕсли;
		Если obj[path] <> Неопределено Тогда
			Возврат obj[path];
		Иначе
			Возврат "";
		КонецЕсли;
	Иначе
		res = block_obj_get_path_value(obj, path, obj_name);
		Если res = Неопределено И default <> Неопределено Тогда
			Возврат default;
		КонецЕсли;
		Возврат res;
	КонецЕсли;	
КонецФункции	
