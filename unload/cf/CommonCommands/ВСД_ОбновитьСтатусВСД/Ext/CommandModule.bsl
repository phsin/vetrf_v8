﻿&НаКлиенте
Процедура ОбработкаКомандыОтвет(Ответ, Парам) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПоказатьОповещениеПользователя("Отправляем запрос в Ветис",,"Ожидайте...",БиблиотекаКартинок.Информация32);
		Если Найти(Парам.ПараметрыВыполненияКоманды.Источник.ИмяФормы,"Списка") = 0 Тогда
			Парам.ПараметрыВыполненияКоманды.Источник.этаФорма.Закрыть();
		КонецЕсли;		
    	кб99_ВСД.ОбновитьСтатусВСД( Парам.ПараметрКоманды );
		ПоказатьОповещениеПользователя("Выполнено");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Парам = Новый Структура("ПараметрКоманды,ПараметрыВыполненияКоманды",ПараметрКоманды,ПараметрыВыполненияКоманды);
    Оповещение = Новый ОписаниеОповещения("ОбработкаКомандыОтвет",ЭтотОбъект,Парам);	
    ПоказатьВопрос(Оповещение, "Обновить статус ВСД ?", РежимДиалогаВопрос.ДаНет,  0, КодВозвратаДиалога.Да, ""   );
КонецПроцедуры
