﻿#Область НемодальныеОкна
&НаКлиенте
Процедура ПредупреждениеПользователю(ТекстПредупреждения) Экспорт
    Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияПредупреждения", ЭтаФорма);	
    ПоказатьПредупреждение( Оповещение,   ТекстПредупреждения,   0,   "Предупреждение" );
КонецПроцедуры
 
&НаКлиенте
Процедура ПослеЗакрытияПредупреждения(Параметры) Экспорт	
КонецПроцедуры

#КонецОбласти


&НаКлиенте
Функция СтруктураОтбораПартий( Выб_Продукция_Элемент = Неопределено, Выб_Получатель_Площадка, Выб_Получатель_ХозСубъект) Экспорт
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Получатель_Площадка", Выб_Получатель_Площадка);
	СтруктураОтбора.Вставить("Получатель_ХозСубъект", Выб_Получатель_ХозСубъект);
	СтруктураОтбора.Вставить("ПометкаУдаления", Ложь);
	
	Если ЗначениеЗаполнено(Выб_Продукция_Элемент) Тогда 
		СтруктураОтбора.Вставить("Продукция_Элемент", Выб_Продукция_Элемент);
	КонецЕсли;
	
	Возврат СтруктураОтбора;
	
КонецФункции

//После заполнения сюда сразу попадаем
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Ключ.Пустая() Тогда //ЭтоНовый   https://helpf.pro/faq83/view/1829.html
		
	КонецЕсли;
	Если Объект.Номер = "" Тогда  // тоже новый
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	СписокПараметров = ВСД.ЗагрузитьПараметры( Объект.Организация );
	Объект.Владелец_ХозСубъект = СписокПараметров["Отправитель_ХозСубъект"];
	Объект.Владелец_Площадка = СписокПараметров["Отправитель_Площадка"];
	//АвтоЗаписьВСДСоответствия = СписокПараметров["АвтоЗаписьВСДСоответствия"];	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Параметры.Ключ.Пустая() Тогда
		Объект.Статус = "";
		Объект.Комментарий="";
		Объект.applicationID = "";
		Объект.Запросы.Очистить();
		Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
       		Объект.Организация   =  ВСД_Общий.ПолучитьОрганизациюПоУмолчанию();
			ОрганизацияПриИзменении("");
		КонецЕсли;
	КонецЕсли;
	Если СокрЛП(Объект.Статус) = "COMPLETED" Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;	
	КонецЕсли;
КонецПроцедуры

// *******************Шапка
&НаКлиенте
Процедура Владелец_ХозСубъектПриИзменении(Элемент)
	Объект.Владелец_Площадка = "";
КонецПроцедуры

&НаКлиенте
Процедура Владелец_ПлощадкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//// Отбор по ХС включим
	//ГУИДХСдляОтбора = ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(Объект.Владелец_ХозСубъект,"GUID");
	//ВыбратьПлощадкиПоХС(Элемент,ГУИДХСдляОтбора);
	
	ЗначениеОтбора = Новый Структура("ХозСубъект", Объект.Владелец_ХозСубъект);
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина,ЗначениеОтбора);	
	ОткрытьФорму("Справочник.ВСД_Площадка.ФормаВыбора", ПараметрыПодбора, Элемент);	
	
КонецПроцедуры

//** ТЧ Продукция
&НаСервере
Функция ПолучитьРеквизитыЭлемента(ВыбЭлемент)
	Рез = Новый Структура;
	Рез.Вставить("Продукция",ВыбЭлемент.Продукция);
	Рез.Вставить("ВидПродукции",ВыбЭлемент.ВидПродукции);
	Рез.Вставить("Наименование",ВыбЭлемент.Наименование);
	Рез.Вставить("ЕдиницаИзмерения",ВыбЭлемент.ЕдиницаИзмерения);
	Рез.Вставить("СрокГодности",ВыбЭлемент.СрокГодности);
	Возврат Рез;
КонецФункции

