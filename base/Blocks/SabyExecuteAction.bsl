
//DynamicDirective

Процедура block_saby_execute_action_write_esoaction(Begin, End, Title, Subtitle = "", Data = Неопределено, Object = Неопределено, Status = 0) 
	_action = Новый Структура("Begin, End, Title", Begin, End, Title);
	Если Не Data = Неопределено Тогда
		_action.Вставить("Data", Data);
	КонецЕсли;	
	action = fill_action(_action, Status, Subtitle);
	Если Не Object = Неопределено Тогда
		actions = Новый Массив();
		actions.Добавить(action); 
		object.Вставить("Actions", actions);	
		report_add_objects(object);
			
	Иначе
		report_add_actions(action);
	КонецЕсли;			
КонецПроцедуры

//DynamicDirective

Процедура block_saby_execute_action_write_esoaction_on_obj(Begin, End, Title, Subtitle = "", Data = Неопределено, Object = Неопределено, Status = 0) 
	_action = Новый Структура("Begin, End, Title", Begin, End, Title);
	Если Не Data = Неопределено Тогда
		_action.Вставить("Data", Data);
	КонецЕсли;	
	action = fill_action(_action, Status, Subtitle);
	Если Не Object = Неопределено Тогда
		object["Actions"].Добавить(action); 			
	Иначе
		report_add_actions(action);
	КонецЕсли;			
КонецПроцедуры

