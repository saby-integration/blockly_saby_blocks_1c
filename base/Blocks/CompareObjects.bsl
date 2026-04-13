
// Функция block_compare_objects_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Строка - Результат выполения сравнения. Пустая строка, если нет различий.
//
// BSLLS:CognitiveComplexity-off
// BSLLS:CyclomaticComplexity-off
//DynamicDirective
Функция block_compare_objects_calc_value(block_type, node, path, context, block_context)
	
	Объект1  = get_prop(block_context, "OBJECT1");
	Объект2  = get_prop(block_context, "OBJECT2");
	Свойства = get_prop(block_context, "PROPS"); // Массив реквизитов для сравнения (не ТабЧвсти)
	
	// Проверяем заполнение данных для сравнения по объектам
	ТекстОшибки = "";
	Если НЕ ЗначениеЗаполнено(Объект1) Тогда
		ТекстОшибки = ТекстОшибки + "Объект 1 не заполнен!" + Символы.ПС;
	Иначе
		Если ТипЗнч(Объект1) <> Тип("Структура") И ТипЗнч(Объект1) <> Тип("Соответствие") Тогда
			// Отдельно вычитываем в структуру ссылки на справочники, документы
			Попытка
				Объекты = Новый Структура("Объект1", Объект1);
				ПреобразоватьСтруктутуКДопустимымXDTOТипам(Объекты);
				Объект1 = Объекты.Объект1;
			Исключение
				ТекстОшибки = ТекстОшибки
							+ "Тип объекта 1 не является структурой или ссылкой на документ/справочник!"
							+ Символы.ПС;
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект2) Тогда
		ТекстОшибки = ТекстОшибки + "Объект 2 не заполнен!" + Символы.ПС;
	Иначе
		Если ТипЗнч(Объект2) <> Тип("Структура") И ТипЗнч(Объект2) <> Тип("Соответствие") Тогда
			// Отдельно вычитываем в структуру ссылки на справочники, документы
			Попытка
				Объекты = Новый Структура("Объект2", Объект2);
				ПреобразоватьСтруктутуКДопустимымXDTOТипам(Объекты);
				Объект2 = Объекты.Объект2;
			Исключение
				ТекстОшибки = ТекстОшибки
							+ "Тип объекта 2 не является структурой или ссылкой на документ/справочник!"
							+ Символы.ПС;
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(Свойства) И ТипЗнч(Свойства) <> Тип("Массив") Тогда
		ТекстОшибки = ТекстОшибки + "Тип свойств не является массивом!" + Символы.ПС;
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ВызватьИсключение "compare_objects: " + ТекстОшибки;
	КонецЕсли;
	
	// Параметры для сравнения ШАПОК структур/объектов
	// сравниваем ТОЛЬКО УКАЗАННЫЕ свойства, если нет - не сравниваем
	compare_params = Новый Соответствие;
	compare_params.Вставить("PROPS", Свойства);
	
	// Табличные части из блока
	mutation_count = Число((workspace_find_mutation_by_name(node, "items", 0)));
	Для Инд = 0 По mutation_count - 1 Цикл
		ТЧИмя = get_prop(block_context, "TABLE" + Инд + "_NAME", ""); // Строка, имя таб.части
		Если НЕ ЗначениеЗаполнено(ТЧИмя) Тогда
			Продолжить;
		КонецЕсли;
		ТЧСопоставление = get_prop(block_context, "TABLE" + Инд + "_GROUP"); // Массив реквизитов для сопоставления
		Если НЕ ЗначениеЗаполнено(ТЧСопоставление)
			ИЛИ ТипЗнч(ТЧСопоставление) <> Тип("Массив")
			ИЛИ ТЧСопоставление.Количество() = 0
		Тогда
			Продолжить;
		КонецЕсли;
		ТЧСравнение = get_prop(block_context, "TABLE" + Инд + "_FIELDS"); // Массив реквизитов для сравнения
		Если НЕ ЗначениеЗаполнено(ТЧСравнение)
			ИЛИ ТипЗнч(ТЧСравнение) <> Тип("Массив")
			ИЛИ ТЧСравнение.Количество() = 0
		Тогда
			Продолжить;
		КонецЕсли;
		
		ТабЧасть1 = Объект1[ТЧИмя];
		Если ТипЗнч(ТабЧасть1) <> Тип("Массив") Тогда
			ВызватьИсключение "compare_objects: таб.часть №1 должна быть массивом";
		КонецЕсли;
		ТабЧасть2 = Объект2[ТЧИмя];
		Если ТипЗнч(ТабЧасть2) <> Тип("Массив")	Тогда
			ВызватьИсключение "compare_objects: таб.часть №2 должна быть массивом";
		КонецЕсли;
		
		// Параметры для сравнения ТАБ.ЧАСТЕЙ структур/объектов
		compare_params.Вставить("TABLE" + Инд + "_NAME", ТЧИмя);
		compare_params.Вставить("TABLE" + Инд + "_GROUP", ТЧСопоставление);
		compare_params.Вставить("TABLE" + Инд + "_FIELDS", ТЧСравнение);
	КонецЦикла;
	
	// Сравним объекты
	Результат = compare_objects(Объект1, Объект2, compare_params);
	
	Возврат Результат;
	