&НаСервере
Функция ПолучитьРеквизитыПартии(ВыбЭлемент)
	Рез = Новый Структура;
	Рез.Вставить("Продукция",ВыбЭлемент.Продукция);
	Рез.Вставить("ВидПродукции",ВыбЭлемент.ВидПродукции);
	Рез.Вставить("Продукция_Элемент",ВыбЭлемент.Продукция_Элемент);
	Рез.Вставить("НаименованиеПродукции",ВыбЭлемент.Наименование);
	Рез.Вставить("ЕдиницаИзмерения",ВыбЭлемент.ЕдиницаИзмерения);
	Рез.Вставить("ДатаСрокГодности1",ВыбЭлемент.ДатаСрокГодности1);
	Рез.Вставить("ДатаИзготовления1",ВыбЭлемент.ДатаИзготовления1);
	Рез.Вставить("ДатаСрокГодности2",ВыбЭлемент.ДатаСрокГодности2);
	Рез.Вставить("ДатаИзготовления2",ВыбЭлемент.ДатаИзготовления2);
	Рез.Вставить("Количество",ВыбЭлемент.Количество);
	Рез.Вставить("Производитель_площадка",ВыбЭлемент.Производитель_площадка);
	
	ПараметрыОрганизации = ВСД.ЗагрузитьПараметры( Объект.Организация );
	Рез.Вставить("Производитель_Страна", ПараметрыОрганизации["Страна"] );
	Возврат Рез;
КонецФункции

&НаКлиенте
Процедура ЗаполнитьУпаковки_и_Маркировки(СтрокаТЧ)
	Если ЗначениеЗаполнено(СтрокаТЧ.Партия) Тогда
		//Считать из Партии		
		
	Иначе
		//очистить
		
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыСтрокиНаСервере(СтрокаТЧ)
	
	Если ЗначениеЗаполнено(СтрокаТЧ.Партия) Тогда
		ЗаполнитьЗначенияСвойств( СтрокаТЧ, СтрокаТЧ.Партия)		
	Иначе
		ЗаполнитьЗначенияСвойств( СтрокаТЧ, СтрокаТЧ.Продукция_Элемент)
	КонецЕсли;
	ПараметрыОрганизации = ВСД.ЗагрузитьПараметры( Объект.Организация );
	СтрокаТЧ.Производитель_Страна = ПараметрыОрганизации["Страна"];
	
КонецПроцедуры

//Заполнение формы клиента
&НаКлиенте
Процедура ЗаполнитьРеквизитыСтрокиПродукция( СтрокаТЧ )
	
	Если ЗначениеЗаполнено(СтрокаТЧ.Партия) Тогда
		ДанныеПартии = ПолучитьРеквизитыПартии(СтрокаТЧ.Партия);
		ЗаполнитьЗначенияСвойств( СтрокаТЧ, ДанныеПартии );		
	Иначе
		ПродЭлемент = ПолучитьРеквизитыЭлемента(СтрокаТЧ.Продукция_Элемент);	
		ЗаполнитьЗначенияСвойств( СтрокаТЧ, ПродЭлемент );
	КонецЕсли;
	
	ЗаполнитьУпаковки_и_Маркировки(СтрокаТЧ);
КонецПроцедуры

&НаКлиенте
Процедура ПродукцияПриАктивизацииСтроки(Элемент)
	// Фильтруем Уровни Упаковки
	к=0;	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		ЭтаФорма.Элементы.УровниУпаковки.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции", 0);//.СтрокаПродукции.Установить(0);
	Иначе
		ЭтаФорма.Элементы.УровниУпаковки.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции", Элемент.ТекущиеДанные.НомерСтроки);//.СтрокаПродукции.Установить(Элемент.ТекущиеДанные.НомерСтроки);
		ЭтаФорма.Элементы.Маркировка.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции",Элемент.ТекущиеДанные.НомерСтроки);
	КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ПродукцияПередУдалением(Элемент, Отказ)
	к = 0;
	// Удалить связанные уровни упаковки и маркировки
	//ЖД  - ту косяк - все строки ниже удаленной сдвигаются - вот незадача !!!!
	// а у нас связь по № строки тч. Товары  - нужно что то уникальное
	// сдвиг строк в ТЧ Товары стандартный - аналогичный косяк !!!
	
	СтруктураДляПоиска = Новый Структура("СтрокаПродукции", Элемент.ТекущиеДанные.НомерСтроки); 
	//ТабличнаяЧастьДок = ОбъектДок.Товары; 
	//Получаем список строк соответсвтвующих отбору, и перебором удаляем.
	МассивПустыхСтрок = Объект.Маркировка.НайтиСтроки(СтруктураДляПоиска); 
	Для Каждого Строка Из МассивПустыхСтрок Цикл 
		Объект.Маркировка.Удалить(Строка); 
	КонецЦикла; 
	МассивПустыхСтрок = Объект.УровниУпаковки.НайтиСтроки(СтруктураДляПоиска); 
	Для Каждого Строка Из МассивПустыхСтрок Цикл 
		Объект.УровниУпаковки.Удалить(Строка); 
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ПродукцияНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элемент.Родитель.ТекущиеДанные;
	СтрокаТабличнойЧасти.Продукция_Элемент = ВСД.Получить_ВСД_Продукция_Элемент( СтрокаТабличнойЧасти.Номенклатура );
	СтрокаТабличнойЧасти.Партия = ВСД.ВыбратьПартию(СтрокаТабличнойЧасти.Продукция_Элемент, Объект.Владелец_Площадка, Объект.Владелец_ХозСубъект);
	ЗаполнитьРеквизитыСтрокиПродукция( СтрокаТабличнойЧасти  );	
