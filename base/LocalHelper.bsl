
//Метод для вызова АПИ БЛ
//context - структура
//__kwargs - структура
Функция local_helper_exec_method(context_params, __kwargs = Неопределено) Экспорт
	Перем headers, params, response_type, url, type_request, request_body_type, data;
	kwargs = __kwargs;
	params = Новый Структура;
	Если kwargs = Неопределено Тогда
		kwargs = Новый Структура;
	КонецЕсли;
	Если Не kwargs.Свойство("body_type", request_body_type) Тогда
		//Тип того, как отдаём тело запроса
		request_body_type = "json";
	КонецЕсли;
	Если Не kwargs.Свойство("response", response_type) Тогда
		//То, что ожидается в ответе
		response_type = "json";
	КонецЕсли;
	Попытка
		Если	Не	context_params.Свойство("session")
			И		kwargs.Свойство("auto_auth")
			И		kwargs.auto_auth Тогда
			local_helper_auth_by_login(context_params);
		КонецЕсли;
		
		Если Не kwargs.Свойство("headers", headers) Тогда
			headers = Новый Соответствие;
		КонецЕсли;
		
		Если request_body_type = "json" Тогда
			Если headers.Получить("Content-Type") = Неопределено Тогда
				//headers.Вставить("Content-Type", "application/xml");
				headers.Вставить("Content-Type", "application/json; charset=utf-8");
			КонецЕсли;
			Если kwargs.Свойство("method") Тогда
				data = Новый Структура(
				"jsonrpc,	id,	method",
				"2.0",		1,	kwargs.method);
				headers.Вставить("Content-Type", "application/json-rpc;charset=utf-8");
				Если kwargs.Свойство("params") Тогда
					data.Вставить("params", kwargs.params);
				КонецЕсли;
				Если kwargs.Свойство("protocol") Тогда
					data.Вставить("protocol", kwargs.protocol);
				КонецЕсли;
				data = encode_xdto_json(data);
				params = Новый Структура;
			Иначе
				Если Не kwargs.Свойство("params", params) Тогда
					params = Новый Структура;
				КонецЕсли;
			КонецЕсли;			
		Иначе
			ВызватьИсключение ЗначениеВСтрокуВнутр(ExtException( Новый Структура("message, detail", "Неизвестный тип отправки запроса.", request_body_type), ));
		КонецЕсли;
		Если Не kwargs.Свойство("url", url) Тогда
			url = context_params.api_url + "/service/?srv=1";
		КонецЕсли;
		Если Не kwargs.Свойство("type", type_request) Тогда
			type_request = "post";
		КонецЕсли;
		ПараметрыВыполнения	=	Новый Структура("params, data, headers", params, data, headers);
		Если context_params.Свойство("Proxy") Тогда
			ПараметрыВыполнения.Вставить("Proxy", context_params.Proxy);
		КонецЕсли;         
		
		local_helper_add_auth_header(context_params, headers);
		code_result = local_helper_exec_request(type_request, url, response_type, ПараметрыВыполнения);
		Если code_result.code = 401 Тогда
			Если	kwargs.Свойство("auto_auth")
				И	kwargs.auto_auth Тогда
				local_helper_auth_by_login(context_params);
				local_helper_add_auth_header(context_params, headers);			
				code_result = local_helper_exec_request(type_request, url, response_type, ПараметрыВыполнения);
			КонецЕсли;
		КонецЕсли;
		Если code_result.code = 401 Тогда
			ВызватьИсключение NewExtExceptionСтрока(,"Не верный логин или пароль",,,,"Unauthorized" );
		ИначеЕсли	(code_result.code = 200 или code_result.code = 500) И code_result.result.Получить("error") <> Неопределено Тогда
			//ПОЧЕМУ код - 200, при classid = "{00000000-0000-0000-0000-1FA000001002}
			//https://sbis.ru/help/integration/api/all_methods/auth_one
			//Требуется подтверждение телефона или подтверждение СМС
			msg = code_result.result["error"]["message"];
			ВызватьИсключение NewExtExceptionСтрока(  ,msg, code_result.result );
		ИначеЕсли	code_result.result.Получить("error") <> Неопределено
			И (code_result.code = 501
			Или	code_result.code = 404
			Или	code_result.code = 200) Тогда
			_details = Неопределено;
			msg = code_result.result["error"]["message"];
			_details	= code_result.result["error"].Получить("details");
			Если	(_details <> Неопределено) И	(msg <> _details) Тогда
				msg = msg + ?(Не ПустаяСтрока(msg), " ", "") + _details;
			КонецЕсли;
			ВызватьИсключение NewExtExceptionСтрока(  ,"Ошибка API "+kwargs["method"], msg );
		ИначеЕсли Не (code_result.code = 200 ИЛИ code_result.code = 201) Тогда
			//TODO Текст ошибки в детаил
			ВызватьИсключение NewExtExceptionСтрока(  ,"Неизвестная ошибка", "Код ошибки: " + code_result.code );
		КонецЕсли;
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));
	КонецПопытки;
	Возврат code_result.result;
