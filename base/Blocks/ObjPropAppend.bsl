//DynamicDirective
Функция block_obj_prop_append_calc_value(block_type, node, path, context, block_context)
	obj = block_get_variable(context, block_context["VAR"]);
	value = block_context["VALUE"];
	Если ЗначениеЗаполнено(block_context["PATH"]) Тогда
		obj[block_context["PATH"]].append(value);
	Иначе
		Если Найти(Строка(obj), "ТабличнаяЧасть") или Найти(Строка(obj), "ТаблицаЗначений") Тогда   
			_variable = obj.Добавить();
			Если ТипЗнч(value)= тип("Структура") или ТипЗнч(value) = Тип("Соответствие") Тогда
				Для Каждого field из value цикл
					Попытка
						_variable[field.Ключ] = field.Значение;
					Исключение
					КонецПопытки;
				КонецЦикла;
			КонецЕсли;
		Иначе	
			obj.Добавить(value);
		КонецЕсли;
	КонецЕсли;	
	block_set_variable(context, block_context["VAR"], obj);
	Возврат Неопределено;
КонецФункции