КонецПроцедуры

&НаКлиенте
Процедура ПродукцияПродукция_ЭлементПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элемент.Родитель.ТекущиеДанные;
	ПродЭлемент = ПолучитьРеквизитыЭлемента(СтрокаТабличнойЧасти.Продукция_Элемент);	
	СтрокаТабличнойЧасти.Продукция = ПродЭлемент.Продукция ;
	СтрокаТабличнойЧасти.ВидПродукции =  ПродЭлемент.ВидПродукции;
	СтрокаТабличнойЧасти.НаименованиеПродукции =  ПродЭлемент.Наименование;
	СтрокаТабличнойЧасти.ЕдиницаИзмерения =ПродЭлемент.ЕдиницаИзмерения;
	
//	СтрокаТабличнойЧасти.Партия = ВСД.ВыбратьПартию(СтрокаТабличнойЧасти.Продукция_Элемент, Объект.Владелец_Площадка, Объект.Владелец_ХозСубъект);
//	ЗаполнитьРеквизитыСтрокиПродукция(СтрокаТабличнойЧасти,Элемент);
//	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) и ЗначениеЗаполнено(СтрокаТабличнойЧасти.Продукция_Элемент) и АвтоЗаписьВСДСоответствия Тогда
//		ВСД.Установить_Соответствие_ВСД_Продукция_Элемент(СтрокаТабличнойЧасти.Номенклатура,СтрокаТабличнойЧасти.Продукция_Элемент);	
//	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПродукцияПартияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//СписокПартийДляВыбора = ВСД.СписокАктуальныхПартийПоФильтру_Запрос(Элемент.Родитель.ТекущиеДанные.Продукция_Элемент,Объект.Владелец_Площадка, Объект.Владелец_ХозСубъект);	
	//ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина,Новый Структура("Ссылка", СписокПартийДляВыбора));	
	
	СтруктураОтбора = СтруктураОтбораПартий( Элемент.Родитель.ТекущиеДанные.Продукция_Элемент, Объект.Владелец_Площадка, Объект.Владелец_ХозСубъект);
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора, МножественныйВыбор, Отбор", Истина, Истина, Истина, СтруктураОтбора);	
	
	ОткрытьФорму("Справочник.ВСД_Партия.ФормаВыбора", ПараметрыПодбора, Элемент);	
КонецПроцедуры

//&НаКлиенте
//Процедура ПродукцияПартияПриИзменении(Элемент)
//	СтрокаТабличнойЧасти = Элемент.Родитель.ТекущиеДанные;
//	СтрокаТабличнойЧасти.Продукция_Элемент = ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(СтрокаТабличнойЧасти.Партия,"Продукция_Элемент");
//	ЗаполнитьРеквизитыСтрокиПродукция(СтрокаТабличнойЧасти,Элемент);
//// 	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) и ЗначениеЗаполнено(СтрокаТабличнойЧасти.Продукция_Элемент) и АвтоЗаписьВСДСоответствия Тогда
////		ВСД.Установить_Соответствие_ВСД_Продукция_Элемент(СтрокаТабличнойЧасти.Номенклатура,СтрокаТабличнойЧасти.Продукция_Элемент);	
////	КонецЕсли;
//КонецПроцедуры


//***** Работа с уровнями упаковки : на событиях и фильтрация.
#Область ТЧ_УровниУпаковки_Маркировка

