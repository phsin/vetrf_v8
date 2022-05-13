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
Процедура ОрганизацияПриИзменении(Элемент)
	СписокПараметров = кб99_ВСД.ЗагрузитьПараметры( Объект.Организация );
	Объект.Владелец_ХозСубъект = СписокПараметров["Отправитель_ХозСубъект"];
	Объект.Владелец_Площадка = СписокПараметров["Отправитель_Площадка"];
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.Ключ.Пустая() Тогда
		Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
       		Объект.Организация   =  кб99_ВСД_Общий.ПолучитьОрганизациюПоУмолчанию();
			ОрганизацияПриИзменении("");
		КонецЕсли;
	КонецЕсли;
	Если Объект.Проведен Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;	
	КонецЕсли;
	
	ЭлементОтбора = ЭтаФорма.дсЗапросы.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ; 
	ЭлементОтбора.ПравоеЗначение = Объект.Ссылка;
	
КонецПроцедуры

&НаКлиенте
Функция СтруктураОтбораПартий()
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Получатель_Площадка", Объект.Владелец_Площадка );
	СтруктураОтбора.Вставить("Получатель_ХозСубъект", Объект.Владелец_ХозСубъект );
	СтруктураОтбора.Вставить("ПометкаУдаления", Ложь );
	Если ЗначениеЗаполнено(Объект.ВидПродукции) Тогда 
		СтруктураОтбора.Вставить("ВидПродукции", Объект.ВидПродукции );
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.Продукция_Элемент) Тогда 
		СтруктураОтбора.Вставить("Продукция_Элемент", Объект.Продукция_Элемент );	
	КонецЕсли;	
	
	Возврат СтруктураОтбора;
	
КонецФункции

// *******************Шапка
&НаКлиенте
Процедура Владелец_ХозСубъектПриИзменении(Элемент)
	Объект.Владелец_Площадка = "";
КонецПроцедуры

&НаКлиенте
Процедура Владелец_ПлощадкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗначениеОтбора = Новый Структура("ХозСубъект", Объект.Владелец_ХозСубъект);
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина,ЗначениеОтбора);	
	ОткрытьФорму("Справочник.ВСД_Площадка.ФормаВыбора", ПараметрыПодбора, Элемент);	
	
КонецПроцедуры

//&НаСервере
//Функция ПолучитьРеквизитыЭлемента(ВыбЭлемент)
//	
//	Рез = Новый Структура;
//	Рез.Вставить("Продукция",ВыбЭлемент.Продукция);
//	Рез.Вставить("ВидПродукции",ВыбЭлемент.ВидПродукции);
//	Рез.Вставить("Наименование",ВыбЭлемент.Наименование);
//	Рез.Вставить("ЕдиницаИзмерения",ВыбЭлемент.ЕдиницаИзмерения);
//	Рез.Вставить("СрокГодности",ВыбЭлемент.СрокГодности);
//	
//	Возврат Рез;
//	
//КонецФункции

////******* ТЧ
//&НаСервере
//Функция ПолучитьРеквизитыПартии(ВыбЭлемент)
//	
//	Рез = Новый Структура;
//	Рез.Вставить("Продукция", 			ВыбЭлемент.Продукция);
//	Рез.Вставить("ВидПродукции", 		ВыбЭлемент.ВидПродукции);
//	Рез.Вставить("Продукция_Элемент", 	ВыбЭлемент.Продукция_Элемент);
//	Рез.Вставить("Наименование", 		ВыбЭлемент.Наименование);
//	Рез.Вставить("ЕдиницаИзмерения", 	ВыбЭлемент.ЕдиницаИзмерения);
//	Рез.Вставить("Количество", 			ВыбЭлемент.Количество);
//	Рез.Вставить("ДатаСрокГодности1", 	кб99_ВСД_Запросы.СтрокаВДатаВремя( ВыбЭлемент.ДатаСрокГодности1 ) );
//	Рез.Вставить("ДатаИзготовления1", 	кб99_ВСД_Запросы.СтрокаВДатаВремя( ВыбЭлемент.ДатаИзготовления1 ) );
//	Рез.Вставить("ДатаСрокГодности2", 	кб99_ВСД_Запросы.СтрокаВДатаВремя( ВыбЭлемент.ДатаСрокГодности2 ) );
//	Рез.Вставить("ДатаИзготовления2", 	кб99_ВСД_Запросы.СтрокаВДатаВремя( ВыбЭлемент.ДатаИзготовления2 ) );
//	
//	Рез.Вставить("ПартияПредставление", СтрШаблон("№%1 %2", ВыбЭлемент.НомерЗаписи, ВыбЭлемент.Наименование) );
//	
//	Возврат Рез;
//	
//КонецФункции

