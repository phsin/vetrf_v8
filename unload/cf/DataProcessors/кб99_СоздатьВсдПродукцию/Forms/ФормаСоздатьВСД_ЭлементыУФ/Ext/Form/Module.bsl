﻿// Форма Создание Прод элементов
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Попытка
		КопироватьДанныеФормы(ВладелецФормы.Объект, Объект);
	Исключение КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	СтандартнаяОбработка         = Ложь;
	Закрыть(Объект);
КонецПроцедуры
//*******************  Открытие/Закрыте формы окончание

&НаСервере
Функция ЗаполнитьНоменклатуруВТЗ() Экспорт
	
	выбНоменклатура=?(ЗначениеЗаполнено(ВыбГруппаНоменклатуры), ВыбГруппаНоменклатуры, ВыбСписокНоменклатуры);
	
	Объект.ВСДЭлементы.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Номенклатура.Ссылка
	               |ИЗ
	               |	Справочник.Номенклатура КАК Номенклатура
	               |ГДЕ
	               |	Номенклатура.Ссылка В ИЕРАРХИИ(&ВыбНоменклатура)
				   |	И НЕ Номенклатура.ПометкаУдаления
	               |	И Номенклатура.ЭтоГруппа = ЛОЖЬ";

	Запрос.УстановитьПараметр("ВыбНоменклатура",ВыбНоменклатура);	

	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		СтрЭлемент = Объект.ВСДЭлементы.Добавить();
		СтрЭлемент.Номенклатура = выборка.ссылка;
		СтрЭлемент.Продукция_Элемент = кб99_ВСД.Продукция_Элемент_ПолучитьПоНоменклатуре(Выборка.Ссылка); //Проверим на наличие соответствия
		Если ЗначениеЗаполнено(СтрЭлемент.Продукция_Элемент) Тогда 
			СтрЭлемент.Продукция = СтрЭлемент.Продукция_Элемент.Продукция;
			СтрЭлемент.ВидПродукции = СтрЭлемент.Продукция_Элемент.ВидПродукции;
			СтрЭлемент.ЕдиницаИзмерения = СтрЭлемент.Продукция_Элемент.ЕдиницаИзмерения;
			СтрЭлемент.Производитель_Площадка = СтрЭлемент.Продукция_Элемент.Площадка;
			СтрЭлемент.СрокГодности = СтрЭлемент.Продукция_Элемент.СрокГодности;
			СтрЭлемент.ТермическиеУсловияПеревозки = СтрЭлемент.Продукция_Элемент.ТермическиеУсловияПеревозки;
			Стрэлемент.GUID = СтрЭлемент.Продукция_Элемент.GUID;
		Иначе
			СтрЭлемент.Продукция = ВыбПродукция;
			СтрЭлемент.ВидПродукции = ВыбВидПродукции;
			СтрЭлемент.ЕдиницаИзмерения = ВыбЕдиницаИзмерения;			
			СтрЭлемент.СрокГодности = ВыбСрокГодности;
			СтрЭлемент.ТермическиеУсловияПеревозки = ВыбТермическиеУсловия;
			СтрЭлемент.Производитель_Площадка = ВыбПлощадкаПроизводитель;
		КонецЕсли;		
		
	КонецЦикла;	
	
	Возврат "";
	
КонецФункции

