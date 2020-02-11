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

//&НаСервере
//Функция ОтправитьДокументНаСервере( ДокСсылка )
//		//ИдентификаторЗадания = Неопределено;
//		//
//		//// нет в УТ 11 10.3.4
//		////ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
//		////ПараметрыВыполнения.ОжидатьЗавершение = 0;
//		////ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Ветис запрос продукции'");
//		////ПараметрыПроцедуры = Новый Структура;
//		//////ПараметрыПроцедуры.Вставить("Тип", А);		
//		////Результат = ДлительныеОперации.ВыполнитьВФоне("кб99_ВСД_Запросы.ИнициализацияХС_ЗагрузитьПродукцию_Все", ПараметрыПроцедуры, ПараметрыВыполнения);
//		//
//		//// Устарела. Следует использовать ВыполнитьВФоне.
//		//ПараметрыФункции = Новый Структура;
//		//ПараметрыФункции.Вставить("ДокСсылка", ДокСсылка );
//		//
//		//НаименованиеЗадания = НСтр("ru = 'Ветис отправка запроса'");
//		//Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне( Новый УникальныйИдентификатор, 
//		//	"кб99_ВСД_Запросы.ОтправитьВСДвГИС",
//		//	ПараметрыФункции,
//		//	НаименованиеЗадания);
//		//
//		////результат обработки
//		////АдресХранилища       = Результат.АдресХранилища;
//		//
//		////для получения сообщений
//		////ИдентификаторЗадания = Результат.ИдентификаторЗадания;
//		
//		ПараметрыФункции = Новый Структура();
//		ПараметрыФункции.Вставить("ДокСсылка",ДокСсылка);
//		кб99_ВСД_Запросы.ОтправитьВСДвГИС(ПараметрыФункции, Новый УникальныйИдентификатор);
//		
//КонецФункции
	
&НаКлиенте
Процедура ПослеОтветаНаВопрос(Результат, Парам) Экспорт
 
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПараметрКоманды = Парам.ПараметрКоманды;
		ПараметрыВыполненияКоманды = Парам.ПараметрыВыполненияКоманды;
		ДокСсылка = ПараметрКоманды;
		Если кб99_ВСД.ЕстьреквизитОбъекта("Статус",ДокСсылка) Тогда
			ЭтоОбъектВСД = Истина;
		Иначе
			ЭтоОбъектВСД = Ложь;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя("Выполняем отправку ВСД",,"Ожидайте...",БиблиотекаКартинок.Информация32);
		
		Если ЭтоОбъектВСД Тогда
			//Запишем, закроем форму, если это не форма списка
			Если Найти(ПараметрыВыполненияКоманды.Источник.ИмяФормы,"Списка") = 0 Тогда
				ПараметрыВыполненияКоманды.Источник.этаФорма.Закрыть();
			КонецЕсли;
			ЗаписатьВСДНаСервере(ДокСсылка);
		КонецЕсли;	
		//ОтправитьДокументНаСервере(ДокСсылка);
		кб99_ВСД.ОтправитьВСДвГИС(ДокСсылка);
		
		ПоказатьОповещениеПользователя("Выполнено");
	КонецЕсли;
 
КонецПроцедуры
#КонецОбласти

&НаСервере
Процедура ЗаписатьВСДНаСервере(Знач ДокСсылка)
	Докобъект = ДокСсылка.ПолучитьОбъект();
	//ДокОбъект.ПроверитьЗаполнение();
	ДокОбъект.Записать( РежимЗаписиДокумента.Проведение );	
КонецПроцедуры

&НаСервере
Функция ПроверитьЗаполнениеВСДНаСервере(Знач ДокСсылка)
	Докобъект = ДокСсылка.ПолучитьОбъект();
	Рез = ДокОбъект.ПроверитьЗаполнение();
	Возврат Рез;
КонецФункции


&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДокСсылка = ПараметрКоманды;//ПараметрыВыполненияКоманды.Источник.Объект; ПараметрыВыполненияКоманды.Источник.ИмяФормы  // = Данные формы.Структура
	Если кб99_ВСД.ЕстьреквизитОбъекта("Статус",ДокСсылка) Тогда
		Если СокрЛП(кб99_ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(ДокСсылка,"Статус")) = "COMPLETED" Тогда
			//Предупреждение("Документ уже отправлен");
			ПредупреждениеПользователю("Документ уже отправлен");
			Возврат;
		КонецЕсли;
//		ЭтоОбъектВСД = Истина;
//	Иначе
//		ЭтоОбъектВСД = Ложь;
	КонецЕсли;
	//Проверить - не помечен ли на удаление
	
	//ДокСсылка.ПолучитьОбъект().Записать( РежимЗаписиДокумента.Проведение );
	//ЗаписатьВСДНаСервере(ДокСсылка);
	Если НЕ ПроверитьЗаполнениеВСДНаСервере( ДокСсылка ) Тогда 
		ПредупреждениеПользователю("Документ не заполнен");
		Возврат;
	КонецЕсли; 
	
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
	
//Перенесено в вопрос	ПоказатьОповещениеПользователя("Выполняем отправку ВСД",,"Ожидайте...",БиблиотекаКартинок.Информация32);
	// Если из журнала отправляем - закрывать его форму не нужно
	// ПараметрыВыполненияКоманды.Источник.ИмяФормы    есть ФормаСписка
//	Если ЭтоОбъектВСД Тогда
		//Запишем, закроем форму, если это не форма списка
//		Если Найти(ПараметрыВыполненияКоманды.Источник.ИмяФормы,"Списка") = 0 Тогда
//			ПараметрыВыполненияКоманды.Источник.этаФорма.Закрыть();
//		КонецЕсли;
//		ЗаписатьВСДНаСервере(ДокСсылка);
//	КонецЕсли;
	
//	ВСД.ОтправитьВСДвГИС(ДокСсылка);
//	ПоказатьОповещениеПользователя("Выполнено");
	
КонецПроцедуры
