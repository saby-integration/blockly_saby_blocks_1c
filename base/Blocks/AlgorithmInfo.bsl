
// Функция ДобавитьПараметрБлока
//
// Параметры:
// Ключи - Массив - Ключи параметра
// Значение - Произвольный - Значение ключа
// ПараметрыАлгоритма - Соответствие - Параметры алгоритма
//
//DynamicDirective
Процедура ДобавитьПараметрБлока(Ключи, Значение, ПараметрыАлгоритма)
	Если ТипЗнч(Ключи) = Тип("Массив") и Ключи.Количество() = 2 Тогда
		Если ПараметрыАлгоритма.Свойство(Ключи[0]) И ТипЗнч(ПараметрыАлгоритма[Ключи[0]]) = Тип("Соответствие") Тогда
			ПараметрыАлгоритма[Ключи[0]][Нрег(Строка(Ключи[1]))] = Значение
		Иначе	
		 	ПараметрыАлгоритма.Вставить(Ключи[0], Новый Соответствие);
			ДобавитьПараметрБлока(Ключи, Значение, ПараметрыАлгоритма);
		КонецЕсли;
	КонецЕсли;		
КонецПроцедуры

//DynamicDirective

Функция algorithm_info_ВнешниеСерверыFTP()
	ВнешнийСерверFTP = Новый Массив; 
	ftp_login = Новый Соответствие;
	ftp_login.Вставить("name", "ftp_login");
	ftp_login.Вставить("title", "Логин");
	ftp_login.Вставить("default", "usr");
	ftp_login.Вставить("type", "Строка");
	ftp_login.Вставить("description", Неопределено);

	ftp_passive = Новый Соответствие;
	ftp_passive.Вставить("name", "ftp_passive");
	ftp_passive.Вставить("title", "Пассивный режим");
	ftp_passive.Вставить("default", Истина);
	ftp_passive.Вставить("type", "Булево");
	ftp_passive.Вставить("description", Неопределено);
	
	ftp_password = Новый Соответствие;
	ftp_password.Вставить("name", "ftp_password");
	ftp_password.Вставить("title", "Пароль");
	ftp_password.Вставить("default", "pwd");
	ftp_password.Вставить("type", "Строка");
	ftp_password.Вставить("description", Неопределено);

    ftp_port = Новый Соответствие;
	ftp_port.Вставить("name", "ftp_port");
	ftp_port.Вставить("title", "Порт");
	ftp_port.Вставить("default", 21);
	ftp_port.Вставить("type", "Число");
	ftp_port.Вставить("description", Неопределено);
	
	ftp_server = Новый Соответствие;
	ftp_server.Вставить("name", "ftp_server");
	ftp_server.Вставить("title", "Сервер");
	ftp_server.Вставить("default", "ftp://127.0.0.1");
	ftp_server.Вставить("type", "Строка");
	ftp_server.Вставить("description", Неопределено);
 	
	ВнешнийСерверFTP.Добавить(ftp_login);	
	ВнешнийСерверFTP.Добавить(ftp_password);	
	ВнешнийСерверFTP.Добавить(ftp_passive);	
	ВнешнийСерверFTP.Добавить(ftp_port);	
	ВнешнийСерверFTP.Добавить(ftp_server);
	Возврат ВнешнийСерверFTP;
КонецФункции

//DynamicDirective 

Функция algorithm_info_ВнешниеСерверыSMTP()
	ВнешнийСерверSMTP = Новый Массив; 
	smtp_login = Новый Соответствие;
	smtp_login.Вставить("name", "smtp_login");
	smtp_login.Вставить("title", "Логин");
	smtp_login.Вставить("default", "usr");
	smtp_login.Вставить("type", "Строка");
	smtp_login.Вставить("description", Неопределено);

	smtp_password = Новый Соответствие;
	smtp_password.Вставить("name", "smtp_password");
	smtp_password.Вставить("title", "Пароль");
	smtp_password.Вставить("default", "pwd");
	smtp_password.Вставить("type", "Строка");
	smtp_password.Вставить("description", Неопределено);

    smtp_port = Новый Соответствие;
	smtp_port.Вставить("name", "smtp_port");
	smtp_port.Вставить("title", "Порт");
	smtp_port.Вставить("default", 465);
	smtp_port.Вставить("type", "Число");
	smtp_port.Вставить("description", Неопределено);
	
	smtp_server = Новый Соответствие;
	smtp_server.Вставить("name", "smtp_server");
	smtp_server.Вставить("title", "Сервер");
	smtp_server.Вставить("default", "smtp.com");
	smtp_server.Вставить("type", "Строка");
	smtp_server.Вставить("description", Неопределено);
 	
	ВнешнийСерверSMTP.Добавить(smtp_login);	
	ВнешнийСерверSMTP.Добавить(smtp_password);	
	ВнешнийСерверSMTP.Добавить(smtp_port);	
	ВнешнийСерверSMTP.Добавить(smtp_server);	
	Возврат ВнешнийСерверSMTP;
