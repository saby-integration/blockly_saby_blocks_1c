// Функция block_rule_field_dest_calc_value
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
Функция block_rule_field_dest_calc_value(block_type, node, path, context, block_context) Экспорт  

	rule = rule_init_rule(context, block_context);
	// BSLLS:UnusedLocalVariable-off
	_scope = rule_scope_add(rule, "Dest", get_prop(block_context, "Name"));
	// BSLLS:UnusedLocalVariable-on
	
	rule_scope = get_prop(rule, "scope", Новый Соответствие);
	rule_scope_dest = get_prop(rule_scope, "Dest", Новый Соответствие);
    parent = rule_scope_dest[rule_scope_dest.Количество() - 2];

    handler_dest = get_prop(parent, "value");
    rule_scope_remove(rule, "Dest");
	
	src_value = rule_field_src_calc_value(get_prop(block_context, "Value"));
	rule.Удалить("src_scope");

	Возврат rule_set_property(handler_dest, get_prop(block_context, "Name"), src_value);

КонецФункции

// Функция block_rule_field_src_const_calc_value
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
Функция block_rule_field_src_const_calc_value(block_type, node, path, context, block_context) Экспорт  
	rule = rule_init_rule(context, block_context);

	value = get_prop(block_context, "Value");
	
	scope_Value = value;
	scope_data = Новый Соответствие;
	scope_data.Вставить("Value", scope_Value);
	scope_val = Новый Структура;
	scope_val.Вставить("data", scope_data); 
	
	src_scope = Новый Соответствие;
	src_scope.Вставить("_Type", ТипЗнч(value));
	src_scope.Вставить("value", scope_val);
	rule.Вставить("src_scope", src_scope);
	
	Возврат src_scope;
	 
КонецФункции

// Функция block_rule_field_src_field_calc_value
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
Функция block_rule_field_src_field_calc_value(block_type, node, path, context, block_context) Экспорт  
	
	rule = rule_init_rule(context, block_context);

	_scope = get_prop(rule, "scope");
	_Dest = get_prop(_scope, "Dest");
	Если ЗначениеЗаполнено(_Dest) Тогда
		// BSLLS:UnusedLocalVariable-off
		dest_scope = _Dest[_Dest.Количество()-1];
		// BSLLS:UnusedLocalVariable-on
	КонецЕсли;	                                   
	Если get_prop(block_context, "_Path") = Неопределено И Не get_prop(block_context, "Value") = Неопределено Тогда
		_path = Saby_СтрРазделить82(block_context["Value"], ".");
		block_context.Вставить("_Path", _path);
	КонецЕсли;
	Для каждого elem Из get_prop(block_context, "_Path", Новый Массив) Цикл
		src_scope = rule_scope_add(rule, "Src", elem);	
	КонецЦикла;
	rule.Вставить("src_scope", src_scope);
	// BSLLS:UseLessForEach-off
	Для каждого elem Из get_prop(block_context, "_Path", Новый Массив) Цикл
		rule_scope_remove(rule, "Src");
	КонецЦикла;
	// BSLLS:UseLessForEach-on
	
	Возврат src_scope;
КонецФункции