КонецФункции

Функция local_helper_get_product_version_status(context_params, product, client_version)
	Попытка
		Возврат local_helper_integration_api(context_params, "API3.GetProductVersionStatus", Новый Структура("product, client_version", product, client_version));
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));		
	КонецПопытки;	
КонецФункции

Функция local_helper_extsyncdoc_write(context_params, connection_uuid, extsyncdoc, objects)
	Попытка
		params = Новый Структура("param", Новый Структура("ConnectionId, ExtSyncDoc, ExtSyncObj", connection_uuid, extsyncdoc, objects));
		Возврат local_helper_integration_api(context_params, "ExtSyncDoc.Write", params);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));		
	КонецПопытки;
КонецФункции

Функция local_helper_auth_by_login(context_params, __kwargs = Неопределено) Экспорт
	//TODO
	//Прочитать context_param, еще раз, 
	//Проверить session_begin с тем что мы прочитали из настроек.
	//если во входящих парам  время меньше чем в настройках то, в context_params заменяем session_begin и session
	Попытка
		params = Новый Структура("Логин, Пароль", context_params.login, context_params.password);
		url = context_params.api_url + "/auth/service/";
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,"Не заполнен параметр аутентификации",ИнфОбОшибке.Описание,,,"Unauthorized" );
	КонецПопытки;
	Попытка
		result = local_helper_exec_method(context_params, Новый Структура("url, method, params, auto_auth", url, "СБИС.Аутентифицировать", params, Ложь));
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,,,"Unauthorized" );
	КонецПопытки;
	session = result.Получить("result");
	context_params.Вставить("session", session );
	context_params.Вставить("session_begin", ТекущаяДата());
	context_params.Вставить("need_ticket", Истина);
	НастройкиПодключенияЗаписать(context_params);
	Возврат session;
КонецФункции

Функция local_helper_integration_api(context_params, method, params)
	Попытка
		url = context_params.api_url + "/integration_config/service/";
		result = local_helper_exec_method(context_params, Новый Структура("url, method, params, auto_auth", url, method, params, Истина));
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке,"Ошибка выполнения метода "+method));
	КонецПопытки;
	Возврат result.Получить("result");
КонецФункции

Функция local_helper_api(context_params, method, params) Экспорт
	Попытка
		url = context_params.api_url + "/service/";
		result = local_helper_exec_method(context_params, Новый Структура("url, method, params, auto_auth", url, method, params, Истина));
	Исключение
		//TODO насколько так правлльно разделять просто ошибки выполнения кода, 
		//и анализ исключений разобраных ошибок
		ИнфОбОшибке = ИнформацияОбОшибке();
		parentStruct = ExtExceptionAnalyse(ИнфОбОшибке);
		Если parentStruct.type = "Exception" Тогда
			ВызватьИсключение NewExtExceptionСтрока(,parentStruct.message, "Метод - "+method);
		Иначе
			ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,"Ошибка выполнения метода "+method);
		КонецЕсли;
	КонецПопытки;
	Возврат result.Получить("result");
КонецФункции

