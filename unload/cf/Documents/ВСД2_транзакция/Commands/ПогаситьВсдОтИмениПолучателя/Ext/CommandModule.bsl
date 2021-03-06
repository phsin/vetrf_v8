﻿
&НаКлиенте
Процедура ОбработкаОтвета(Ответ, Парам) Экспорт
	
	ДокСсылка = Парам.ДокСсылка;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПоказатьОповещениеПользователя("Выполняем гашение ВСД",,"Ожидайте...",БиблиотекаКартинок.Информация32);
		
		кб99_ВСД_Клиент.ПогаситьВсдОтИмениПолучателя( ДокСсылка );
		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДокСсылка = ПараметрКоманды;
	Статус = кб99_ВСД_Общий.НайтиПоследнийЗапрос( ДокСсылка ).СтатусЗапроса;
	Если Статус = "COMPLETED" Тогда 
	
		ТВопроса = "Погасить ВСД от имени Получателя ?";
		Парам = Новый Структура("ДокСсылка", ДокСсылка);
	    Оповещение = Новый ОписаниеОповещения("ОбработкаОтвета", ЭтотОбъект, Парам);	
	    ПоказатьВопрос(Оповещение, ТВопроса, РежимДиалогаВопрос.ДаНет,  0, КодВозвратаДиалога.Да, ""   );
		
	Иначе
		кб99_ВСД.СообщитьИнфо("Статус последнего запросы = "+Статус+" гашение не запущено.");
	КонецЕсли
	
КонецПроцедуры
