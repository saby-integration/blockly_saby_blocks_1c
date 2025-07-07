
// block_test_read_saby_object_calc_value
//
// Параметры:
//  block_type - Строка - Название блока
// 	node - Структура - Dom структура хмл
//  path - Строка - Пусть до блока по алгоритму
//  context - Структура - Общий контекст алгоритма
//  block_context - Структура - Контекст исполняемого блока
//
// Возвращаемое значение:
//  Структура - Результат обсчета алгоритма
//
//DynamicDirective
Функция block_test_read_saby_object_calc_value (block_type, node, path, context, block_context)
	_value1 = "value1";
	required_param = Новый Массив;
	required_param.Добавить("type");
	required_param.Добавить(_value1);
	block_check_required_param_in_block_context(required_param, block_context);
	
	_Название = "Название";
	_keys = "keys";
	key_number = block_context.Key;
	block_context.Вставить(_keys, Новый Структура("ИдИС", ""));  // todo ошибка на бл, убрать костыли
	Если key_number = "1" Тогда
		Для value_number = 1 По 3 Цикл
			value = get_prop(block_context, "value" + value_number);
			Если value <> Неопределено Тогда
				block_context[_keys].Вставить("Ключ1_" + value_number, value);
			КонецЕсли;
		КонецЦикла;	
	ИначеЕсли key_number = _Название Тогда
		block_context[_keys].Вставить(_Название, get_prop(block_context, _value1));
	Иначе
		block_context[_keys].Вставить("Ключ" + key_number, get_prop(block_context, _value1));
	КонецЕсли;
	
	// ищем объект по ключам
	resp = ТранспортИнтеграции.local_helper_find_sbis_object(context.params, block_context.type, block_context.keys);
    // если не находим ругаемся
	list_obj = get_prop(resp, "result");
	// добавляем в обмен
	Если list_obj = Неопределено ИЛИ list_obj.Количество() = 0 Тогда
		ВызватьИсключение NewExtExceptionСтрока(, "Тестовый объект не найдет в " + ЛокализацияНазваниеПродукта(), , 
			"block_test_read_saby_object");
	КонецЕсли;
	obj = list_obj[0];
	// запускаем обмен            
	
	direction = 0;
	obj_saby_id = get_prop(obj, "ИдСБИС");
	
	extsyncobjectsitem = Новый Структура("Title, Type, SbisId",
		get_prop(obj, _Название),
		block_context.type,
		obj_saby_id);
	extsyncobjects = Новый Массив;
	extsyncobjects.Добавить(extsyncobjectsitem);
	
	// записываем ссылку
	connection_uuid = get_prop(context.operation,"connection_uuid","");
	extsyncdoc_uuid = ТранспортИнтеграции.local_helper_extsyncdoc_write(
		context.params,
		connection_uuid,
		Новый Структура("Direction", direction),
		extsyncobjects);	
	context.operation.Вставить("operation_uuid", extsyncdoc_uuid); 

	// получаем наш объект
	filter = Новый Структура("SyncDocId", extsyncdoc_uuid);
	sort = Новый Массив();
	sort.Добавить("Priority");
	resp = ТранспортИнтеграции.local_helper_extsyncobj_list(context.params, , filter);
	extsyncobject_uuid = resp["Result"][0]["Uuid"];
	context.operation.Вставить("extsyncobject_uuid", extsyncobject_uuid); 
	
	// вычитываем объекты и подобъекты
	block_context.Вставить("PrepareResult", block_extsyncdoc_run_extsyncdoc_prepare_saby(context, block_context));
	block_context.Вставить("result", block_extsyncdoc_run_extsyncdoc_execute_is(context, block_context, extsyncobject_uuid));
		
	Возврат block_context.result;
КонецФункции