// Функция block_saby_execute_action_calc_value
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
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS-off
// BSLLS:CognitiveComplexity-off
//DynamicDirective
Функция block_saby_execute_action_calc_value(block_type, node, path, context, block_context)
	begin = ДатаВМиллисекундах();
	
	doc = block_context["DOCUMENT"];
	doc_performer = get_prop(block_context, "PERFORMER", Новый Массив);
		
	easy_send = workspace_find_mutation_by_name(node, "EASY_SEND"); 
	send_type = workspace_find_mutation_by_name(node, "SEND_TYPE");
			
	stage = ?(ТипЗнч(doc["Этап"]) = Тип("Массив"), doc["Этап"][0], doc["Этап"]);
	Если stage = Неопределено и send_type <> "MAGIC_BUTTON"  Тогда
		//Подразумевается, что документ перешёл сразу в фазу завершено, и у него нет действий
		Возврат doc;
	КонецЕсли;
	
	object = get_prop(block_context, "object"); 
	ПервичныйКлюч = get_prop(doc, "ПервичныйКлюч");
	Если object = Неопределено И ПервичныйКлюч <> Неопределено Тогда
		SbisType = ТипОбъектаАПИПоТипуСБИС(doc["Тип"], doc["Примечание"], doc["Идентификатор"], context.params);
		object = Новый Структура("SbisType, SbisId, Actions", SbisType, ПервичныйКлюч, Новый Массив);
		block_context.Вставить("object", object);
	КонецЕсли;	
	
	Если get_prop(block_context, "_prepare_result") = Неопределено Тогда 
		begin = ДатаВМиллисекундах();
		Title = "API запись вложений";
		attachments = block_saby_execute_action_write_attachment(node, path, context, block_context); //TODO
		doc1 = Новый Соответствие;
		ВставитьСвойствоЕслиНет(doc1, "Идентификатор", doc["Идентификатор"]);
		ВставитьСвойствоЕслиНет(doc1, "Этап", stage);
		attachments_count = attachments.Количество();
		Если attachments_count > 0 Тогда
			ВставитьСвойствоЕслиНет(doc1, "Вложение", attachments);
			Попытка
				ДокДляВложений = Новый Соответствие;
				ДокДляВложений["Идентификатор"] = doc1["Идентификатор"];
				ДокДляВложений["Вложение"] = doc1["Вложение"];
				ТранспортИнтеграции.local_helper_write_attachment(context.params, ДокДляВложений);
			Исключение   
				ИнфОбОшибке = ОписаниеОшибки(); 
				ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке,,,"execute_action");
				Data = Новый Структура;
				Data.Вставить("message", get_prop(ОшибкаСтруктура, "message"));
				Data.Вставить("detail", get_prop(ОшибкаСтруктура, "detail"));
				end = ДатаВМиллисекундах();
				block_saby_execute_action_write_esoaction_on_obj(begin, end, Title, "", Data, object, 100);
				Если object <> Неопределено Тогда
					report_add_objects(object); 
				КонецЕсли;	
				Возврат ИнфОбОшибке;				
			КонецПопытки;
			Data = Новый Структура;
			Data.Вставить("message", "Записано " + Строка(attachments_count) + " вложений");
			end = ДатаВМиллисекундах();
			block_saby_execute_action_write_esoaction_on_obj(begin, end, Title, "", Data, object);		
		КонецЕсли;
	КонецЕсли;
			
	Если easy_send = "TRUE" Тогда
		action_name = "ПростоОтправить";
	ИначеЕсли send_type = "MAGIC_BUTTON" Тогда
		Если doc["Вложение"] = Неопределено или doc["Вложение"].Количество() = 0 Тогда
			ВызватьИсключение NewExtExceptionСтрока(,"Отсутствуют вложения. "+ doc["Название"], "execute_action");	
		КонецЕсли;
		Если doc_performer.Количество() = 0 Тогда
			ВызватьИсключение NewExtExceptionСтрока(,"Не выбраны сотрудники для подписания или отсутствуют в "+ЛокализацияНазваниеПродукта()+". "+ doc["Название"], "execute_action");	
		КонецЕсли;
		Возврат block_saby_execute_action_magic_button(context.params, doc, doc["Вложение"], doc_performer);	
	Иначе
		action_name = get_prop(block_context, "ACTION", "");
	КонецЕсли;
	
	ВидТранспорта = ВидТранспорта(context.params);
	Если get_prop(block_context, "_prepare_result") = Неопределено Тогда
		//Ищем действие соответсвующее команде
		action = Неопределено;
		Для Каждого Действие из get_prop(stage, "Действие", Новый Массив) Цикл
			Если Действие["Название"] = action_name Тогда
				action = Действие;
				Прервать;
			КонецЕсли;
		КонецЦикла; 
		Если action = Неопределено Тогда
			ИнфОбОшибке = "Отсутствует действие " + action_name + ". Документ " + doc["Название"];
			ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке,,,"execute_action");
			ВызватьИсключение ОшибкаСтруктура;		
		КонецЕсли;

			
		Если Не (ВидТранспорта = "ExtSdk2" Или ВидТранспорта = "SabyPluginConnector") Тогда 
			ВставитьСвойствоЕслиНет(stage, "Действие", Новый Соответствие);
			ВставитьСвойствоЕслиНет(stage["Действие"], "Название", action_name);
			ВставитьСвойствоЕслиНет(stage["Действие"], "Комментарий", get_prop(block_context,"COMMENT", ""));
			block_context.Вставить("ДанныеДляПодписания", сбисОпределитьДанныеДляПодписания(Неопределено, doc, action));
			Если block_context.ДанныеДляПодписания.Свойство("СертификатДок") и block_context.ДанныеДляПодписания.СертификатДок <> Неопределено Тогда
				ВставитьСвойствоЕслиНет(stage["Действие"], "Сертификат", block_context.ДанныеДляПодписания.СертификатДок);
			КонецЕсли;
			Если ЗначениеЗаполнено(block_context.ДанныеДляПодписания) и block_context.ДанныеДляПодписания.Тип = "Простое" Тогда 
				stage["Действие"].Вставить("ТипПодписи", "Отсоединенная");	
			КонецЕсли;	
		Иначе
			stage.Вставить("Действие", action);
			ВставитьСвойствоЕслиНет(stage["Действие"], "Комментарий", get_prop(block_context,"COMMENT", ""));
		КонецЕсли;
		Если easy_send = "TRUE" Тогда
			stage["Действие"]["Название"] = "ПростоОтправить";
			stage["Название"] = "ПростаяОтправка";
		КонецЕсли;	
	КонецЕсли;

	block_context.Вставить("action_name", action_name);
	block_context.Вставить("stage", stage); 
	block_context.Вставить("easy_send", easy_send); 
	block_context.Вставить("send_type", send_type); 
	block_context.Вставить("doc1", doc1);
	block_context.Вставить("object", object);
	Если ВидТранспорта = "ExtSdk2" Или ВидТранспорта = "SabyPluginConnector" Тогда
		Если get_prop(doc, "НашаОрганизация") <> Неопределено Тогда
			ВставитьСвойствоЕслиНет(doc1, "НашаОрганизация", doc["НашаОрганизация"]);	
		КонецЕсли; 
		Если doc_performer.Количество() > 0 Тогда
			ЗаполнитьИсполнителей(doc1, doc_performer);
		КонецЕсли;
		block_context.Вставить("doc1", doc1);
		Результат = ТранспортИнтеграции.local_helper_execute_action_ex(block_context, context);
	Иначе
		Результат = block_saby_execute_action_continue(block_context, context);
	КонецЕсли;	
	Возврат Результат;		
