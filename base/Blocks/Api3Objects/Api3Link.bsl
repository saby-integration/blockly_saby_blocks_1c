//DynamicDirective
Функция block_api3_link_calc_value(block_type, node, path, context, block_context)
	param = Новый Структура("ИдИС, ТипИС, ИмяИС, ini_name, Название, _print_forms");
	ЗаполнитьЗначенияСвойств(param, block_context);
	Возврат param;	
КонецФункции
