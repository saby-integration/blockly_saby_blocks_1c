
// Функция block_get_ini_calc_value
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
Функция block_get_ini_calc_value(block_type, node, path, context, block_context) Экспорт  
	ИмяИни = get_prop(block_context, "name");
	ПодготовитьИниИКонтекст();
	Если get_prop(Ini, ИмяИни) = Неопределено Тогда
		мИниФайлов	= Новый Массив();
		мИниФайлов.Добавить(Новый Структура("type, name", "Показатель", ИмяИни));
		connection_uuid = context.operation.connection_uuid;
		Если НЕ ЗначениеЗаполнено(connection_uuid) Тогда
			connection_uuid = context.params.ConnectionId;
		КонецЕсли;	
		params	= Новый Структура(
		"props, ini",
		Новый Структура("id, type_data, requested_ini_format", connection_uuid, 1, "Dom1C"), мИниФайлов);
		res = ТранспортИнтеграции.local_helper_integration_api(context.params, "IntegrationConnection.ReadConnection", params, "int-settings");
		res_data = get_prop(res, "data");
		ini = get_prop(res_data, ИмяИни);
		ini_data = get_prop(ini, "data");
		
	КонецЕсли;
	Возврат ini_data; 
КонецФункции