КонецФункции
// BSLLS-on
// BSLLS:CognitiveComplexity-on

// Функция block_saby_execute_action_magic_button
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// doc - Соответствие - Документ
// doc_attach - Соответствие - Вложения
// doc_performer - Соответствие - Исполнитель
//
// Возвращаемое значение:
//  Неопределено - Результат выполения функции
//
// BSLLS:CognitiveComplexity-off
//DynamicDirective
Функция block_saby_execute_action_magic_button(context, doc, doc_attach, doc_performer)
	мСотрудники = Новый Массив;
	мРуководители = Новый Массив;
	мВложения = Новый Массив;
	
	МассивОшибок	= Новый Массив;
	МассивУспехов	= Новый Массив;
	НаименованиеДействия = "EdoAction/MagicButton";
	КонтекстДействия = doc["Тип"];

	Для каждого Сотрудника Из doc_performer Цикл
		Если Сотрудника["Роль"] = "Руководитель" Тогда
			мРуководители.Добавить(Новый Структура("PersonnelNumber", Сотрудника["ТабельныйНомер"]));	
		Иначе
			Если Сотрудника["Роль"] = "Сотрудник" Тогда	 
				Если doc["КаналИнформации"] = "0" Тогда
					мСотрудники.Добавить(Новый Структура("PersonnelNumber, Contact", Сотрудника["ТабельныйНомер"], Сотрудника["ЭлПочта"])); 
				Иначе	  
					мСотрудники.Добавить(Новый Структура("PersonnelNumber, Contact", Сотрудника["ТабельныйНомер"], Сотрудника["МобильныйТелефон"])); 
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Для каждого Вложения из doc_attach Цикл
		мВложения.Добавить(Новый Структура("ExtId",Вложения["Идентификатор"] ));	
	КонецЦикла;	
	
	Число1 = 1;
	Число2 = 2;
	params = Новый Структура();
	params.Вставить("DocumentExt",	doc["Идентификатор"]);
	params.Вставить("ChannelKind",	Число(doc["КаналИнформации"]));
		// Сюда надо передать тип уведомления 0 - электронная почта, 1 - СМС, 2 - Viber, 3 - WhatsApp, 4 - Telegram
	params.Вставить("Managers",	мРуководители);
		// Массив руководителей
	params.Вставить("Employees",	мСотрудники);
		// Массив сотрудников
	params.Вставить("SignRequirement",	Новый Структура("Managers, Employees", Число1, Число2));
	params.Вставить("Route",	Число(doc["МаршрутОзнакомления"]));
		// Сюда передать Маршрут ознакомления: 0 - одновременно всем, 1 - сначала руководители, 2 - сначала сотрудники
	params.Вставить("Attachments",	мВложения);		                                    
// Переменная нужна для цикла
// BSLLS:UnusedLocalVariable-off
	Для Сч = 0 По 2 Цикл
// BSLLS:UnusedLocalVariable-on		
		Попытка
			result = ТранспортИнтеграции.local_helper_request_signing(context, params);
			Если Сч = 0 Тогда
				ЭлементСтатистики = ТранспортИнтеграции.local_helper_element_action(НаименованиеДействия, КонтекстДействия, Новый Структура(), 1);
				МассивУспехов.Добавить(ЭлементСтатистики);
				ТранспортИнтеграции.local_helper_register_actions(context, МассивУспехов);
			КонецЕсли;
			Возврат result;
		Исключение   
			ИнфОбОшибке = ИнформацияОбОшибке();
			Если Сч = 0 Тогда
				ЭлементСтатистики = ТранспортИнтеграции.local_helper_element_err(НаименованиеДействия, КонтекстДействия, "", "", Новый Структура(), "", 1);
				МассивОшибок.Добавить(ЭлементСтатистики);
				ТранспортИнтеграции.local_helper_register_errors(context, МассивОшибок);
			КонецЕсли;
			ТранспортИнтеграции.local_helper_pause(5);						
		КонецПопытки;
	КонецЦикла;	

	ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,"magic_button");
КонецФункции	
// BSLLS:CognitiveComplexity-on