&НаСервере
Функция СоздатьИзменитьПродукцияЭлемент1С(ВыбСтрЭлемент)
	
	// Берем данные из ТЧ - Не все м.б. одинаковые, пользователь поправил например
	Если значениеЗаполнено(ВыбСтрЭлемент.Продукция_Элемент) Тогда
		НовПродукцияЭлемент = ВыбСтрЭлемент.Продукция_Элемент.ПолучитьОбъект();	
	Иначе
		НовПродукцияЭлемент = Справочники.ВСД_Продукция_Элемент.СоздатьЭлемент();	
	КонецЕсли;
	
	НовПродукцияЭлемент.Продукция = ВыбСтрЭлемент.Продукция;
	НовПродукцияЭлемент.ВидПродукции = ВыбСтрЭлемент.ВидПродукции;
	НовПродукцияЭлемент.Наименование = ВыбСтрЭлемент.Номенклатура.Наименование;
	НовПродукцияЭлемент.Площадка = ВыбСтрЭлемент.Производитель_Площадка;
	НовПродукцияЭлемент.ЕдиницаИзмерения = ВыбСтрЭлемент.ЕдиницаИзмерения;
	НовПродукцияЭлемент.ТермическиеУсловияПеревозки = ВыбСтрЭлемент.ТермическиеУсловияПеревозки;
	НовПродукцияЭлемент.СрокГодности = ВыбСтрЭлемент.СрокГодности;	
	НовПродукцияЭлемент.Записать();
	
	Возврат НовПродукцияЭлемент.Ссылка;
	
КонецФункции

