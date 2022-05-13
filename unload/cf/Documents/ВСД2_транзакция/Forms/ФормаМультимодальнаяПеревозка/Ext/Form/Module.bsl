﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация = Параметры.Организация;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ДанныеЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура кнСохранить(Команда)
	// Снятие модифицированности, т.к. перед закрытием признак проверяется.
	Модифицированность = Ложь;
	Отказ = Ложь;
	
	Если Перегрузка И НЕ ЗначениеЗаполнено(ТипТранспорта) Тогда
		кб99_ВСД.СообщитьИнфо("Заполните данные по траспортному средству!")
	Иначе
		Результат = кб99_ВСД_Клиент.СтруктураТочкиМультимодальнойПеревозки();
		ЗаполнитьЗначенияСвойств(Результат, ЭтотОбъект);
		ОповеститьОВыборе( Результат );
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция кнЗагрузитьРайонНаСервере()
	
	ПараметрыФункции = кб99_ВСД.ЗагрузитьПараметры( Организация );
	Ответ = кб99_ВСД_Запросы.ИнициализацияХС_ЗагрузитьРайоны( ПараметрыФункции, Регион );
	Результат = Новый Структура;
	Результат.Вставить("ЗаданиеВыполнено", Истина);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура кнЗагрузитьРайон(Команда)
	
	Если ЗначениеЗаполнено(Регион) Тогда
		ПоказатьОповещениеПользователя("Выполняется обработка",,"Ожидайте...",БиблиотекаКартинок.kb99_wrench);
		Результат = кнЗагрузитьРайонНаСервере();
		
		Если Результат.ЗаданиеВыполнено Тогда
			ПоказатьОповещениеПользователя("Выполнено");
		КонецЕсли;
	Иначе
		кб99_ВСД.СообщитьИнфо("Выберите регион!");
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьГородаПоРегионуНаСервере()
	
	ПараметрыФункции = кб99_ВСД.ЗагрузитьПараметры( Организация );
	Ответ = кб99_ВСД_Запросы.ИнициализацияХС_ЗагрузитьГородаПоРегиону( ПараметрыФункции, Регион );
	Результат = Новый Структура;
	Результат.Вставить("ЗаданиеВыполнено", Истина);
	
	Возврат Результат;

КонецФункции

&НаСервере
Функция ЗагрузитьГородаПоРайонуНаСервере()
	
	ПараметрыФункции = кб99_ВСД.ЗагрузитьПараметры( Организация );
	Ответ = кб99_ВСД_Запросы.ИнициализацияХС_ЗагрузитьГородаПоРайону( ПараметрыФункции, Район );
	Результат = Новый Структура;
	Результат.Вставить("ЗаданиеВыполнено", Истина);
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура кнЗагрузитьГорода(Команда)
	
	Если ЗначениеЗаполнено(Район) Тогда
		ПоказатьОповещениеПользователя("Выполняется обработка",,"Ожидайте...",БиблиотекаКартинок.kb99_wrench);
		Результат = ЗагрузитьГородаПоРайонуНаСервере();
		
		Если Результат.ЗаданиеВыполнено Тогда
			ПоказатьОповещениеПользователя("Выполнено");
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(Регион) Тогда
		ПоказатьОповещениеПользователя("Выполняется обработка",,"Ожидайте...",БиблиотекаКартинок.kb99_wrench);
		Результат = ЗагрузитьГородаПоРегионуНаСервере();
		
		Если Результат.ЗаданиеВыполнено Тогда
			ПоказатьОповещениеПользователя("Выполнено");
		КонецЕсли;
	Иначе
		кб99_ВСД.СообщитьИнфо("Укажите Район или Регион для загрузки городов");
	КонецЕсли

КонецПроцедуры