Функция local_helper_extsyncdoc_prepare(context, extsyncdoc_uuid, direction)
	Возврат local_helper_integration_api(context, "ExtSyncDoc.Prepare", 
	Новый Структура("SyncDocId, Direction", extsyncdoc_uuid, direction)
	);
КонецФункции

Функция local_helper_extsyncdoc_execute(context, extsyncdoc_uuid, direction)
	Возврат local_helper_integration_api(context, "ExtSyncDoc.Execute",
	Новый Структура("param", Новый Структура("SyncDocId, Direction", extsyncdoc_uuid, direction)));
КонецФункции

Функция local_helper_extsyncdoc_execute_lrs(context, extsyncdoc_uuid, direction)
	Возврат local_helper_integration_api(context, "ExtSyncDoc.ExecuteLRS", Новый Структура("SyncDocId", extsyncdoc_uuid));
КонецФункции

Функция local_helper_extsyncdoc_write_predefined(context_params, ConnectionId, Type, ClientType, Objects)
	
	Попытка
		params = Новый Структура("ConnectionId, Type, ClientType, Objects", ConnectionId, Type, ClientType, Objects);
		Возврат local_helper_integration_api(context_params, "MappingObject.WritePredefined", params);
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке));		
	КонецПопытки;
	
КонецФункции

Функция local_helper_extsyncdoc_get_obj_for_execute(context, extsyncdoc_uuid, direction)
	Возврат local_helper_integration_api(context, "ExtSyncDoc.GetObjectsForExecute", 
	Новый Структура("SyncDocId, Direction", extsyncdoc_uuid, direction)
	);
КонецФункции

Функция local_helper_extsyncdoc_read(context, extsyncdoc_uuid)
	Возврат local_helper_integration_api(context, "API3.ExtSyncDocRead", Новый Структура("param", Новый Структура("SyncDocId", extsyncdoc_uuid)));
КонецФункции

Функция local_helper_mapping_obj_find_and_update(context, _filter, _data)
	response = local_helper_integration_api(context, "MappingObject.FindAndUpdate", 
	Новый Структура("Filter, Data", _filter, _data)
	);
	Если response.Свойство("result") Тогда
		Возврат response.result;
	Иначе
		//ВызватьИсключение СокрЛП(response);
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, СокрЛП(response));
	КонецЕсли;
КонецФункции

Функция local_helper_extsyncdoc_prepare_saby(context, extsyncdoc_uuid)
	Возврат local_helper_integration_api( context, "Connector.Prepare",
	Новый Структура("ConnectorName, SyncDocId","Saby", extsyncdoc_uuid)
	);
КонецФункции

//Выполнение POST/GET запроса
// request_type: get, post, post_binary (в дата лежит имя временного файла)
// response_type: json, text, binary (в ответе будет лежать имя временного файла)

Функция local_helper_exec_request(request_type, Знач request_url, response_type, __kwargs = Неопределено)
	Перем ИмяФайлаОтвета, Proxy, ProxyParam, ssl, headers;
	
	Адрес = РазобратьСтрокуУРЛ(request_url);
	
	Если response_type = "binary" Тогда
		ИмяФайлаОтвета = ПолучитьИмяВременногоФайла();	
	КонецЕсли;
	
	kwargs = __kwargs;
	Если kwargs = Неопределено Тогда
		kwargs = Новый Структура;
	КонецЕсли;
	
	Если Адрес.scheme = "https" Тогда
		ssl = Новый ЗащищенноеСоединениеOpenSSL();
	КонецЕсли;
	Если kwargs.Свойство("Proxy", ProxyParam) Тогда
		Proxy = Новый ИнтернетПрокси;
		Proxy.Установить(ProxyParam.Protocol, ProxyParam.Server, Число(ProxyParam.Port), ProxyParam.User, ProxyParam.Password);
	КонецЕсли;
	
	Если Не kwargs.Свойство("headers", headers) Тогда
		headers = Новый Соответствие;
	КонецЕсли;
	
	Попытка
		http_connection = Новый HTTPСоединение(Адрес.host, Адрес.port,,,Proxy,,ssl);
		http_request	= Новый HTTPЗапрос(Адрес.resource, headers);
		Если request_type = "post" Тогда
			http_request.УстановитьТелоИзСтроки(kwargs.data, "UTF-8");
		ИначеЕсли request_type = "post_binary" Тогда
			http_request.УстановитьИмяФайлаТела(kwargs.data);	
		КонецЕсли;
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, "Ошибка создания HTTP запроса");
	КонецПопытки;
	
	Если request_type = "post" ИЛИ request_type = "post_binary" Тогда
		Попытка
			http_response	= http_connection.ОтправитьДляОбработки(http_request, ИмяФайлаОтвета);
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();
			ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, "Ошибка выполнения HTTP запроса");
		КонецПопытки;
	ИначеЕсли request_type = "get" Тогда
		Попытка
			http_response	= http_connection.Получить(http_request, ИмяФайлаОтвета);	
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();
			ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, "Ошибка выполнения HTTP запроса");
		КонецПопытки;
	Иначе
		ВызватьИсключение NewExtExceptionСтрока(,"Неизвестный тип HTTP запроса", request_type);		
	КонецЕсли;
	
	Возврат local_helper_exec_response(response_type, http_response, ИмяФайлаОтвета);		
	