&НаСервере
Функция СоздатьВСДЭлементы() Экспорт
	
	// Создает элемент справочника ВСД_Продукция_Элемент при отсутствии
	// Устанавливает Соответствие с Номенклатурой
	// Создает в Меркурии Продукццию
	Если (Не ЗначениеЗаполнено(Объект.Отправитель_Площадка)) или (Не ЗначениеЗаполнено(Объект.Организация)) Тогда
		кб99_ВСД.СообщитьИнфо("Укажите Организацию и Площадку");
		Возврат "";
	КонецЕсли;
	
	ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Объект.Организация );	
	
	Для Каждого СтрЭлемент Из Объект.ВСДЭлементы Цикл
		Если (НЕ Стрэлемент.Отметка) или (ЗначениеЗаполнено(СтрЭлемент.GUID)) Тогда
			Продолжить; // Уже создан в Меркурий
		КонецЕсли;
		// Юзер наколбасил в ТЧ
		Если НЕ ЗначениеЗаполнено(СтрЭлемент.Продукция) или
			НЕ ЗначениеЗаполнено(СтрЭлемент.ВидПродукции) или
			НЕ ЗначениеЗаполнено(СтрЭлемент.Номенклатура) или 
			НЕ ЗначениеЗаполнено(СтрЭлемент.ЕдиницаИзмерения)	Тогда
				кб99_ВСД.СообщитьИнфо("Обязательные реквизиты для "+СтрЭлемент.Номенклатура+" в строке "+СтрЭлемент.номерСтроки+" не заполнены !!!");
				Продолжить;
			Продолжить;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрЭлемент.Продукция_Элемент) Тогда
			СтрЭлемент.Продукция_Элемент = СоздатьИзменитьПродукцияЭлемент1С(СтрЭлемент);
			Если НЕ ЗначениеЗаполнено(СтрЭлемент.Продукция_Элемент) Тогда
				кб99_ВСД.СообщитьИнфо("Что-то пошло не так. Не создался Продукция Элемент для "+СтрЭлемент.Номенклатура);
				Продолжить;
			КонецЕсли;
			кб99_ВСД.Установить_Соответствие_ВСД_Продукция_Элемент(СтрЭлемент.Номенклатура,СтрЭлемент.Продукция_Элемент);
		КонецЕсли;
		
		Попытка 
			кб99_ВСД_Запросы.Продукция_Элемент_Изменить( ПараметрыОрганизации, СтрЭлемент.Продукция_Элемент,"CREATE");
			СтрЭлемент.GUID = СтрЭлемент.Продукция_Элемент.GUID;
		Исключение
			кб99_ВСД.СообщитьИнфо(ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
	
КонецФункции

&НаСервере
Функция ИзменитьВСДЭлементы(ИмяКоманды = "UPDATE") Экспорт
	
	// Создает элемент справочника ВСД_Продукция_Элемент при отсутствии
	// Устанавливает Соответствие с Номенклатурой
	// Создает в Меркурии Продукццию
	Если (Не ЗначениеЗаполнено(Объект.Отправитель_Площадка)) или (Не ЗначениеЗаполнено(Объект.Организация)) Тогда
		кб99_ВСД.СообщитьИнфо("Укажите Организацию и Площадку");
		Возврат "";
	КонецЕсли;
	
	ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( объект.Организация );
	
	Для Каждого СтрЭлемент Из Объект.ВСДЭлементы Цикл
		Если НЕ Стрэлемент.Отметка Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ(ЗначениеЗаполнено(СтрЭлемент.GUID)) Тогда
			кб99_ВСД.СообщитьИнфо("В строке "+стрЭлемент.НомерСтроки+" нет элемента для изменения или удаления в Меркурий, пропускаю.");
			Продолжить;
		КонецЕсли;
		
		Если Не(ИмяКоманды = "DELETE") Тогда
			// Юзер наколбасил в ТЧ
			Если НЕ ЗначениеЗаполнено(СтрЭлемент.Продукция) или
				НЕ ЗначениеЗаполнено(СтрЭлемент.ВидПродукции) или
				НЕ ЗначениеЗаполнено(СтрЭлемент.Номенклатура) или 
				НЕ ЗначениеЗаполнено(СтрЭлемент.ЕдиницаИзмерения)	Тогда
					кб99_ВСД.СообщитьИнфо("Обязательные реквизиты не заполнены !!!");
					Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если ИмяКоманды = "UPDATE"  Тогда
			// запишем в спр то, что пользователь поставил в ТЧ
			СтрЭлемент.Продукция_Элемент = СоздатьИзменитьПродукцияЭлемент1С(СтрЭлемент);
		КонецЕсли;
		
		Попытка 
			кб99_ВСД_Запросы.Продукция_Элемент_Изменить( ПараметрыОрганизации, СтрЭлемент.Продукция_Элемент, ИмяКоманды );
			СтрЭлемент.GUID = СтрЭлемент.Продукция_Элемент.GUID;
		Исключение
			кб99_ВСД.СообщитьИнфо("Что-то пошло не так. Не удалось создать в Меркурий "+СтрЭлемент.Продукция_Элемент);
			кб99_ВСД.СообщитьИнфо(ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
	
КонецФункции

// события на форме
&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Объект.Организация );
	кб99_ВСД.ЗагрузитьПараметрыВОбработку( Объект, ПараметрыОрганизации ); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура Отправитель_ПлощадкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// Отбор по ХС включим
	ГУИДХСдляОтбора = кб99_ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(Объект.Отправитель_ХозСубъект,"GUID");
	ГУИДХСдляОтбора = ?(ЗначениеЗаполнено(ГУИДХСдляОтбора),ГУИДХСдляОтбора,"****");
	
	СтандартнаяОбработка = Ложь;
	ЗначениеОтбора = Новый Структура("GuidХозСубъекта", ГУИДХСдляОтбора);
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина,ЗначениеОтбора);	
	ОткрытьФорму("Справочник.ВСД_Площадка.ФормаВыбора", ПараметрыПодбора, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Отправитель_ПлощадкаПриИзменении(Элемент)
	Объект.ВСДЭлементы.Очистить();
	объект.Отгрузки.Очистить();
	Объект.Партии.Очистить();
	объект.ВСДВходящие.Очистить();
КонецПроцедуры

// на форме действия
&НаКлиенте
Процедура кнОтметитьВсе(Команда)
	
	Для Каждого стр Из Объект.ВСДЭлементы Цикл
		Если ЗначениеЗаполнено(стр.GUID) Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ(стр.Отметка) Тогда 
			стр.Отметка = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура кнСнятьОтметки(Команда)
	Для Каждого стр Из Объект.ВСДЭлементы Цикл
		стр.отметка = Ложь;	
	КонецЦикла
КонецПроцедуры

&НаКлиенте
Процедура кнЗаполнить(Команда)
	
	выбНоменклатура=?(ЗначениеЗаполнено(ВыбГруппаНоменклатуры), ВыбГруппаНоменклатуры, ВыбСписокНоменклатуры);

	Если (НЕ ЗначениеЗаполнено(ВыбНоменклатура)) или
		(НЕ ЗначениеЗаполнено(ЭтаФорма.ВыбПродукция)) или
		(НЕ ЗначениеЗаполнено(ЭтаФорма.ВыбВидПродукции)) или
		(НЕ ЗначениеЗаполнено(ЭтаФорма.ВыбЕдиницаИзмерения)) или   
		(НЕ ЗначениеЗаполнено(ЭтаФорма.ВыбСрокГодности))  Тогда
			
		кб99_ВСД.СообщитьИнфо("Не все параметры для заполнения указаны");
		Возврат;
	КонецЕсли;
	ЗаполнитьНоменклатуруВТЗ();
	Элементы.ГрСтраницы.ТекущаяСтраница = Элементы.ГрТаблица;

КонецПроцедуры

&НаКлиенте
Процедура кнСоздатьОтвет(Ответ,Парам) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Состояние("Выполняем запрос ",,"Ожидайте...",БиблиотекаКартинок.kb99_wrench);
		СоздатьВСДЭлементы();
		ПоказатьОповещениеПользователя("Выполнено");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура кнСоздать(Команда)
	
	ТекстВопроса = "Будут созданы элементы справочника ВСД_Продукция_Элемент
	|Установлено соответствие с Номенклатурой
	|Отправлен запрос в Меркурий на создание Наименований продукции
	|по площадке "+Объект.Отправитель_Площадка;
    Оповещение = Новый ОписаниеОповещения("кнСоздатьОтвет",ЭтаФорма);	
    ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,  0, КодВозвратаДиалога.Да, ""   );
	