КонецФункции

//DynamicDirective 

Функция algorithm_info_ВнешниеСерверыHTTP()
	ВнешнийСерверHTTP = Новый Массив; 
	http_url = Новый Соответствие;
	http_url.Вставить("name", "http_url");
	http_url.Вставить("title", "Адрес");
	http_url.Вставить("default", "https://online.sbis.ru/");
	http_url.Вставить("type", "Строка");
	http_url.Вставить("description", Неопределено);
	
	ВнешнийСерверHTTP.Добавить(http_url);	
	
	Возврат ВнешнийСерверHTTP;
КонецФункции

//DynamicDirective

Функция algorithm_info_ВнешниеСерверы() 
	ВнешниеСерверы = Новый Соответствие;
	ВнешниеСерверы.Вставить("FTP", algorithm_info_ВнешниеСерверыFTP());
	ВнешниеСерверы.Вставить("SMTP", algorithm_info_ВнешниеСерверыSMTP());
	ВнешниеСерверы.Вставить("HTTP", algorithm_info_ВнешниеСерверыHTTP());
	Возврат ВнешниеСерверы;	
КонецФункции

//DynamicDirective

Функция algorithm_info_МеткиБрокера() Экспорт
	МеткиБрокера = Новый Соответствие; 

	// *********************** LastEventEdo *********************
	LastEventEdo = Новый Соответствие;
	LastEventEdo.Вставить("name", "LastEventEdo");
	LastEventEdo.Вставить("title", "Последнее событие ЭДО");
	// BSLLS:DeprecatedCurrentDate-off Использование на клиенте
	LastEventEdo.Вставить("default", Неопределено);
	// BSLLS:DeprecatedCurrentDate-on
	LastEventEdo.Вставить("type", "datetime");
	LastEventEdo.Вставить("description", Неопределено);
	
	МеткиБрокера.Вставить("LastEventEdo", LastEventEdo);

	// *********************** BrokerMarkTaxmon *********************
	BrokerMarkTaxmon = Новый Соответствие;
	BrokerMarkTaxmon.Вставить("name", "BrokerMarkTaxmon");
	BrokerMarkTaxmon.Вставить("title", "Последнее событие Налоговый мониторинг");
	// BSLLS:DeprecatedCurrentDate-off Использование на клиенте
	BrokerMarkTaxmon.Вставить("default", Неопределено);
	// BSLLS:DeprecatedCurrentDate-on
	BrokerMarkTaxmon.Вставить("type", "datetime");
	BrokerMarkTaxmon.Вставить("description", Неопределено);
	
	МеткиБрокера.Вставить("BrokerMarkTaxmon", BrokerMarkTaxmon);
	
	// *********************** BrokerMark *********************
	BrokerMark = Новый Соответствие;
	BrokerMark.Вставить("name", "BrokerMark");
	BrokerMark.Вставить("title", "Последнее событие ИС");
	// BSLLS:DeprecatedCurrentDate-off Использование на клиенте
	BrokerMark.Вставить("default", Неопределено);
	// BSLLS:DeprecatedCurrentDate-on
	BrokerMark.Вставить("type", "datetime");
	BrokerMark.Вставить("description", Неопределено);
	
	МеткиБрокера.Вставить("BrokerMark", BrokerMark);
	
	// *********************** BrokerMarkSaby *********************
	BrokerMarkSaby = Новый Соответствие;
	BrokerMarkSaby.Вставить("name", "BrokerMarkSaby");
	BrokerMarkSaby.Вставить("title", "Последнее событие Saby");
	// BSLLS:DeprecatedCurrentDate-off Использование на клиенте
	BrokerMarkSaby.Вставить("default", Неопределено);
	// BSLLS:DeprecatedCurrentDate-on
	BrokerMarkSaby.Вставить("type", "datetime");
	BrokerMarkSaby.Вставить("description", Неопределено);
	
	МеткиБрокера.Вставить("BrokerMarkSaby", BrokerMarkSaby);
	
	Возврат МеткиБрокера;	