КонецФункции
		
Функция local_helper_exec_response(response_type, http_response, ИмяФайлаОтвета)
	
	response = Новый Структура("code, result", http_response.КодСостояния);
	
	content_type = http_response.Headers["Content-Type"];
	Попытка
		Если response.code = 200 Тогда
			Если response_type = "json" Тогда
				response.result = local_helper_json_loads(http_response.ПолучитьТелоКакСтроку());	
			ИначеЕсли response_type = "text" Тогда
				response.result = http_response.ПолучитьТелоКакСтроку();
			ИначеЕсли response_type = "binary" Тогда	
				response.result = ИмяФайлаОтвета;
			КонецЕсли;
		Иначе
			Если ИмяФайлаОтвета = Неопределено Тогда
				Тело = http_response.ПолучитьТелоКакСтроку();
			Иначе
				ФайлСОтветом = Новый ЧтениеТекста;
				ФайлСОтветом.Открыть(ИмяФайлаОтвета,КодировкаТекста.UTF8);              
				Тело = ФайлСОтветом.ПрочитатьСтроку();
			КонецЕсли;
			Если Тело = Неопределено Тогда
				response.result = СокрЛП(response.code) + " Неизвестная ошибка";
			Иначе
				Если Найти(content_type, "application/json") > 0 Тогда
					response.result = local_helper_json_loads(Тело);	
				иначе
					response.result = Тело;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Возврат response;		
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, "Ошибка разбора HTTP ответа");
	КонецПопытки;
КонецФункции

Функция local_helper_json_loads(json)
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(json);
	Попытка
		СтрокаВСоответсвие	= ПрочитатьJSON(ЧтениеJSON, Истина); //Для просмотра в отладке
		Возврат СтрокаВСоответсвие;
	Исключение
		ИнфоОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение NewExtExceptionСтрока(ИнфоОбОшибке, "Ошибка чтения JSON");
	КонецПопытки;
КонецФункции

Функция local_helper_write_attachment(context, document)
	Результат	=	local_helper_api(context, "СБИС.ЗаписатьВложение", Новый Структура("Документ", document));
	Возврат Результат;	
КонецФункции

Функция local_helper_prepare_action(context, document)
	Результат	=	local_helper_api(context, "СБИС.ПодготовитьДействие",Новый Структура("Документ", document));
	Возврат Результат;	
КонецФункции

Функция local_helper_execute_action(context, document)
	Результат	=	local_helper_api(context, "СБИС.ВыполнитьДействие",Новый Структура("Документ", document));
	Возврат Результат;	
КонецФункции	

Функция local_helper_find_sbis_object(context, type, filter)
	Результат	=	local_helper_api(context, "API3.FindSbisObject",Новый Структура("Type, Filter", type, filter));
	Возврат Результат;
КонецФункции