КонецПроцедуры

&НаКлиенте
Процедура кнИзменитьОтвет(Ответ,Парам) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Состояние("Выполняем запрос ",,"Ожидайте...",БиблиотекаКартинок.kb99_wrench);
    	ИзменитьВСДЭлементы();
		ПоказатьОповещениеПользователя("Выполнено");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура кнИзменить(Команда)
	
	ТекстВопроса = "Будет отправлен запрос в Меркурий на изменение выбранной продукции
	|по площадке "+Объект.Отправитель_Площадка;
    Оповещение = Новый ОписаниеОповещения("кнИзменитьОтвет",ЭтаФорма);	
    ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,  0, КодВозвратаДиалога.Да, "");
	
КонецПроцедуры

&НаКлиенте
Процедура кнУдалитьОтвет(Ответ,Парам) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Состояние("Выполняем запрос ",,"Ожидайте...",БиблиотекаКартинок.kb99_wrench);
    	ИзменитьВСДЭлементы("DELETE");
		ПоказатьОповещениеПользователя("Выполнено");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура кнУдалить(Команда)
	ТекстВопроса = "Будет отправлен запрос в Меркурий на Удаление выбранной продукции
	|по площадке "+Объект.Отправитель_Площадка;
    Оповещение = Новый ОписаниеОповещения("кнУдалитьОтвет",ЭтаФорма);	
    ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,  0, КодВозвратаДиалога.Да, ""   );    
КонецПроцедуры

&НаСервере
Функция ПолучитьСведенияОПродЭлементе( ВыбНоменклатура ) 	
	
	НайденЭлемент = кб99_ВСД.Продукция_Элемент_ПолучитьПоНоменклатуре( ВыбНоменклатура );
	СведенияОЭлементе = Новый Структура;
	СведенияОЭлементе.Вставить("Продукция_Элемент",НайденЭлемент);
	СведенияОЭлементе.Вставить("Продукция",НайденЭлемент.Продукция);
	СведенияОЭлементе.Вставить("ВидПродукции",НайденЭлемент.ВидПродукции);
	СведенияОЭлементе.Вставить("ЕдиницаИзмерения",НайденЭлемент.ЕдиницаИзмерения);
	СведенияОЭлементе.Вставить("СрокГодности",НайденЭлемент.СрокГодности);
	СведенияОЭлементе.Вставить("ТермическиеУсловияПеревозки",НайденЭлемент.ТермическиеУсловияПеревозки);
	СведенияОЭлементе.Вставить("GUID",НайденЭлемент.GUID);
	
	Возврат  СведенияОЭлементе;
	