// Функция block_saby_execute_action_write_attachment
//
// Параметры:
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Массив - Результат выполения функции
//
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS:CognitiveComplexity-off
//DynamicDirective
Функция block_saby_execute_action_write_attachment(node, path, context, block_context)
	attachments = Новый Массив;
        attachment_types = workspace_find_mutation_by_name(node, "attachment_types");
        Если не attachment_types = Неопределено Тогда
            attachment_types = СтрРазделить82(attachment_types,",");
		КонецЕсли;
		att_index = 0;
        Для каждого att_type из attachment_types Цикл
            Если att_type = "att_array" Тогда
                Попытка
                    attachment_array = block_context["ATT"+att_index];
                Исключение
                    Возврат attachments;
				КонецПопытки;	
				Для каждого att из attachment_array Цикл 
					attachments.Добавить(att);
				КонецЦикла;
            Иначе
				Если att_type = "att_b64" Тогда
					Попытка
						attachment_data = block_context["ATT"+att_index+"_DATA"];
					Исключение
						Возврат attachments;
					КонецПопытки;	
					attachment_title = get_prop(block_context, "ATT"+att_index+"_TITLE");
					attachment = Новый Соответствие;
					ВставитьСвойствоЕслиНет(attachment, "Имя", attachment_title);
					ВставитьСвойствоЕслиНет(attachment, "ДвоичныеДанные", attachment_data);
					attachments.Добавить(attachment);
				КонецЕсли;
            КонецЕсли;
		КонецЦикла;
        
		Возврат attachments;
КонецФункции	
// BSLLS:CognitiveComplexity-on

// Функция get_signature
//
// Параметры:
// context_params - Соответствие - Параметры пользователя
// doc1 - Соответствие - Документ
// prepare_result - Массив - Абсолютный путь до исполняемого блока
//
// Возвращаемое значение:
//  Неопределено - Результат выполения функции
//
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS:NestedStatements-off
// BSLLS:CognitiveComplexity-off
//DynamicDirective
Функция get_signature(context_params, doc1, prepare_result)
	Для каждого stage из get_prop(prepare_result, "Этап", Новый Массив) Цикл
		Для каждого action из get_prop(stage, "Действие") Цикл
			Сертификат = get_prop(action, "Сертификат", Новый Массив);
			Если get_prop(action, "ТребуетПодписания") = "Да" И Сертификат.Количество() > 0 Тогда
				Попытка
					sign_array = Новый Массив;
					Для каждого sert из Сертификат Цикл
						Если get_prop(sert, "Квалифицированный") = "Нет" Тогда
							Продолжить;
						КонецЕсли;	
						sign_dict = Новый Структура("signature, file", get_prop(sert, "Отпечаток"), Новый Массив);
						Для каждого attach из get_prop(stage, "Вложение", Новый Массив) Цикл
							sign_dict["file"].Добавить(Новый Структура("Ссылка", attach["Файл"]["Ссылка"]));
						КонецЦикла;	                                                                        
						sign_array.Добавить(sign_dict);
					КонецЦикла;	                                                                            
					operation_uuid = ТранспортИнтеграции.local_helper_init_remote_signing(context.params, sign_array);
				Исключение
// Оставим для отладки
// BSLLS:UnusedLocalVariable-off
					ИнфОбОшибке = ИнформацияОбОшибке();
// BSLLS:UnusedLocalVariable-on	
					Возврат Новый Массив;	
				КонецПопытки;
				Попытка
					Возврат ТранспортИнтеграции.local_helper_get_remote_signature(context.params, operation_uuid);	
				Исключение
// Оставим для отладки
// BSLLS:UnusedLocalVariable-off
					ИнфОбОшибке = ИнформацияОбОшибке();
// BSLLS:UnusedLocalVariable-on	
					Возврат Новый Массив;
				КонецПопытки;	
			КонецЕсли;	
		КонецЦикла;	
	КонецЦикла;	
КонецФункции
// BSLLS:CognitiveComplexity-on	
// BSLLS:NestedStatements-on

// Функция ЗаполнитьИсполнителей
//
// Параметры:
// execute_action - Соответствие - Выполняемое действие
// doc_performer - Соответствие - Исполнитель
//
//DynamicDirective
Процедура ЗаполнитьИсполнителей(execute_action, doc_performer)
	мИсполнитель = Новый Массив;
	Для каждого Исполнителя из doc_performer Цикл
		мФИО = СтрРазделить82(Исполнителя," ");
		Пока мФИО.Количество() < 3 Цикл
			мФИО.Добавить("");
		КонецЦикла;	
		мИсполнитель.Добавить(Новый Структура("Сотрудник", 
			Новый Структура("Фамилия, Имя, Отчество",
				мФИО[0],
				мФИО[1],
				мФИО[2])));
	КонецЦикла;	
	Этап = get_prop(execute_action, "Этап"); 
	Если Этап <> Неопределено Тогда
		Действие = get_prop(Этап, "Действие", Новый Массив);
		Если Действие.Количество() > 0 Тогда
			ПервоеДействие = Действие[0];
			ПервоеДействие.Вставить("СледующийЭтап", Новый Массив);
			СледующийЭтап = ПервоеДействие["СледующийЭтап"];
			СледующийЭтап.Добавить(Новый Структура("Исполнитель", мИсполнитель));
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры	