&НаСервере
Функция кнЗагрузитьУлицыНаСервере()
	
	ПараметрыФункции = кб99_ВСД.ЗагрузитьПараметры( Организация );
	
	Если Не ЗначениеЗаполнено(НаселенныйПункт) И Не ЗначениеЗаполнено(Город) 
		И ЗначениеЗаполнено(Регион)Тогда
		_Город = Регион;
	ИначеЕсли ЗначениеЗаполнено(НаселенныйПункт) Тогда
		_Город = НаселенныйПункт;
	ИначеЕсли ЗначениеЗаполнено(Город) Тогда
		_Город = Город;
	Иначе
		_Город = Неопределено;
	КонецЕсли;

	Ответ = кб99_ВСД_Запросы.ИнициализацияХС_ЗагрузитьУлицы(ПараметрыФункции, _Город);
	Результат = Новый Структура;
	Результат.Вставить("ЗаданиеВыполнено", Истина);
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура кнЗагрузитьУлицы(Команда)
	
	Если ЗначениеЗаполнено(Город) Тогда
		ПоказатьОповещениеПользователя("Выполняется обработка",,"Ожидайте...",БиблиотекаКартинок.kb99_wrench);
		Результат = кнЗагрузитьУлицыНаСервере();
		
		Если Результат.ЗаданиеВыполнено Тогда
			ПоказатьОповещениеПользователя("Выполнено");
		КонецЕсли;
	Иначе
		кб99_ВСД.СообщитьИнфо("Выберите город!");
	КонецЕсли
		
КонецПроцедуры

&НаСервере
Функция кнЗагрузитьРегионыНаСервере()
	
	ПараметрыФункции = кб99_ВСД.ЗагрузитьПараметры( Организация );
	Ответ = кб99_ВСД_Запросы.ИнициализацияХС_ЗагрузитьРегионы( ПараметрыФункции, Страна );
	Результат = Новый Структура;
	Результат.Вставить("ЗаданиеВыполнено", Истина);
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура кнЗагрузитьРегионы(Команда)
	
	Если ЗначениеЗаполнено(Страна) Тогда
		ПоказатьОповещениеПользователя("Выполняется обработка",,"Ожидайте...",БиблиотекаКартинок.kb99_wrench);
		Результат = кнЗагрузитьРегионыНаСервере();
		
		Если Результат.ЗаданиеВыполнено Тогда
			ПоказатьОповещениеПользователя("Выполнено");
		КонецЕсли;
	Иначе
		кб99_ВСД.СообщитьИнфо("Выберите страну!");
	КонецЕсли

КонецПроцедуры

&НаСервере
Процедура ПлощадкаПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Площадка) Тогда
		Страна = Площадка.Страна;
		Регион = Площадка.Регион;
		Город = Площадка.Город;
		Улица = Неопределено;
		Дом = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПлощадкаПриИзменении(Элемент)
	ПлощадкаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Функция ЗагрузитьНаселенныйПунктНаСервере()
	
	ПараметрыФункции = кб99_ВСД.ЗагрузитьПараметры( Организация );
	Ответ = кб99_ВСД_Запросы.ИнициализацияХС_ЗагрузитьНаселенныеПунктыПоГороду( ПараметрыФункции, Город );
	Результат = Новый Структура;
	Результат.Вставить("ЗаданиеВыполнено", Ответ);
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура кнЗагрузитьНаселенныйПункт(Команда)
	
	Если ЗначениеЗаполнено(Город) Тогда
		
		ПоказатьОповещениеПользователя("Выполняется обработка",,"Ожидайте...",БиблиотекаКартинок.kb99_wrench);
		Результат = ЗагрузитьНаселенныйПунктНаСервере();
	
		Если Результат.ЗаданиеВыполнено Тогда
			ПоказатьОповещениеПользователя("Выполнено");
		КонецЕсли;

	Иначе
		кб99_ВСД.СообщитьИнфо("Укажите город");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГородНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповещениеОВыбореГорода = Новый ОписаниеОповещения("ВыборГорода", ЭтаФорма, Новый Структура());
	ЗначениеОтбора  = Новый Структура("Владелец", ?(ЗначениеЗаполнено(Район), Район, Регион));
	ПараметрыОткрытия = Новый Структура("Отбор, ЗакрыватьПриВыборе", ЗначениеОтбора, Истина);
	
	ОткрытьФорму("Справочник.ВСД_Город.ФормаВыбора", ПараметрыОткрытия,,,,, ОповещениеОВыбореГорода);