КонецФункции
// BSLLS:CognitiveComplexity-on
// BSLLS:CyclomaticComplexity-on

// Функция compare_objects
//
// Параметры:
// fist_object - Структура, Соответствие - 1-ый объект
// second_object - Структура, Соответствие - 2-ой объект
// compare_params - Структура, Соответствие - параметры сравнения
//
// Возвращаемое значение:
//  Строка - Результат выполения сравнения. Пустая строка, если нет различий.
//
//DynamicDirective
Функция compare_objects(fist_object, second_object, compare_params)
	props = get_prop(compare_params, "PROPS");
	result_difference = "";
	Если ЗначениеЗаполнено(props) Тогда
		obj1_props = get_compare_object(fist_object, props);
		obj2_props = get_compare_object(second_object, props);
		difference_delta = compare(obj1_props, obj2_props);
		difference = difference_delta["difference"];
		delta      = difference_delta["delta"];
		Если difference Тогда
			result_difference = result_difference + _difference_string(delta);
		КонецЕсли;
	КонецЕсли;
	
	compare_table_index = 0;
	Пока Истина Цикл
		compare_table_path = get_prop(compare_params, "TABLE" + compare_table_index + "_NAME");
		Если НЕ ЗначениеЗаполнено(compare_table_path) Тогда
			Прервать;
		КонецЕслИ;
		_group  = get_prop(compare_params, "TABLE" + compare_table_index + "_GROUP");
		fields = get_prop(compare_params, "TABLE" + compare_table_index + "_FIELDS");
		table1 = block_obj_get_path_value(fist_object, compare_table_path, Новый Соответствие);
		table2 = block_obj_get_path_value(second_object, compare_table_path, Новый Соответствие);
		obj1_props = index_list(table1, _group, fields);
		obj2_props = index_list(table2, _group, fields);
		difference_delta = compare(obj1_props, obj2_props);
		difference = difference_delta["difference"];
		delta      = difference_delta["delta"];
		Если difference Тогда
			result_difference = result_difference + _difference_string(delta, compare_table_path);
		КонецЕсли;
		compare_table_index = compare_table_index + 1;
	КонецЦикла;
	
	Возврат result_difference;
КонецФункции