// BSLLS:CognitiveComplexity-off	
//DynamicDirective

Функция block_saby_execute_action_fill_stage(block_context, context)
	ЧистыйЭтап = Новый Соответствие;
	Если block_context.ДанныеДляПодписания.Свойство("СертификатДляПодписания") И ЗначениеЗаполнено(block_context.ДанныеДляПодписания.СертификатДляПодписания) 
		И get_prop(block_context.execute_action_param["Этап"], "Вложение") <> Неопределено Тогда  
		object = get_prop(block_context, "object");
		Попытка
			begin = get_prop(block_context, "begin_signatures", ДатаВМиллисекундах());
			Если ТипЗнч(block_context) = Тип("Структура") Тогда 
				block_context.Вставить("begin_signatures", begin);
				block_context.Вставить("Title_signatures", "Подписание в ИС");
			КонецЕсли;
	   		get_signatures(context, block_context.execute_action_param, block_context.ДанныеДляПодписания, block_context);
		Исключение   
			ИнфОбОшибке = ИнформацияОбОшибке();
			ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
			Если ЭтоСлужебнаяОшибкаБлока(ОшибкаСтруктура.type) Тогда
				ВызватьИсключение ИнфОбОшибке.Описание; // (исходное исключение)
			КонецЕсли;
			end = ДатаВМиллисекундах(); 
			Data = Новый Структура;
			Data.Вставить("message", "Не удалось подписать файл");
			Data.Вставить("detail", get_prop(ОшибкаСтруктура, "message", "") + " " + get_prop(ОшибкаСтруктура, "detail", ""));
			block_saby_execute_action_write_esoaction_on_obj(begin, end, get_prop(block_context, "Title_signatures"), "", Data, object, 100);
			Если object <> Неопределено Тогда
				report_add_objects(object); 
			КонецЕсли;
			ВызватьИсключение ИнфОбОшибке.Описание; // (исходное исключение)	
		КонецПопытки;	
		ЧистыйЭтап.Вставить("Вложение", block_context.execute_action_param["Этап"]["Вложение"]); 
		КоличествоВложений = get_prop(block_context.execute_action_param["Этап"], "Вложение").Количество(); 
		Data = Новый Структура;  
		Data.Вставить("message", "Подписано " + Строка(КоличествоВложений) + " вложений");
		end = ДатаВМиллисекундах();
		block_saby_execute_action_write_esoaction_on_obj(begin, end, get_prop(block_context, "Title_signatures"), "", Data, object);
		object = get_prop(block_context, "object");
			
	КонецЕсли;
	
	ЧистыйЭтап.Вставить("Название", block_context.execute_action_param["Этап"]["Название"]);
	ЧистыйЭтап.Вставить("Действие", Новый Массив);
	ЧистыйЭтап["Действие"].Добавить(Новый Соответствие);
	ЧистыйЭтап["Действие"][0].Вставить("Название", block_context.execute_action_param["Этап"]["Действие"][0]["Название"]);
	ЧистыйЭтап["Действие"][0].Вставить("Комментарий", block_context.execute_action_param["Этап"]["Действие"][0]["Комментарий"]);
	Если ЗначениеЗаполнено(block_context.ДанныеДляПодписания) Тогда
		Если block_context.ДанныеДляПодписания.Свойство("СертификатДок") и block_context.ДанныеДляПодписания.СертификатДок <> Неопределено Тогда
			ЧистыйЭтап["Действие"][0].Вставить("Сертификат", block_context.ДанныеДляПодписания.СертификатДок);
		КонецЕсли;	
		Если block_context.ДанныеДляПодписания.Тип = "Простое" Тогда
			block_context.execute_action_param.Вставить("ДопПоля", "ПростаяПодписьНаСервере");
			ЧистыйЭтап["Действие"][0].Вставить("ТипПодписи", "Отсоединенная");
		КонецЕсли;
	КонецЕсли;	
	Возврат ЧистыйЭтап;
КонецФункции


