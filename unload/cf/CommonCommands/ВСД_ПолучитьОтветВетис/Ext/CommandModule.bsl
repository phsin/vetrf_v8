﻿

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПоказатьОповещениеПользователя("Выполняем запрос Ответа о состоянии документов",,"Ожидайте...",БиблиотекаКартинок.Информация32);
	ВСД.Получить_Ответ_Меркурий(ПараметрКоманды);
	ПоказатьОповещениеПользователя("Операция завершена");
КонецПроцедуры