&НаКлиенте
Процедура УровниУпаковкиПриАктивизацииСтроки(Элемент)
	Если (ЭтаФорма.Элементы.Продукция.ТекущаяСтрока = Неопределено) или
		(ЭтаФорма.Элементы.УровниУпаковки.ТекущаяСтрока = Неопределено) Тогда
		ЭтаФорма.Элементы.Маркировка.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции", 0);
	ИначеЕсли (Элемент.ТекущиеДанные <> Неопределено) Тогда  //Непонятный момент Чему равна ТекущаяСтрока
		ЭтаФорма.Элементы.Маркировка.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции",Элемент.ТекущиеДанные.СтрокаПродукции);
		ЭтаФорма.Элементы.Маркировка.ОтборСтрок = Новый ФиксированнаяСтруктура("НомерУровня",Элемент.ТекущиеДанные.НомерУровня);
	КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура УровниУпаковкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если ЭтаФорма.Элементы.Продукция.ТекущаяСтрока = Неопределено Тогда
		Отказ = true;
	КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура УровниУпаковкиПередУдалением(Элемент, Отказ)
	// Удалить маркировки по уровню
	СтруктураДляПоиска = Новый Структура("НомерУровня", Элемент.ТекущиеДанные.НомерУровня); 
	//Получаем список строк соответсвтвующих отбору, и перебором удаляем.
	МассивПустыхСтрок = Объект.Маркировка.НайтиСтроки(СтруктураДляПоиска); 
	Для Каждого Строка Из МассивПустыхСтрок Цикл 
		Объект.Маркировка.Удалить(Строка); 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УровниУпаковкиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Элемент.ТекущиеДанные.СтрокаПродукции = ЭтаФорма.Элементы.Продукция.ТекущиеДанные.НомерСтроки;
КонецПроцедуры

&НаКлиенте
Процедура УровниУпаковкиПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если НЕ(ЗначениеЗаполнено(Элемент.ТекущиеДанные.НомерУровня))	или НЕ(ЗначениеЗаполнено(Элемент.ТекущиеДанные.ФормаУпаковки)) Тогда
		ПредупреждениеПользователю("Заполните все данные !!!");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МаркировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если ЭтаФорма.Элементы.УровниУпаковки.ТекущаяСтрока = Неопределено Тогда 
		Отказ = true;
	КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура МаркировкаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если ЭтаФорма.Элементы.УровниУпаковки.ТекущиеДанные <> Неопределено Тогда 
		Элемент.ТекущиеДанные.СтрокаПродукции = ЭтаФорма.Элементы.УровниУпаковки.ТекущиеДанные.СтрокаПродукции;
		Элемент.ТекущиеДанные.НомерУровня = ЭтаФорма.Элементы.УровниУпаковки.ТекущиеДанные.НомерУровня;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МаркировкаПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если НЕ(ЗначениеЗаполнено(Элемент.ТекущиеДанные.Класс))	или НЕ(ЗначениеЗаполнено(Элемент.ТекущиеДанные.Маркировка)) Тогда
		ПредупреждениеПользователю("Заполните все данные !!!");
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры
#КонецОбласти

&НаСервере
Процедура кнЗаполнитьТЧДокументаНаСервере( МаксКолвоПартийВдокументе=100,МинДатаСрокГодности="")
	объект.Продукция.Очистить();
	СписокПартий = ВСД.СписокАктуальныхПартийПоФильтру_Запрос(,Объект.Владелец_Площадка,объект.Владелец_ХозСубъект);
	Для Каждого стрПартия Из СписокПартий Цикл
		Если объект.Продукция.Количество() > (МаксКолвоПартийВдокументе-1) Тогда
			Прервать;	
		КонецЕсли;
		
		Если ЗначениеЗаполнено(МинДатаСрокГодности) Тогда
			Если стрПартия.ДатаСрокГодности1 > МинДатаСрокГодности Тогда
				Продолжить;	
			КонецЕсли;
		КонецЕсли;
	
		стрПродукции = объект.Продукция.Добавить();
		стрПродукции.Партия = стрПартия;
		
		ЗаполнитьРеквизитыСтрокиНаСервере(стрПродукции);
	КонецЦикла;
КонецПроцедуры