Функция РазобратьСтрокуУРЛ(СтрокаАдреса, ПротоколПоУмолчанию = "http")
	Адрес = Новый Структура("scheme, host, port, resource");
	Индекс = Найти(СтрокаАдреса, "://");
	ПоложениеРесурса = Найти(СтрокаАдреса, "://");
	Если Индекс > 0 Тогда
		Адрес.scheme = НРег(Лев(СтрокаАдреса, Индекс - 1));
		СтрокаАдреса = Сред(СтрокаАдреса, Индекс + 3);
	Иначе
		Адрес.scheme = НРег(ПротоколПоУмолчанию);
	КонецЕсли;
	Индекс = Найти(СтрокаАдреса, "?");
	Если Индекс > 0 Тогда
		ПараметрыРесурса = Сред(СтрокаАдреса, Индекс );
		СтрокаАдреса = Сред(СтрокаАдреса, 0, Индекс-1);
	Иначе
		ПараметрыРесурса = "";
	КонецЕсли;

	Индекс = Найти(СтрокаАдреса, "/");
	Если Индекс > 0 Тогда
		Адрес.resource = Сред(СтрокаАдреса, Индекс) + ПараметрыРесурса;
		СтрокаАдреса = Сред(СтрокаАдреса, 0, Индекс - 1);
	Иначе
		Адрес.resource = ПараметрыРесурса;
	КонецЕсли;
	
	Индекс = Найти(СтрокаАдреса, ":");
	Если Индекс > 0 Тогда
		Адрес.port = Сред(СтрокаАдреса, Индекс + 1);
		Адрес.host = Лев(СтрокаАдреса, Индекс);
	Иначе
		Адрес.host = СтрокаАдреса;
	КонецЕсли;
	Возврат Адрес;
КонецФункции

//post запрос
//Для 8.2 тут будет падать. Заменить через вычислить
//Начиная с 8.3 HTTPСоединение возвращает ответ сразу, а не кладёт в файл, появляется объект HTTPЗапрос
//Начиная с 8.2.16 появляется ЗащищенноеСоединениеOpenSSL

//Дополняет заголовки сессией
//context - Структура
//headers - Соответствие
Функция local_helper_add_auth_header(context_params, headers)
	Перем session;
	Если Не context_params.Свойство("session", session) Тогда
		session = "";
	КонецЕсли;
	headers.Вставить("X-SBISSessionID", session);
	
КонецФункции

Функция local_helper_read_document(context_params, document) Экспорт
	Попытка
		Результат	=	local_helper_api(context_params, "СБИС.ПрочитатьДокумент",
		Новый Структура("Документ", document));
	Исключение
		ИнфоОбОшибке = ИнформацияОбОшибке();
		//TODO проверка на отсутствуие документа
		parentStruct = ExtExceptionAnalyse(ИнфоОбОшибке);
		Если ( Найти(parentStruct.message, "Ошибка API") > 0) и (Истина) Тогда
			//Если не найден документ //NotFound
			ВызватьИсключение NewExtExceptionСтрока(ИнфоОбОшибке,,,,,"NotFound");
		КонецЕсли;
		ВызватьИсключение NewExtExceptionСтрока(ИнфоОбОшибке);
	КонецПопытки;
	Возврат Результат;
КонецФункции

Функция local_helper_get_server_datetime(context_params) Экспорт
	Результат	=	local_helper_api(context_params, "СБИС.ИнформацияОВерсии", 
	Новый Структура("Параметр", Новый Структура()) 
	);
	Возврат Результат["ВнешнийИнтерфейс"]["ДатаВремяЗапроса"];
КонецФункции

Функция local_helper_read_changes(context, _filter)
	Результат	=	local_helper_api(context, "СБИС.СписокИзменений", 
	Новый Структура("Фильтр", _filter)
	);
	Возврат Результат;
КонецФункции

