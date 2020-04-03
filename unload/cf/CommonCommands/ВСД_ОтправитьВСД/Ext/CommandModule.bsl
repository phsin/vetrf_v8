﻿
#Область НемодальныеОкна
&НаКлиенте
Процедура ПредупреждениеПользователю(ТекстПредупреждения) Экспорт
 
    Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияПредупреждение",
        ЭтотОбъект);	
 
    ПоказатьПредупреждение(
        Оповещение,
        ТекстПредупреждения, // предупреждение
        0, // (необ.) таймаут в секундах
        "Предупреждение" // (необ.) заголовок
    );
 
КонецПроцедуры
 
&НаКлиенте
Процедура ПослеЗакрытияПредупреждение(Параметры) Экспорт	
КонецПроцедуры
	
&НаКлиенте
Процедура ПослеОтветаНаВопрос(Результат, Парам) Экспорт
 
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПоказатьОповещениеПользователя("Выполняем отправку ВСД",,"Ожидайте...",БиблиотекаКартинок.Информация32);
		
		ПараметрКоманды = Парам.ПараметрКоманды;
		ПараметрыВыполненияКоманды = Парам.ПараметрыВыполненияКоманды;
		ДокСсылка = ПараметрКоманды;
		
		Если ТипЗнч(ДокСсылка) = Тип("ДокументСсылка.ВСД2_Транзакция") ИЛИ
			ТипЗнч(ДокСсылка) = Тип("ДокументСсылка.ВСД2_Производство") ИЛИ
			ТипЗнч(ДокСсылка) = Тип("ДокументСсылка.ВСД2_ЛабораторныеИсследования") ИЛИ
			ТипЗнч(ДокСсылка) = Тип("ДокументСсылка.ВСД2_Инвентаризация") ИЛИ
			ТипЗнч(ДокСсылка) = Тип("ДокументСсылка.ВСД2_ОбъединениеПартий") Тогда 
			
			Если Найти(ПараметрыВыполненияКоманды.Источник.ИмяФормы,"Списка") = 0 Тогда
				ПараметрыВыполненияКоманды.Источник.этаФорма.Закрыть();
			КонецЕсли;
			
			ЗаписатьВСДНаСервере(ДокСсылка);
			
		КонецЕсли;
		
		кб99_ВСД.ОтправитьВСДвГИС(ДокСсылка);
		ПоказатьОповещениеПользователя("Выполнено");
		
	КонецЕсли;
 
КонецПроцедуры
#КонецОбласти

&НаСервере
Процедура ЗаписатьВСДНаСервере(Знач ДокСсылка)
	Докобъект = ДокСсылка.ПолучитьОбъект();
	ДокОбъект.Записать( );	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДокСсылка = ПараметрКоманды;		
	ТекстВопроса = "Отправить ВСД в Меркурий ?";
    Парам = Новый Структура("ПараметрКоманды,ПараметрыВыполненияКоманды",ПараметрКоманды,ПараметрыВыполненияКоманды);
	//ДиалогСВопросом(ТВопроса,Парам);
   	Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопрос", ЭтотОбъект,  Парам);	
    ПоказатьВопрос(Оповещение,
        ТекстВопроса,
        РежимДиалогаВопрос.ДаНет,
        0, // таймаут в секундах
        КодВозвратаДиалога.Да, // (необ.) кнопка по умолчанию
        "" // (необ.) заголовок
    );    
		
КонецПроцедуры