КонецФункции

&НаКлиенте
Процедура ВСДЭлементыНоменклатураПриИзменении(Элемент)
	
	ПродЭлемент = ПолучитьСведенияОПродЭлементе(Элемент.Родитель.ТекущиеДанные.Номенклатура);
	Элемент.Родитель.ТекущиеДанные.Продукция_Элемент = ПродЭлемент.Продукция_Элемент;
	Если ЗначениеЗаполнено(Элемент.Родитель.ТекущиеДанные.Продукция_Элемент) Тогда 
		Элемент.Родитель.ТекущиеДанные.Продукция = ПродЭлемент.Продукция;
		Элемент.Родитель.ТекущиеДанные.ВидПродукции = ПродЭлемент.ВидПродукции;	
		Элемент.Родитель.ТекущиеДанные.ЕдиницаИзмерения = ПродЭлемент.ЕдиницаИзмерения;
		Элемент.Родитель.ТекущиеДанные.СрокГодности = ПродЭлемент.СрокГодности;
		Элемент.Родитель.ТекущиеДанные.ТермическиеУсловияПеревозки = ПродЭлемент.ТермическиеУсловияПеревозки;
		Элемент.Родитель.ТекущиеДанные.GUID = ПродЭлемент.GUID;
	Иначе
		Элемент.Родитель.ТекущиеДанные.Продукция = ВыбПродукция;
		Элемент.Родитель.ТекущиеДанные.ВидПродукции = ВыбВидПродукции;
		Элемент.Родитель.ТекущиеДанные.ЕдиницаИзмерения = ВыбЕдиницаИзмерения;
		Элемент.Родитель.ТекущиеДанные.СрокГодности = ВыбСрокГодности;
		Элемент.Родитель.ТекущиеДанные.ТермическиеУсловияПеревозки = ВыбТермическиеУсловия;
		Элемент.Родитель.ТекущиеДанные.GUID = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВСДЭлементыПродукцияПриИзменении(Элемент)
	Элемент.Родитель.ТекущиеДанные.ВидПродукции = "";
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Организация = кб99_ВСД_Общий.ПолучитьОрганизациюПоУмолчанию();	
	ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Объект.Организация );		
	кб99_ВСД.ЗагрузитьПараметрыВОбработку( Объект, ПараметрыОрганизации ); 			
	
	Попытка			
		Для Каждого элемент Из Параметры.МассивЗначений цикл
			ТекСтрока = Объект.ВСДЭлементы.Добавить();
			ТекСтрока.Продукция_Элемент = Элемент;
			Если ЗначениеЗаполнено( ТекСтрока.Продукция_Элемент) Тогда 
				ТекСтрока.Продукция = ТекСтрока.Продукция_Элемент.Продукция;
				ТекСтрока.ВидПродукции = ТекСтрока.Продукция_Элемент.ВидПродукции;
				ТекСтрока.ЕдиницаИзмерения = ТекСтрока.Продукция_Элемент.ЕдиницаИзмерения;
				ТекСтрока.СрокГодности = ТекСтрока.Продукция_Элемент.СрокГодности;
				ТекСтрока.ТермическиеУсловияПеревозки = ТекСтрока.Продукция_Элемент.ТермическиеУсловияПеревозки;
				ТекСтрока.GUID = ТекСтрока.Продукция_Элемент.GUID;
			КонецЕсли;
		КонецЦикла;
	Исключение КонецПопытки;

КонецПроцедуры


