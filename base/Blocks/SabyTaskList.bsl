
// Функция saby_task_list_items
//
// Параметры:
// context - Соответствие - Контекст исполняемого блока
// block_context - Соответствие - Контекст текущего выполняемого блока
//
// Возвращаемое значение:
//  Массив - Результат выполения функции
//
//DynamicDirective
Функция saby_task_list_items(context, block_context)
	begin = ДатаВМиллисекундах();
	Страница	= get_prop(block_context, "page", 0);
	РазмерСтраницы	= get_prop(block_context, "page_size", 25);
	Навигация = Новый Структура("РазмерСтраницы, Страница", РазмерСтраницы, Страница);
	result = ТранспортИнтеграции.local_helper_task_list(context.params,,,, Навигация);
	Title = "Получение списка задач";  
	Subtitle = Неопределено;
	Реестр = get_prop(result, "Реестр", Новый Массив);
	Data = Новый Структура; 
	Data.Вставить("message", "Прочитано " + Реестр.Количество() + " объектов"); 
	dump = Новый Структура;
	dump.Вставить("Result", Реестр);
	Data.Вставить("dump", dump);
	end = ДатаВМиллисекундах();
	block_saby_execute_action_write_esoaction_on_obj(begin, end, Title, Subtitle, Data, , 0);
	Возврат Реестр;
КонецФункции	
