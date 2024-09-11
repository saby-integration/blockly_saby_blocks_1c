Функция block_saby_execute_action_calc_value(block_type, node, path, context, block_context)
	
	doc = block_context["DOCUMENT"];
	doc_performer = get_prop(block_context, "PERFORMER", Новый Массив);
		
	easy_send = workspace_find_mutation_by_name(node, "EASY_SEND"); 
	send_type = workspace_find_mutation_by_name(node, "SEND_TYPE");
	
	stage = ?(ТипЗнч(doc["Этап"]) = Тип("Массив"), doc["Этап"][0], doc["Этап"]);
	Если stage = Неопределено и send_type <> "MAGIC_BUTTON"  Тогда
		//Подразумевается, что документ перешёл сразу в фазу завершено, и у него нет действий
		Возврат doc;
	КонецЕсли;
	
	Если get_prop(block_context, "_prepare_result") = Неопределено Тогда
		attachments = block_saby_execute_action_write_attachment(node, path, context, block_context); //TODO
		doc1 = Новый Соответствие;
		ВставитьСвойствоЕслиНет(doc1, "Идентификатор", doc["Идентификатор"]);
		ВставитьСвойствоЕслиНет(doc1, "Этап", stage);
		Если attachments.Количество() > 0 Тогда
			ВставитьСвойствоЕслиНет(doc1, "Вложение", attachments);
			Попытка
				ДокДляВложений = Новый Соответствие;
				ДокДляВложений["Идентификатор"] = doc1["Идентификатор"];
				ДокДляВложений["Вложение"] = doc1["Вложение"];
				local_helper_write_attachment(context.params, ДокДляВложений);
			Исключение
				ИнфОбОшибке = ОписаниеОшибки(); 
				Возврат ИнфОбОшибке;				
			КонецПопытки;	
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

		block_context.Вставить("ДанныеДляПодписания", сбисОпределитьДанныеДляПодписания(context, doc, action));
			
		ВставитьСвойствоЕслиНет(stage, "Действие", Новый Соответствие);
		ВставитьСвойствоЕслиНет(stage["Действие"], "Название", action_name);
		ВставитьСвойствоЕслиНет(stage["Действие"], "Комментарий", get_prop(block_context,"COMMENT", ""));
		Если block_context.ДанныеДляПодписания.Свойство("СертификатДок") и block_context.ДанныеДляПодписания.СертификатДок <> Неопределено Тогда
			ВставитьСвойствоЕслиНет(stage["Действие"], "Сертификат", block_context.ДанныеДляПодписания.СертификатДок);
		КонецЕсли;
		Если ЗначениеЗаполнено(block_context.ДанныеДляПодписания) и block_context.ДанныеДляПодписания.Тип = "Простое" Тогда 
			stage["Действие"].Вставить("ТипПодписи", "Отсоединенная");	
		КонецЕсли;	
		Если easy_send = "TRUE" Тогда
			stage["Действие"]["Название"] = "ПростоОтправить";
			stage["Название"] = "ПростаяОтправка";
		КонецЕсли;	
	
		Попытка
			block_context.Вставить("_prepare_result", local_helper_prepare_action(context.params, doc1));
		Исключение
			ИнфОбОшибке = ИнформацияОбОшибке();			
			ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,"execute_action");
		КонецПопытки;
		
		block_context.Вставить("execute_action_param", Новый Соответствие);
		ВставитьСвойствоЕслиНет(block_context.execute_action_param, "Идентификатор", get_prop(block_context._prepare_result,"Идентификатор")); 
		prepared_stage = get_prop(block_context._prepare_result,"Этап");
		block_context.execute_action_param.Вставить("Этап", prepared_stage[0]);				
	КонецЕсли;	
		
	Попытка
		ЧистыйЭтап = Новый Соответствие;
		Если block_context.ДанныеДляПодписания.Свойство("СертификатДляПодписания") И ЗначениеЗаполнено(block_context.ДанныеДляПодписания.СертификатДляПодписания) 
			И get_prop(block_context.execute_action_param["Этап"], "Вложение") <> Неопределено Тогда
	    	get_signatures(context, block_context.execute_action_param, block_context.ДанныеДляПодписания, block_context);
			ЧистыйЭтап.Вставить("Вложение", block_context.execute_action_param["Этап"]["Вложение"]);
		КонецЕсли;
		
		ЧистыйЭтап.Вставить("Название", block_context.execute_action_param["Этап"]["Название"]);
		ЧистыйЭтап.Вставить("Идентификатор", block_context.execute_action_param["Этап"]["Идентификатор"]);
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
		block_context.execute_action_param["Этап"] = ЧистыйЭтап;
		
		Если doc_performer.Количество() > 0 Тогда
			ЗаполнитьИсполнителей(block_context.execute_action_param, doc_performer);
		КонецЕсли;

		Возврат local_helper_execute_action(context.params, block_context.execute_action_param);
	Исключение
		
		ИнфОбОшибке = ИнформацияОбОшибке();
		ОшибкаСтруктура = NewExtExceptionСтруктура(ИнфОбОшибке);
		Если ЭтоСлужебнаяОшибкаБлока(ОшибкаСтруктура.type) Тогда
			ВызватьИсключение ИнфОбОшибке.Описание; // (исходное исключение)
		КонецЕсли;

		Возврат ОшибкаСтруктура;
		
	КонецПопытки;
		
