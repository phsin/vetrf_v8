﻿// *******Отправка
&НаСервере
Процедура кнОтправитьНаСервере()
	Записать();
	Обработка = ВСД.ИнициализацияОбработки(Объект.Организация);
	Если типЗнч(Обработка) = Тип("Строка") тогда
		Сообщить("Не удалось инициализировать обработку Интеграция");
		Возврат;
	КонецЕсли;
	Обработка.Отправить_ВСД_транзакция(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура кнОтправить(Команда)
	ПоказатьОповещениеПользователя("Выполняем отправку ВСД",,"Ожидайте...",БиблиотекаКартинок.Информация32);
	ЭтаФорма.Закрыть();	
	кнОтправитьНаСервере();
	ПоказатьОповещениеПользователя("Выполнено");
КонецПроцедуры
