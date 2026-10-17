
// Функция block_api3_predefined_calc_value
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
Функция block_api3_predefined_calc_value(block_type, node, path, context, block_context)
	result = Новый Структура();
	Если get_prop(block_context, "default") = "TRUE" Тогда
		result.Вставить("Default", Истина);
	Иначе
		result.Вставить("Default", Ложь); 
	КонецЕсли;
	Set_Prop(block_context, result, "ИС_Ид", "ClientId");
	Set_Prop(block_context, result, "ИС_Название", "ClientTitle");
	Set_Prop(block_context, result, "ИС_Ключ1_1", "ClientKey1_1");
	Set_Prop(block_context, result, "ИС_Ключ1_2", "ClientKey1_2");
	Set_Prop(block_context, result, "ИС_Ключ1_3", "ClientKey1_3");
	Set_Prop(block_context, result, "ИС_Ключ2", "ClientKey2");
	Set_Prop(block_context, result, "ИС_Ключ3", "ClientKey3");
	Set_Prop(block_context, result, "ИС_Родитель", "ClientParentId");
	Если get_prop(block_context, "ИС_ЭтоГруппа") = "TRUE" Тогда
		result.Вставить("ClientIsFolder", Истина);
	КонецЕсли;
	Set_Prop(block_context, result, "СБИС_Ид", "SbisId");
	Set_Prop(block_context, result, "СБИС_Название", "SbisTitle");
	Set_Prop(block_context, result, "СБИС_Ключ1_1", "SbisKey1_1");
	Set_Prop(block_context, result, "СБИС_Ключ1_2", "SbisKey1_2");
	Set_Prop(block_context, result, "СБИС_Ключ1_3", "SbisKey1_3");
	Set_Prop(block_context, result, "СБИС_Ключ2", "SbisKey2");
	Set_Prop(block_context, result, "СБИС_Ключ3", "SbisKey3");
	Возврат result;
КонецФункции