КонецПроцедуры

&НаКлиенте
Процедура ВыборГорода(Результат, ДопПараметры = Неопределено) Экспорт
	
	Город = Результат; 
	ГородПриИзменении("");
	
КонецПроцедуры

&НаКлиенте
Процедура УлицаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповещениеОВыбореУлицы = Новый ОписаниеОповещения("ВыборУлицы", ЭтаФорма, Новый Структура());
	Если Не ЗначениеЗаполнено(НаселенныйПункт) И Не ЗначениеЗаполнено(Город) 
														 И ЗначениеЗаполнено(Регион)Тогда
		Владелец = Регион;
	ИначеЕсли ЗначениеЗаполнено(НаселенныйПункт) Тогда
		Владелец = НаселенныйПункт;
	ИначеЕсли ЗначениеЗаполнено(Город) Тогда
		Владелец = Город;
	Иначе
		Владелец = Неопределено;
	КонецЕсли;

	ЗначениеОтбора  = Новый Структура("Владелец", Владелец);
	ПараметрыОткрытия = Новый Структура("Отбор, ЗакрыватьПриВыборе", ЗначениеОтбора, Истина);
	
	ОткрытьФорму("Справочник.ВСД_Улица.ФормаВыбора", ПараметрыОткрытия,,,,, ОповещениеОВыбореУлицы);

КонецПроцедуры

&НаКлиенте
Процедура ВыборУлицы(Результат, ДопПараметры = Неопределено) Экспорт
	
	Улица = Результат;
    УлицаПриИзменении("");
		
КонецПроцедуры

&НаКлиенте
Процедура СтранаПриИзменении(Элемент)
	
	Регион 		    = Неопределено;
	Район 		    = Неопределено;
	Город  		    = Неопределено;
	НаселенныйПункт = Неопределено;
	Улица  		    = Неопределено;
    Дом				= Неопределено;
	Помещение       = Неопределено;
	Строение        = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура РегионПриИзменении(Элемент)
	
	Район 		    = Неопределено;
	Город  		    = Неопределено;
	НаселенныйПункт = Неопределено;
	Улица  		    = Неопределено;
    Дом				= Неопределено;
	Помещение       = Неопределено;
	Строение        = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура РайонПриИзменении(Элемент)

	Город  		    = Неопределено;
	НаселенныйПункт = Неопределено;
	Улица  		    = Неопределено;
    Дом				= Неопределено;
	Помещение       = Неопределено;
	Строение        = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура НаселенныйПунктПриИзменении(Элемент)

	Улица = Неопределено;
    Дом				= Неопределено;
	Помещение       = Неопределено;
	Строение        = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура ГородПриИзменении(Элемент)
	
	Владелец_ = ?(ЗначениеЗаполнено(Район), Район, Регион);
	
	Если Не кб99_ВСД_Общий.ПроверитьВладельцаСправочника(Город, Владелец_) Тогда
    	Город = Неопределено;
	КонецЕсли;

	НаселенныйПункт = Неопределено;
	Улица  		    = Неопределено;
    Дом				= Неопределено;
	Помещение       = Неопределено;
	Строение        = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура УлицаПриИзменении(Элемент)
	
	Владелец_ = ?(ЗначениеЗаполнено(НаселенныйПункт), НаселенныйПункт, Город);
	
	Если Не кб99_ВСД_Общий.ПроверитьВладельцаСправочника(Улица, Владелец_) Тогда
    	Улица = Неопределено;
	КонецЕсли;
	
	Дом				= Неопределено;
	Помещение       = Неопределено;
	Строение        = Неопределено;

КонецПроцедуры