КонецФункции

Функция block_saby_execute_action_magic_button(context, doc, doc_attach, doc_performer)
	мСотрудники = Новый Массив;
	мРуководители = Новый Массив;
	мВложения = Новый Массив;
	
	Для каждого Сотрудника Из doc_performer Цикл
		Если Сотрудника["Роль"] = "Руководитель" Тогда
			мРуководители.Добавить(Новый Структура("PersonnelNumber", Сотрудника["ТабельныйНомер"]));	
		ИначеЕсли Сотрудника["Роль"] = "Сотрудник" Тогда
			мСотрудники.Добавить(Новый Структура("PersonnelNumber", Сотрудника["ТабельныйНомер"]));	
		КонецЕсли	
	КонецЦикла;
	Для каждого Вложения из doc_attach Цикл
		мВложения.Добавить(Новый Структура("ExtId",Вложения["Идентификатор"] ));	
	КонецЦикла;	
	
	params = Новый Структура("DocumentExt, ChannelKind, Managers, Employees, SignRequirement, Route, Attachments",
		doc["Идентификатор"],
		Число(doc["КаналИнформации"]),														//Сюда надо передать тип уведомления 0 – электронная почта, 1 –СМС, 2 –Viber, 3 –WhatsApp, 4 –Telegram
		мРуководители,                                          //Массив руководителей
		мСотрудники,                                          //Массив сотрудников
		Новый Структура("Managers, Employees", 1, 2),
		Число(doc["МаршрутОзнакомления"]),                                                      //Сюда передать Маршрут ознакомления: 0 –одновременно всем, 1 –сначала руководители, 2 –сначала сотрудники
		мВложения);		                                    
	Для Сч=0 По 2 Цикл
		Попытка
			result = local_helper_request_signing(context, params);
			Возврат result;
		Исключение   
			ИнфОбОшибке = ИнформацияОбОшибке();
			local_helper_pause(5);
		КонецПопытки;
	КонецЦикла;	
	ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке,,,"magic_button");
КонецФункции	

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
            ИначеЕсли att_type = "att_b64" Тогда
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
		КонецЦикла;		
        return attachments
КонецФункции	

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
					operation_uuid = local_helper_init_remote_signing(context.params, sign_array);
				Исключение
					ИнфОбОшибке = ИнформацияОбОшибке();
					Возврат Новый Массив;	
				КонецПопытки;
				Попытка
					Возврат local_helper_get_remote_signature(context.params, operation_uuid);	
				Исключение
					ИнфОбОшибке = ИнформацияОбОшибке();
					Возврат Новый Массив;
				КонецПопытки;	
			КонецЕсли;	
		КонецЦикла;	
	КонецЦикла;	
КонецФункции	

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