// Функция compare
//
// Параметры:
// _base - Структура, Соответствие - 1-ый объект
// _new - Структура, Соответствие - 2-ой объект
//
// Возвращаемое значение:
//  Структура - Результат выполения сравнения.
//		difference - Булево - Признак наличия отличий
//		delta - Неопределено, Произвольный - Поля с различиями
//
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS-off
//DynamicDirective
Функция compare(Знач _base, Знач _new)
	Если ТипЗнч(_base) = Тип("Соответствие") ИЛИ ТипЗнч(_base) = Тип("Структура") Тогда
		difference = Ложь;
		res = Новый Соответствие;
		Если ЗначениеЗаполнено(_new) Тогда
			Для Каждого КлючЗначение Из _new Цикл
				elem = КлючЗначение.Ключ;
				Попытка
					Если ЗначениеЗаполнено(_base) И has_prop(_base, elem) Тогда
						Если ТипЗнч(_new[elem]) = Тип("Соответствие") ИЛИ ТипЗнч(_new[elem]) = Тип("Структура") Тогда
							_difference_delta = compare(_base[elem], _new[elem]);
							_difference = _difference_delta["difference"];
							_res        = _difference_delta["delta"];
							Если _difference Тогда
								difference = Истина;
								res[elem] = _res;
							КонецЕсли;
						Иначе
							Если _new[elem] <> _base[elem] Тогда
								difference = Истина;
								res[elem] = _new[elem];
							КонецЕсли;
						КонецЕсли;
					Иначе
						difference = Истина;
						res[elem] = _new[elem];
					КонецЕсли;
				Исключение
					ИнфОбОшибке = ИнформацияОбОшибке();
					ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке, "Ошибка: compare() elem = " + elem);
				КонецПопытки;
			КонецЦикла;
		Иначе
			Если _base <> _new Тогда
				difference = Истина;
				res = _base;
			КонецЕсли;
		КонецЕсли;
	Иначе
		difference = Ложь;
		res = Неопределено;
		Если _base <> _new Тогда
			difference = Истина;
			res = _new;
		КонецЕсли;
	КонецЕсли;
	Возврат Новый Структура("difference, delta", difference, res);
КонецФункции
// BSLLS-on

// Функция _difference_string
//
// Параметры:
// _delta - Структура, Соответствие - Словарь с различиями
// _prefix - Строка - Строка префикса вида "Префикс: "
//
// Возвращаемое значение:
//  Строка - Результат с различиями. В каких значениях по ключам для сопоставления. Пустая строка, если различий нет.
//
//DynamicDirective
Функция _difference_string(_delta, _prefix = Неопределено)
	result = "";
	Если ЗначениеЗаполнено(_prefix) Тогда
		result = result + _prefix + ": ";
	КонецЕсли;
	Для Каждого КлючЗначение Из _delta Цикл
		result = result + КлючЗначение.Ключ + ", ";
	КонецЦикла;
	Возврат "" + Лев(result, СтрДлина(result) - 2) + "; ";
КонецФункции

// Функция get_compare_object
//
// Параметры:
// obj - Структура, Соответствие - Объект/Структура
// keys - Массив - Массив свойств
// kwargs - Произвольный - Значение по-умолчанию для получения объекта в блоке block_obj_get_path_value
//
// Возвращаемое значение:
//  Соответствие - Словарь с нужными реквизитами "keys" из объекта "obj"
//
//DynamicDirective
Функция get_compare_object(obj, keys, kwargs = Неопределено)
	compare_obj = Новый Соответствие;
	Для Каждого _key Из keys Цикл
		compare_obj.Вставить(_key, block_obj_get_path_value(obj, _key, kwargs));
	КонецЦикла;
	Возврат compare_obj;
КонецФункции

// Функция index_list
//
// Параметры:
// items - Массив - Табличная часть
// _group - Массив - Список ключей для сопоставления подобъектов
// fields - Массив - Список ключей для сравнения подобъектов
//
// Возвращаемое значение:
//  Соответствие - Словарь с найденными значениями в табличной части "items" по ключам "_group"
//                 и просуммированными (для чисел) значениями по ключам "fields"
//
// Сохраняем идентичность со структурой кода в Питоне
// BSLLS-off
//DynamicDirective
Функция index_list(items, _group, fields)
    compare_obj = Новый Соответствие;
	Если ЗначениеЗаполнено(items) Тогда
		Для Каждого item Из items Цикл
            uid = "";
            Для Каждого _key Из _group Цикл
                uid = uid + block_obj_get_path_value(item, _key, "-") + "_";
			КонецЦикла;
			Если НЕ has_prop(compare_obj, uid) Тогда
                compare_obj.Вставить(uid, Новый Соответствие);
			КонецЕсли;
			
			Для Каждого _key Из fields Цикл
                value = block_obj_get_path_value(item, _key, "");
				Если ТипЗнч(value) = Тип("Число") Тогда
					Если НЕ has_prop(compare_obj[uid], _key) Тогда
                        compare_obj[uid].Вставить(_key, 0);
					КонецЕсли;
                    compare_obj[uid][_key] = compare_obj[uid][_key] + value;
				Иначе
                    compare_obj[uid].Вставить(_key, value);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
    Возврат compare_obj;
КонецФункции
// BSLLS-on

