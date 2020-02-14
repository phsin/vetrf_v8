﻿&НаСервере
Процедура ВыполнитьНаСервере(ПараметрКоманды)
		Организация = кб99_ВСД_Общий.ПолучитьОрганизациюПоУмолчанию();	
		ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Организация );
		
		Для Каждого элемент Из ПараметрКоманды Цикл
			кб99_ВСД_Запросы.Продукция_Элемент_Изменить( ПараметрыОрганизации, элемент, "DELETE" );
		КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтвета(Ответ, ПараметрКоманды) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПоказатьОповещениеПользователя("Выполняем запрос Удаление Продукции",,"Ожидайте...",БиблиотекаКартинок.Информация32);
		//ВСД.Изменить_Продукцию_Меркурий(,Парам.ПараметрКоманды,"DELETE");		
	
		ВыполнитьНаСервере(ПараметрКоманды);
		
		ПоказатьОповещениеПользователя("Операция завершена");
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ТВопроса = "Удалить Продукцию в Меркурий ?";
	//Парам = Новый Структура("ПараметрКоманды,ПараметрыВыполненияКоманды",ПараметрКоманды,ПараметрыВыполненияКоманды);
    Оповещение = Новый ОписаниеОповещения("ОбработкаКомандыОтвет",ЭтотОбъект,ПараметрКоманды);	
    ПоказатьВопрос(Оповещение, ТВопроса, РежимДиалогаВопрос.ДаНет,  0, КодВозвратаДиалога.Да, ""   );
КонецПроцедуры