// Функция block_saby_execute_action_continue
//
// Параметры:
// block_context - Соответствие - Контекст текущего выполняемого блока
// context - Соответствие - Контекст исполняемого блока
//
// Возвращаемое значение:
//  Соответствие - Результат выполения функции
//
//DynamicDirective
Функция block_saby_execute_action_continue(block_context, context) Экспорт 
// Оставим для отладки
// BSLLS:UnusedLocalVariable-off
	action_name = get_prop(block_context, "action_name", "");
	stage = get_prop(block_context, "stage", "");
	easy_send = get_prop(block_context, "easy_send", "");
	send_type = get_prop(block_context, "send_type", "");
	doc = get_prop(block_context, "DOCUMENT", "");
// BSLLS:UnusedLocalVariable-on	
	doc1 = get_prop(block_context, "doc1", "");
	doc_performer = get_prop(block_context, "PERFORMER", Новый Массив);
	object = get_prop(block_context, "object");
	Subtitle = get_prop(stage, "Название", "") + ", " + action_name;
	Если get_prop(block_context, "_prepare_result") = Неопределено Тогда 
		Title = "API подготовка действия";
		begin = ДатаВМиллисекундах();
		Попытка
			block_context.Вставить("_prepare_result", ТранспортИнтеграции.local_helper_prepare_action(context.params, doc1));
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();
			ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
			Если ЭтоСлужебнаяОшибкаБлока(ОшибкаСтруктура.type) Тогда
				ВызватьИсключение ИнфОбОшибке.Описание; // (исходное исключение)
			КонецЕсли;
          	Data = Новый Структура;
			Data.Вставить("message", get_prop(ОшибкаСтруктура, "message"));
			Data.Вставить("detail", get_prop(ОшибкаСтруктура, "detail"));
			end = ДатаВМиллисекундах();  
			block_saby_execute_action_write_esoaction_on_obj(begin, end, Title, Subtitle, Data, object, 100);
			Если object <> Неопределено Тогда
				report_add_objects(object); 
			КонецЕсли;
			Возврат ОшибкаСтруктура;
		КонецПопытки;
		
		block_context.Вставить("execute_action_param", Новый Соответствие);
		ВставитьСвойствоЕслиНет(block_context.execute_action_param, "Идентификатор", get_prop(block_context._prepare_result,"Идентификатор")); 
		prepared_stage = get_prop(block_context._prepare_result,"Этап");
		block_context.execute_action_param.Вставить("Этап", prepared_stage[0]);	
		end = ДатаВМиллисекундах();
		block_saby_execute_action_write_esoaction_on_obj(begin, end, Title, Subtitle, Data, object);		
	КонецЕсли;	
		
	Попытка    
		block_context.Вставить("object", object);
		ЧистыйЭтап = block_saby_execute_action_fill_stage(block_context, context);
		object = get_prop(block_context, "object");
		begin = ДатаВМиллисекундах();
		Title = "API выполнение действия";
		block_context.execute_action_param["Этап"] = ЧистыйЭтап;
		
		Если doc_performer.Количество() > 0 Тогда
			ЗаполнитьИсполнителей(block_context.execute_action_param, doc_performer);
		КонецЕсли;
  		
		Результат = ТранспортИнтеграции.local_helper_execute_action(context.params, block_context.execute_action_param); 
		end = ДатаВМиллисекундах();
		
		block_saby_execute_action_write_esoaction_on_obj(begin, end, Title, Subtitle, , object);
		Если object <> Неопределено Тогда
			report_add_objects(object); 
		КонецЕсли;
	Исключение
		
		ИнфОбОшибке = ИнформацияОбОшибке();
		ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
		Если ЭтоСлужебнаяОшибкаБлока(ОшибкаСтруктура.type) Тогда
			ВызватьИсключение ИнфОбОшибке.Описание; // (исходное исключение)
		КонецЕсли;
		Если begin <> Неопределено Тогда
			Data = Новый Структура;
			Data.Вставить("message", get_prop(ОшибкаСтруктура, "message"));
			Data.Вставить("detail", get_prop(ОшибкаСтруктура, "detail"));
			
			block_saby_execute_action_write_esoaction_on_obj(begin, end, Title, Subtitle, Data, object, 100); 
			Если object <> Неопределено Тогда
				report_add_objects(object); 
			КонецЕсли;
		КонецЕсли;	
		Возврат ОшибкаСтруктура;
		
	КонецПопытки;
	Возврат Результат;
КонецФункции
// BSLLS:CognitiveComplexity-on	