&НаКлиенте
Процедура кнЗаполнить(Команда)
	ТВопроса = "Заполнить документ актуальными партиями ?";
	Если Объект.Продукция.Количество() > 0 Тогда
		ТВопроса = ТВопроса+ "
		|Текущие строки будут очищены ?";	
	КонецЕсли;
	
	Ответ = Вопрос(ТВопроса,РежимДиалогаВопрос.ДаНет,0);
	Если НЕ (Ответ = КодВозвратаДиалога.Да) Тогда
		Возврат;
	КонецЕсли;
	МаксКолвоПартийВдокументе = 100;
	МинДатаСрокГодности = Текущаядата();
    ВвестиЧисло(МаксКолвоПартийВдокументе, "Макс. кол-во Партий (строк) в документ?", 10, 2);
	Если НЕ ВвестиДату(МинДатаСрокГодности,"Макс срок годности",ЧастиДаты.Дата) Тогда
		МинДатаСрокГодности = "";	
	КонецЕсли;	
	кнЗаполнитьТЧДокументаНаСервере(МаксКолвоПартийВдокументе,МинДатаСрокГодности);
КонецПроцедуры

&НаКлиенте
Процедура кнСписание(Команда)
	ТВопроса = "Выбранные партии нужно списать ?";
	
	Ответ = Вопрос(ТВопроса,РежимДиалогаВопрос.ДаНет,0);
	Если НЕ (Ответ = КодВозвратаДиалога.Да) Тогда
		Возврат;
	КонецЕсли;
	Для Каждого стрПродукция Из Объект.Продукция Цикл
		стрПродукция.Количество = 0;	
	КонецЦикла
КонецПроцедуры


// *********** Подбор в ТЧ

&НаКлиенте
Процедура кнПодбор(Команда)
	//СписокПартийДляВыбора = ВСД.СписокАктуальныхПартийПоФильтру_Запрос(,Объект.Владелец_Площадка, Объект.Владелец_ХозСубъект);	
	//ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,МножественныйВыбор,Отбор", Истина, Истина, Истина,Новый Структура("Ссылка", СписокПартийДляВыбора));	
	
	СтруктураОтбора = СтруктураОтбораПартий( Неопределено, Объект.Владелец_Площадка, Объект.Владелец_ХозСубъект);
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора, МножественныйВыбор, Отбор", Истина, Истина, Истина, СтруктураОтбора);	
	
	ОткрытьФорму("Справочник.ВСД_Партия.ФормаВыбора", ПараметрыПодбора, Этаформа.Элементы.Продукция);	
КонецПроцедуры

&НаСервере
Процедура ПродукцияОбработкаВыбораНаСервере(ВыбранноеЗначение)
    Для Каждого ВыбЗначение Из ВыбранноеЗначение Цикл
        Если объект.продукция.НайтиСтроки(Новый Структура("Партия", ВыбЗначение)).Количество() = 0 Тогда
           новаяСтрокаТЧ = объект.продукция.Добавить();
           новаяСтрокаТЧ.Партия = ВыбЗначение.Ссылка;
           //ЗаполнитьРеквизитыСтрокиПродукцияСервер(нСтр);
		   ЗаполнитьРеквизитыСтрокиНаСервере(новаяСтрокаТЧ);
        КонецЕсли;
     КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПродукцияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПродукцияОбработкаВыбораНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура кнОткрытьЗапрос(Команда)
	ПутьКXML = "";
	Если (ЭтаФорма.Элементы.Запросы.ТекущаяСтрока <> Неопределено) Тогда
		ПутьКXML = ЭтаФорма.Элементы.Запросы.ТекущиеДанные.Файл;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПутьКXML) Тогда
		//КомандаСистемы("""""%ProgramFiles%\Internet Explorer\iexplore.exe"""" "+ПутьКXML);
		ЗапуститьПриложение(ПутьКXML);
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПродукцияПартияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	//ПродукцияПартияОбработкаВыбораНаСервере( ВыбранноеЗначение );
	//ЗаполнитьРеквизитыСтрокиНаСервере( Элемент.Родитель.ТекущиеДанные );
	
	Для Каждого зн Из ВыбранноеЗначение Цикл
		Элемент.Родитель.ТекущиеДанные.Партия = зн;
		ЗаполнитьРеквизитыСтрокиПродукция( Элемент.Родитель.ТекущиеДанные );
	КонецЦикла;
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаСервере
Процедура ПродукцияПартияПриИзмененииНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры


