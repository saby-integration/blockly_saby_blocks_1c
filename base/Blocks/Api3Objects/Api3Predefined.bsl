
//DynamicDirective
Функция block_api3_predefined_calc_value(block_type, node, path, context, block_context)
	ИС = Новый Структура;
	СБИС = Новый Структура;
	Set_Prop(block_context, ИС, "default", "default");
	Set_Prop(block_context, ИС, "ИС_Ид", "ИдИС");
	Set_Prop(block_context, ИС, "ИС_Название", "Название");
	Set_Prop(block_context, ИС, "ИС_Ключ1_1", "Ключ1_1");
	Set_Prop(block_context, ИС, "ИС_Ключ1_2", "Ключ1_2");
	Set_Prop(block_context, ИС, "ИС_Ключ1_3", "Ключ1_3");
	Set_Prop(block_context, ИС, "ИС_Ключ2", "Ключ2");
	Set_Prop(block_context, ИС, "ИС_Ключ3", "Ключ3");
	Set_Prop(block_context, СБИС, "СБИС_Ид", "ИдСБИС");
	Set_Prop(block_context, СБИС, "СБИС_Название", "Название");
	Set_Prop(block_context, СБИС, "СБИС_Ключ1_1", "Ключ1_1");
	Set_Prop(block_context, СБИС, "СБИС_Ключ1_2", "Ключ1_2");
	Set_Prop(block_context, СБИС, "СБИС_Ключ1_3", "Ключ1_3");
	Set_Prop(block_context, СБИС, "СБИС_Ключ2", "Ключ2");
	Set_Prop(block_context, СБИС, "СБИС_Ключ3", "Ключ3");
	result = Новый Структура("ИС, СБИС", ИС, СБИС);
	Set_Prop(block_context, result, "default", "default");
	Возврат result;
КонецФункции