КонецФункции

// функция block_algorithm_info_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Соответствие - Результат успешного выполения функции
//
//DynamicDirective
Функция block_algorithm_info_calc_value(block_type, node, path, context, block_context)
	ТипыПараметров = Новый Соответствие();
	ТипыПараметров.Вставить("algorithm_info_param_string",	"Строка");	
	ТипыПараметров.Вставить("algorithm_info_param_number",	"Число");	
	ТипыПараметров.Вставить("algorithm_info_param_boolean",	"Булево");	
	
	ВнешниеСерверы = algorithm_info_ВнешниеСерверы();	
	МеткиБрокера = algorithm_info_МеткиБрокера();	
	
	Результат = Новый Соответствие;
	Результат.Вставить("params", Новый Массив);
	Отступ1 = 1;
	Отступ5 = 5;
	Для Каждого Параметр Из block_context Цикл
		Ключ = Параметр.Ключ;
		Если Лев(Ключ, Отступ1) = "_" Или Лев(Ключ, Отступ5) = "PARAM" Тогда  
			Продолжить;
		Иначе
			Результат.Вставить(Ключ, Параметр.Значение);	
		КонецЕсли;
	КонецЦикла;
	
	ТипыПеременных = workspace_find_mutation_by_name(node, "items_types"); 
	ТипыПараметровАлгоритма = Saby_СтрРазделить82(ТипыПеременных, ",");	
	КоличествоПараметров = Число(workspace_find_mutation_by_name(node, "items", 0));
	СтрокаPARAM = "PARAM"; 
	Для Счетчик = 0 По КоличествоПараметров Цикл
		СчетчикСтрокой = Формат(Счетчик, "ЧН=0; ЧГ="); 
		ИмяПараметра = СтрокаPARAM + СчетчикСтрокой + "_NAME";
		Ключ = get_prop(block_context, ИмяПараметра);
		Если Ключ = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ВнешнийСервер = get_prop(ВнешниеСерверы, Ключ); 
		МеткаБрокера = get_prop(МеткиБрокера, Ключ); 
		Если ВнешнийСервер <> Неопределено Тогда    
			ИнтеграцияДополнитьМассив(Результат["params"], ВнешнийСервер); 
		ИначеЕсли МеткаБрокера <> Неопределено Тогда
			Результат["params"].Добавить(МеткаБрокера);
		Иначе
			Param = Новый Соответствие;
			Param.Вставить("name", Ключ); 
			Param.Вставить("title", get_prop(block_context, СтрокаPARAM + СчетчикСтрокой + "_TITLE")); 
			Param.Вставить("default", get_prop(block_context, СтрокаPARAM + СчетчикСтрокой + "_DEFAULT")); 
			Param.Вставить("description", get_prop(block_context, СтрокаPARAM + СчетчикСтрокой + "_DESCRIPTION")); 
			Param.Вставить("type", ТипыПараметров.Получить(ТипыПараметровАлгоритма.Получить(Счетчик)));
			Результат["params"].Добавить(Param);
		КонецЕсли;	
	КонецЦикла;	
	
	Объекты = "algorithm_info_param_extsys_objects"; 
	ИндексМассива = ТипыПараметровАлгоритма.Найти(Объекты);
	Если ИндексМассива <> Неопределено Тогда 
		Param = Новый Соответствие;
		Param.Вставить("name", "extsys_objects"); 		
		Результат["params"].Добавить(Param);
		ТипыПараметровАлгоритма.Удалить(ИндексМассива);
	КонецЕсли;
	Возврат Результат;
КонецФункции