&НаКлиенте
Процедура ЗаполнитьРеквизитыШапки( ДанныеПартии )
	
	Если НЕ ЗначениеЗаполнено(Объект.Продукция_Элемент) Тогда
		Объект.Продукция_Элемент = ДанныеПартии.Продукция_Элемент;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.ВыбПродукция) Тогда
		Объект.ВыбПродукция = ДанныеПартии.Продукция;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.ВидПродукции) Тогда
		Объект.ВидПродукции = ДанныеПартии.ВидПродукции;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.НаименованиеПродукции) Тогда
		Объект.НаименованиеПродукции = ДанныеПартии.Наименование;
	КонецЕсли;
	
КонецПроцедуры

//&НаКлиенте
//Процедура ЗаполнитьРеквизитыСтрокиПродукция(СтрокаТЧ,ЧтоИзменили)
//	
//	Если ЗначениеЗаполнено(СтрокаТЧ.Партия) Тогда
//		ДанныеПартии = ПолучитьРеквизитыПартии(СтрокаТЧ.Партия);
//		ЗаполнитьЗначенияСвойств( СтрокаТЧ, ДанныеПартии );
//		ЗаполнитьРеквизитыШапки( ДанныеПартии );
//	КонецЕсли;
//	
//КонецПроцедуры

&НаКлиенте
Процедура ПродукцияПартияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураОтбора = СтруктураОтбораПартий();	
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,МножественныйВыбор,Отбор", Истина, Истина, Истина, СтруктураОтбора);	
	
	ОткрытьФорму("Справочник.ВСД_Партия.ФормаВыбора", ПараметрыПодбора, Элемент);
	
КонецПроцедуры

//&НаКлиенте
//Процедура ПродукцияПартияПриИзменении(Элемент)
//	
//	СтрокаТабличнойЧасти = Элемент.Родитель.ТекущиеДанные;
//	ЗаполнитьРеквизитыСтрокиПродукция(СтрокаТабличнойЧасти,Элемент);
//	
//КонецПроцедуры

//************* Шапка Продукция
&НаКлиенте
Процедура ВыбПродукцияПриИзменении(Элемент)
	
	Объект.ВидПродукции = "";
	 Объект.Продукция_Элемент = "";
	 Объект.НаименованиеПродукции = "";
	 Объект.Продукция.Очистить();
	 
КонецПроцедуры

&НаКлиенте
Процедура ВидПродукцииПриИзменении(Элемент)
	
	Объект.Продукция_Элемент = "";
	 Объект.НаименованиеПродукции = "";
	 Объект.Продукция.Очистить();
	 
КонецПроцедуры

&НаСервере
Процедура Продукция_ЭлементПриИзмененииСервер()
	
	Объект.ВидПродукции = Объект.Продукция_Элемент.ВидПродукции;
	Объект.ВыбПродукция = Объект.Продукция_Элемент.Продукция;
	Объект.НаименованиеПродукции = Объект.Продукция_Элемент.Наименование;
	
КонецПроцедуры

&НаКлиенте
Процедура Продукция_ЭлементПриИзменении(Элемент)
	Продукция_ЭлементПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура Продукция_ЭлементНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина,Новый Структура("ВидПродукции", Объект.ВидПродукции));	
	ОткрытьФорму("Справочник.ВСД_Продукция_Элемент.ФормаВыбора", ПараметрыПодбора, Элемент);		
КонецПроцедуры

