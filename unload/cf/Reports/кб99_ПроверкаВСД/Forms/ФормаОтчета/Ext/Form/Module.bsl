﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Организация = кб99_ВСД_Общий.ПолучитьОрганизациюПоУмолчанию();
	ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры(Организация);
	
	ОтправительХС		 = ПараметрыОрганизации.Отправитель_ХозСубъект;
    Период.ДатаНачала	 = НачалоМесяца(ТекущаяДата());
	Период.ДатаОкончания = КонецМесяца(ТекущаяДата());
	СтатусВСД			 = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьЗначенияПараметров();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправительХСПриИзменении(Элемент)
	
	УстановитьЗначенияПараметров();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	УстановитьЗначенияПараметров();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусВСДПриИзменении(Элемент)
	
	УстановитьЗначенияПараметров();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПараметров()
	 
	УстановитьЗначениеПараметра("НачалоПериода",	 Период.ДатаНачала, ЗначениеЗаполнено(Период));
	УстановитьЗначениеПараметра("ОкончаниеПериода",	 Период.ДатаОкончания, ЗначениеЗаполнено(Период));
	УстановитьЗначениеПараметра("ОтправительХС",	 ОтправительХС, ЗначениеЗаполнено(ОтправительХС));
	УстановитьЗначениеПараметра("Статус",			 СтатусВСД, ЗначениеЗаполнено(СтатусВСД));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеПараметра(ИмяПараметра, Значение, Использование = Истина)
	
	ПараметрыОтчета = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных;
	Параметр = ПараметрыОтчета.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	Параметр.Значение = Значение;
	Параметр.Использование = Использование;
	
КонецПроцедуры