
Процедура block_obj_prop_set_inobj1с(obj, obj_path, value)  
	delimiter = ".";
	_path = СтрРазделить82(obj_path, delimiter, Ложь);
	_obj = obj;
	
	i = 0;
	size = _path.Количество() - 1;
	Пока i < size Цикл
		elem = _path[i];
		Попытка 
			_obj = _obj[elem];
		Исключение 
			ВызватьИсключение "У объекта " + Строка(_obj) + " отсутствует реквизит " + elem;
		КонецПопытки;
		i = i + 1;
	КонецЦикла;
	Если ТипЗнч(_obj) = Тип("Структура") Тогда
		_obj.Вставить(_path[size], value);	
	Иначе
		_obj[_path[size]] = value;
	КонецЕсли;			
КонецПроцедуры


// Функция block_obj_prop_set_calc_value
//
// Параметры:
// block_type - Строка - Название блока
// node - XML - Текущий обрабатываемый узел XML
// path - Строка - Абсолютный путь до исполняемого блока
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Неопределено - Результат выполения функции
//
//DynamicDirective
Функция block_obj_prop_set_calc_value(block_type, node, path, context, block_context)
	//TODO обернуть в попытку. указать имя полей объекта куда не смогли вставить
	variable_name = block_context["VAR"];
	obj = block_get_variable(context, variable_name); 
	Если block_context.Свойство("VALUE") Тогда
		value = get_prop(block_context, "VALUE");
	Иначе
		value = "";
	КонецЕсли;
	Если obj = value Тогда
		ВызватьИсключение "Объект не может быть добавлен в этот же объект"; 
	КонецЕсли;
	obj_path = block_context["PATH"];
	Если ТипЗнч(obj_path) <> Тип("Строка") Тогда
		ВызватьИсключение "Неверный тип параметра ""свойство"". Необходимо передавать только строку."; 
	КонецЕсли;
	Попытка
		Если ТипЗнч(obj) = Тип("Структура") или ТипЗнч(obj) = Тип("Соответствие") Тогда
			block_obj_set_path_value(obj, obj_path, value);
		Иначе
			block_obj_prop_set_inobj1с(obj, obj_path, value);
		КонецЕсли;
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, 
												"Не удалось присвоить значение переменной ", 
												variable_name+ "." + obj_path+ " - " + ИнфОбОшибке.Описание,
												, add_block_to_dump(block_context)));
	КонецПопытки;
	block_set_variable(context, variable_name, obj);
	Возврат Неопределено;
КонецФункции