//Подбор
&НаСервере
Процедура ЗаполнитьРеквизитыСтрокиПродукцияСервер(СтрокаТЧ)
	Если ЗначениеЗаполнено(СтрокаТЧ.Партия) Тогда
		СтрокаТЧ.ЕдиницаИзмерения = СтрокаТЧ.Партия.ЕдиницаИзмерения;
		СтрокаТЧ.Количество = СтрокаТЧ.Партия.Количество;
		СтрокаТЧ.ДатаИзготовления1 = кб99_ВСД_Запросы.СтрокаВДатаВремя( СтрокаТЧ.Партия.ДатаИзготовления1 );
		СтрокаТЧ.ДатаИзготовления2 = кб99_ВСД_Запросы.СтрокаВДатаВремя( СтрокаТЧ.Партия.ДатаИзготовления2 );
		СтрокаТЧ.ДатаСрокГодности1 = кб99_ВСД_Запросы.СтрокаВДатаВремя( СтрокаТЧ.Партия.ДатаСрокГодности1 );
		СтрокаТЧ.ДатаСрокГодности2 = кб99_ВСД_Запросы.СтрокаВДатаВремя( СтрокаТЧ.Партия.ДатаСрокГодности2 );
		
		СтрокаТЧ.ПартияПредставление = СтрШаблон("№%1 %2", СтрокаТЧ.Партия.НомерЗаписи, СтрокаТЧ.Партия.Наименование);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура кнПодбор(Команда)
	
	СтруктураОтбора = СтруктураОтбораПартий();	
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,МножественныйВыбор,Отбор", Истина, Истина, Истина, СтруктураОтбора );	

	ОткрытьФорму("Справочник.ВСД_Партия.ФормаВыбора", ПараметрыПодбора,Этаформа.Элементы.Продукция);
		
КонецПроцедуры

&НаСервере
Процедура ПродукцияОбработкаВыбораНаСервере(ВыбранноеЗначение)
	
	Для Каждого вЗнч Из ВыбранноеЗначение Цикл
        Если объект.продукция.НайтиСтроки(Новый Структура("Партия", вЗнч)).Количество() = 0 Тогда
           нСтр = объект.продукция.Добавить();
           нСтр.Партия = вЗнч.Ссылка;
           ЗаполнитьРеквизитыСтрокиПродукцияСервер(нСтр);
		   
			Если НЕ ЗначениеЗаполнено(Объект.ВыбПродукция) Тогда 
				Объект.ВыбПродукция = вЗнч.Ссылка.Продукция;
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(Объект.ВидПродукции) Тогда 
				Объект.ВидПродукции = вЗнч.Ссылка.ВидПродукции;
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(Объект.Продукция_Элемент) Тогда 
				Объект.Продукция_Элемент = вЗнч.Ссылка.Продукция_Элемент;
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(Объект.НаименованиеПродукции) Тогда 
				Объект.НаименованиеПродукции = вЗнч.Ссылка.Наименование;
			КонецЕсли;
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
		ЗапуститьПриложение(ПутьКXML);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	кб99_ВСД_Общий.ОбновитьНадписи(ЭтаФорма);
	кб99_ВСД_Общий.УстановитьУсловноеОформление(ЭтаФорма);
	ОбновитьПредставлениеПартий();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставлениеПартий()

	Массив = Объект.Продукция.Выгрузить(,"Партия").ВыгрузитьКолонку("Партия");
	Соответствие = ПолучитьСоответствиеПредставлений(Массив);
	
	Для Каждого Стр Из Объект.Продукция Цикл
		Стр.ПартияПредставление = Соответствие[Стр.Партия];
	КонецЦикла;	

КонецПроцедуры // ОбновитьПредставлениеСчетов()

&НаСервереБезКонтекста
Функция ПолучитьСоответствиеПредставлений(Ссылка)

	Соответствие = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Партия.НомерЗаписи КАК Номер,
		|	Партия.Наименование КАК Наименование,
		|	Партия.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВСД_Партия КАК Партия
		|ГДЕ
		|	Партия.Ссылка В(&Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Соответствие.Вставить(ВыборкаДетальныеЗаписи.Ссылка, СтрШаблон("№%1 %2", ВыборкаДетальныеЗаписи.Номер, ВыборкаДетальныеЗаписи.Наименование));
	КонецЦикла;
	
	Возврат Соответствие;

КонецФункции // ПолучитьСоответствиеПредставлений()

&НаКлиенте
Процедура ПродукцияПриИзменении(Элемент)
	ОбновитьПредставлениеПартий();
КонецПроцедуры

