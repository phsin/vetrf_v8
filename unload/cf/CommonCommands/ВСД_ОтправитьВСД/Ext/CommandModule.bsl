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
		
		Если ТипЗнч(ДокСсылка) = Тип("ДокументСсылка.ВСД2_Транзакция")ИЛИ
			ТипЗнч(ДокСсылка) = Тип("ДокументСсылка.ВСД2_Производство") Тогда
			Если ПроверитьЗаполнениеВСДНаСервере(ДокСсылка) Тогда
				кб99_ВСД.ОтправитьВСДвГИС(ДокСсылка);
			Иначе
				Возврат;
			КонецЕсли;
		Иначе
			кб99_ВСД.ОтправитьВСДвГИС(ДокСсылка);
		КонецЕсли;
		
		ПоказатьОповещениеПользователя("Выполнено");
	КонецЕсли;
 
КонецПроцедуры
#КонецОбласти

&НаСервере
Процедура ЗаписатьВСДНаСервере(Знач ДокСсылка)
	Докобъект = ДокСсылка.ПолучитьОбъект();
	ДокОбъект.Записать( );	
КонецПроцедуры

&НаСервере
Функция ПроверитьЗаполнениеВСДНаСервере(Знач ДокСсылка)
	
	Организация = кб99_ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере( ДокСсылка, "Организация" );
	ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Организация );
	Докобъект = ДокСсылка.ПолучитьОбъект();
	Рез = ДокОбъект.ПроверитьЗаполнение();
	тчПартии = ?(ТипЗнч(ДокСсылка) = Тип("ДокументСсылка.ВСД2_Транзакция"),ДокОбъект.Товары, ДокОбъект.ПартииСписания); 
	ДокОбъект.Комментарий = "";
	
	Если ПараметрыОрганизации["ПарамКонтроллироватьСрокГодностиПриОтправке"] Тогда 
		Для Каждого Стр Из тчПартии Цикл
			ДатаСрокГодности2 = кб99_ВСД_Запросы.СтрокаВДатаВремя(Стр.Партия.ДатаСрокГодности2);
			ДатаСрокГодности1 = кб99_ВСД_Запросы.СтрокаВДатаВремя(Стр.Партия.ДатаСрокГодности1);
			Если ЗначениеЗаполнено(ДатаСрокГодности2) Тогда
				Если ДатаСрокГодности2 - ПараметрыОрганизации["СрокГодностиДней"]*86400 <= ТекущаяДата() Тогда
					кб99_ВСД.СообщитьИнфо("Выбранна просроченная партия по срокам годности2 (менее "+ ПараметрыОрганизации["СрокГодностиДней"] +" дней до окончания срока) в строке "+Стр.НомерСтроки+"!", ДокСсылка);
					Рез = Ложь;
					ДокОбъект.Комментарий  = ДокОбъект.Комментарий +  "В строке "+Стр.НомерСтроки+ " выбранна просроченная партия по срокам годности2 (менее "+ ПараметрыОрганизации["СрокГодностиДней"] +" дней до окончания срока)!";
				Иначе
					Если Рез = Истина Тогда
						Рез = Истина;
					КонецЕсли;
				КонецЕсли;
			Иначе
				Если ДатаСрокГодности1 - ПараметрыОрганизации["СрокГодностиДней"]*86400 <= ТекущаяДата() Тогда
					кб99_ВСД.СообщитьИнфо("Выбранна просроченная партия по срокам годности (менее "+ ПараметрыОрганизации["СрокГодностиДней"] +" дней до окончания срока) в строке "+Стр.НомерСтроки + "!", ДокСсылка);
					Рез = Ложь;
					ДокОбъект.Комментарий  = ДокОбъект.Комментарий +  "В строке "+Стр.НомерСтроки+ " выбранна просроченная партия по срокам годности (менее "+ ПараметрыОрганизации["СрокГодностиДней"] +" дней до окончания срока)!";
				Иначе
					Если Рез = Истина Тогда
						Рез = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		ДокОбъект.Записать();
	КонецЕсли;
	
	Возврат Рез;

КонецФункции


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
