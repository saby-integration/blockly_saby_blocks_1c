//DynamicDirective
Функция block_extsyncdoc_create_calc_value(block_type, node, path, context, block_context)
	Попытка
		direction = block_context.Direction;
	Исключение
		ОшибкаСтрокой = NewExtExceptionСтрока(Новый Структура("message, detail", "Не указан обязательный параметр", block_type + " Direction"));
		ВызватьИсключение ОшибкаСтрокой;
	КонецПопытки;
	Попытка
		data = block_context.Data;
	Исключение
		ОшибкаСтрокой = NewExtExceptionСтрока(Новый Структура("message, detail", "Не указан обязательный параметр", block_type + " Data"));
		ВызватьИсключение ОшибкаСтрокой;
	КонецПопытки;
	
	Если direction = "1" Тогда // import
		direction = 1;
	ИначеЕсли direction = "2" Тогда // export changes
		direction = 2;
	ИначеЕсли direction = "0" Тогда // export
		direction = 0;
	ИначеЕсли direction = "5" Тогда // compare
		direction = 5;
	ИначеЕсли direction = "6" Тогда // check
		direction = 6;
	Иначе
		ВызватьИсключение "Неверное значение параметра Direction!";
	КонецЕсли;
	
	extsyncdoc_uuid = get_prop(context.operation, "operation_uuid",  "");
	connection_uuid = get_prop(context.operation, "connection_uuid", "");
	
	Попытка
		Если ПустаяСтрока(extsyncdoc_uuid) Тогда
			ПараметрыВызова = Новый Структура("Direction", direction);
		Иначе
			// И почему тут будет новый uuid, а не от предыдущего вызовата? Миша!
			ПараметрыВызова = Новый Структура("Uuid, Direction", extsyncdoc_uuid, direction);
		КонецЕсли;
		ПараметрыВызова.Вставить("Data", data); // Данные
		ПолученныйUuid = Транспорт.local_helper_extsyncdoc_write(
			context.params,
			connection_uuid,
			ПараметрыВызова,
			Неопределено);
		Если Не ПустаяСтрока(ПолученныйUuid) И ПолученныйUuid <> extsyncdoc_uuid Тогда
			context.operation.Вставить("operation_uuid", ПолученныйUuid);
		КонецЕсли;
		Возврат True;
	Исключение
		ИнфОбОшибке = ИнформацияОбОшибке();
		block_set_variable(context, "_last_error", NewExtExceptionСтрока(ИнфОбОшибке));
		ВызватьИсключение NewExtExceptionСтрока(ИнфОбОшибке);
	КонецПопытки;
	
	Возврат block_context.result;
КонецФункции
