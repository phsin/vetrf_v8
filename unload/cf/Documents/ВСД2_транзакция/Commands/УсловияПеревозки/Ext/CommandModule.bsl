﻿
&НаСервере
Процедура ЗаписатьВсдНаСервере(ДокСсылка)
	
	Докобъект = ДокСсылка.ПолучитьОбъект();
	ДокОбъект.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Состояние("Выполняем запрос Регионализации",,"Ожидайте...",БиблиотекаКартинок.kb99_wrench);
	ЗаписатьВСДНаСервере(ПараметрКоманды);
	кб99_ВСД.ПолучитьУсловияПеревозки(ПараметрКоманды);
	ПоказатьОповещениеПользователя("Выполнено");
		
КонецПроцедуры
