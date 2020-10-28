﻿&НаСервере
Процедура ЗаписатьВсдНаСервере(Знач ДокСсылка)
	
	Докобъект = ДокСсылка.ПолучитьОбъект();
	ДокОбъект.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтвета(Ответ, Парам) Экспорт
	
	ДокСсылка = Парам.ПараметрКоманды;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПоказатьОповещениеПользователя("Выполняем отправку ВСД",,"Ожидайте...",БиблиотекаКартинок.kb99_wrench);

		Если Найти(Парам.ПараметрыВыполненияКоманды.Источник.ИмяФормы,"Списка") = 0 Тогда
			Парам.ПараметрыВыполненияКоманды.Источник.этаФорма.Закрыть();
		КонецЕсли;
		ЗаписатьВсдНаСервере(ДокСсылка);
		
		ТаблицаВсдДляГашения = Неопределено;
		
		Организация = кб99_ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере( ДокСсылка, "Организация" );
		ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Организация );				
		
		Ответ = кб99_ВСД_Запросы.ВСД2_транзакция_Отправить( ПараметрыОрганизации, ДокСсылка, ТаблицаВсдДляГашения );
				
		Если Ответ="COMPLETED" Тогда 					
			Если кб99_ВСД_Клиент.ПогаситьВсдОтИмениПолучателяСписком( ДокСсылка, ТаблицаВсдДляГашения) Тогда
				Сообщить("Партии погашены");
			Иначе
				Сообщить("Возникли ошибки при автогашении",СтатусСообщения.ОченьВажное);
				ОткрытьЗначение( ДокСсылка );
			КонецЕсли;			
		Иначе
			Сообщить("Возникли ошибки при отправке", СтатусСообщения.ОченьВажное);
			ОткрытьЗначение( ДокСсылка );
		КонецЕсли;

	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДокСсылка = ПараметрКоманды;
	
	ТВопроса = "Отправить и Погасить ВСД в Меркурий ?";
	Парам = Новый Структура("ПараметрКоманды, ПараметрыВыполненияКоманды", ПараметрКоманды, ПараметрыВыполненияКоманды);
    Оповещение = Новый ОписаниеОповещения("ОбработкаОтвета", ЭтотОбъект, Парам);	
    ПоказатьВопрос(Оповещение, ТВопроса, РежимДиалогаВопрос.ДаНет,  0, КодВозвратаДиалога.Да, ""   );
	
КонецПроцедуры