Функция local_helper_download_from_link(context_params, link)
	headers = Новый Соответствие;
	local_helper_add_auth_header(context_params, headers);
	
	Пока Истина Цикл
		response = local_helper_exec_request("get", link, "binary", Новый Структура("headers", headers) );
		Если response["code"] <> 200 Тогда
			Попытка 
				КодОшибки = response["result"]["error"]["data"]["classid"];
			Исключение
				КодОшибки = Неопределено;
			КонецПопытки;
			Если КодОшибки = "{00000000-0000-0000-0000-1aa0000f1002}" Тогда
				local_helper_pause(1);
				Продолжить;
			КонецЕсли;
			Попытка
				message = response["result"]["error"]["message"];
				detail = response["result"]["error"]["message"];
				Если message = detail Тогда
					detail = Неопределено;
				КонецЕсли;
			Исключение
				message = ЗначениеВСтрокуВнутр(response["result"]);
				detail = Неопределено;
			КонецПопытки;
			ВызватьИсключение NewExtExceptionСтрока(,message,detail);
		КонецЕсли;
		Прервать;
	КонецЦикла;		
	Возврат response["result"];
КонецФункции

Функция local_helper_extsyncobj_list(context_params, extsyncdoc_uuid, extra_fields, filter, sorting, pagination)
	Результат = local_helper_exec_method(
		context_params,
		Новый Структура("url, method, params, auto_auth",
			context_params.api_url+"/integration_config/service/",
			"ExtSyncObj.List",
			Новый Структура("ExtraFields,Filter,Sorting,Pagination",
				extra_fields,
		        filter,
		        sorting,
		        pagination
			),
			Ложь,
		)
	);
	Возврат Результат;
КонецФункции

Процедура local_helper_pause(Секунды)
	Если Секунды<> 0 Тогда

        НастройкиProxy = Новый ИнтернетПрокси(Ложь);
        НастройкиProxy.НеИспользоватьПроксиДляЛокальныхАдресов = Истина;
        НастройкиProxy.НеИспользоватьПроксиДляАдресов.Добавить("127.0.0.0");

        Попытка
            СоединениеHTTP = Новый HTTPСоединение("127.0.0.0",,,,НастройкиProxy,Секунды);
            СоединениеHTTP.Получить(Новый HTTPЗапрос());
        Исключение
            Возврат;
        КонецПопытки;

    КонецЕсли;
	
КонецПроцедуры	

//Передача ошибок и статуса выполнения на сервер статистик
Процедура local_helper_write_stat(context_params = Неопределено, action_name, action_param, КоличествоОбъектов = 0) Экспорт
	Если context_params = Неопределено Тогда
		context_params = НастройкиПодключенияПрочитать();
	КонецЕсли;
	
	Попытка
         ПараметрыМетода = Новый Структура("stat", 
         Новый Структура("service, module, subsystem, action_name, action_param, connection_id, count",
            context_params.service,
            ПолучитьНазваниеПродукта(),
            context_params.subsystem,
            action_name,
            action_param,
            context_params.ConnectionId,
            КоличествоОбъектов
        	)
        );
        
        РезультатПередачи = local_helper_exec_method(
		context_params,
		Новый Структура("url, method, params, auto_auth",
			context_params.api_url+"/integration_config/service/",
			"API3.WriteStat",
			ПараметрыМетода,
			Ложь,
			)
		);	
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
	КонецПопытки;
         
КонецПроцедуры

Процедура local_helper_write_error(context_params = Неопределено, action_name, action_param, error_name, error_detail, data, code, КоличествоОбъектов = 0) Экспорт
	Если context_params = Неопределено Тогда
		context_params = НастройкиПодключенияПрочитать();
	КонецЕсли;
	
	Попытка
         ПараметрыМетода = Новый Структура("error",
         Новый Структура("service, module, subsystem, action_name, action_param, error_name, error_detail, data, code, count",
            context_params.service,
            ПолучитьНазваниеПродукта(),
            context_params.subsystem,
            action_name,
            action_param,
            error_name,
            error_detail,
            data,
            code,
            КоличествоОбъектов
        	)
        );
		РезультатПередачи = local_helper_exec_method(
		context_params,
		Новый Структура("url, method, params, auto_auth",
			context_params.api_url+"/integration_config/service/",
			"API3.WriteError",
			ПараметрыМетода,
			Ложь,
			)
		);	
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
	КонецПопытки;
         
КонецПроцедуры

