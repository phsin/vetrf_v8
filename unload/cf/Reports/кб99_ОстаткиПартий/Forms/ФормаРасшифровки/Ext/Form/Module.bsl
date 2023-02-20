﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Партия = Параметры.Отбор.Партия;
	
	Макет = Отчеты.кб99_ОстаткиПартий.ПолучитьМакет("Макет");
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	кб99_ОстаткиПартийВетис.Период КАК Период,
		|	кб99_ОстаткиПартийВетис.ДокументДвижения КАК ДокументДвижения,
		|	кб99_ОстаткиПартийВетис.Количество КАК Остаток
		|ИЗ
		|	РегистрСведений.кб99_ОстаткиПартийВетис КАК кб99_ОстаткиПартийВетис
		|ГДЕ
		|	кб99_ОстаткиПартийВетис.Партия = &Партия
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период";
	
	Запрос.УстановитьПараметр("Партия", Партия);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");
	
	Результат.Очистить();
	Результат.Вывести(ОбластьЗаголовок);
	Результат.Вывести(ОбластьШапкаТаблицы);
	Результат.НачатьАвтогруппировкуСтрок();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ПредыдущееКоличество = 0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
		КоличествоВДокументе = 0;

		СтруктураОтбора = Новый Структура("Партия", Партия);
		ЭтоВСД2Транзакция = Ложь;
		Если ТипЗнч(ВыборкаДетальныеЗаписи.ДокументДвижения) = Тип("ДокументСсылка.ВСД2_транзакция") Тогда
			
			ЭтоВСД2Транзакция = Истина;
			
			тзДокумента = ВыборкаДетальныеЗаписи.ДокументДвижения.Товары.Выгрузить();			
			НайденныеСтроки = тзДокумента.НайтиСтроки(СтруктураОтбора);
			Для Каждого Стр Из НайденныеСтроки Цикл
				КоличествоВДокументе = КоличествоВДокументе + Стр.Количество;	
			КонецЦикла;
			
		ИначеЕсли ТипЗнч(ВыборкаДетальныеЗаписи.ДокументДвижения) = Тип("ДокументСсылка.ВСД2_Производство") Тогда
			
			тзПродукция = ВыборкаДетальныеЗаписи.ДокументДвижения.Продукция.Выгрузить();			
			НайденныеСтроки = тзПродукция.НайтиСтроки(СтруктураОтбора);
			Для Каждого Стр Из НайденныеСтроки Цикл
				КоличествоВДокументе = КоличествоВДокументе + Стр.Количество;	
			КонецЦикла;
			
			тзСырье = ВыборкаДетальныеЗаписи.ДокументДвижения.ПартииСписания.Выгрузить();
			НайденныеСтроки = тзСырье.НайтиСтроки(СтруктураОтбора);
			Для Каждого Стр Из НайденныеСтроки Цикл
				КоличествоВДокументе = КоличествоВДокументе + Стр.Количество;	
			КонецЦикла;
			
		ИначеЕсли ТипЗнч(ВыборкаДетальныеЗаписи.ДокументДвижения) = Тип("ДокументСсылка.ВСД2_входящий") Тогда 
			
			КоличествоВДокументе = ВыборкаДетальныеЗаписи.ДокументДвижения.КоличествоПринять;
			
		ИначеЕсли ТипЗнч(ВыборкаДетальныеЗаписи.ДокументДвижения) = Тип("ДокументСсылка.ПартииВСД") Тогда 
			
			тзДокумента = ВыборкаДетальныеЗаписи.ДокументДвижения.ПартииРезультат.Выгрузить();			
			НайденныеСтроки = тзДокумента.НайтиСтроки(СтруктураОтбора);
			Для Каждого Стр Из НайденныеСтроки Цикл
				КоличествоВДокументе = КоличествоВДокументе + Стр.Количество;	
			КонецЦикла;

		Иначе
			
			тзДокумента = ВыборкаДетальныеЗаписи.ДокументДвижения.Продукция.Выгрузить();
			НайденныеСтроки = тзДокумента.НайтиСтроки(СтруктураОтбора);
			Для Каждого Стр Из НайденныеСтроки Цикл
				КоличествоВДокументе = КоличествоВДокументе + Стр.Количество;	
			КонецЦикла;
			
		КонецЕсли;
		
		ОбластьДетальныхЗаписей.Параметры.КоличествоВДокументе = КоличествоВДокументе;
		Если ПредыдущееКоличество <> 0 И ЭтоВСД2Транзакция Тогда
			ОбластьДетальныхЗаписей.Параметры.Расхождение = КоличествоВДокументе - (ПредыдущееКоличество - ВыборкаДетальныеЗаписи.Остаток);	
		КонецЕсли;
		
		ПредыдущееКоличество = ВыборкаДетальныеЗаписи.Остаток;

		Результат.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетальныеЗаписи.Уровень());
		
	КонецЦикла;
	
	Результат.ЗакончитьАвтогруппировкуСтрок();
	//Результат.Вывести(ОбластьПодвалТаблицы);
	//Результат.Вывести(ОбластьПодвал);
	
	АвтоЗаголовок = Ложь;
	Заголовок = "Движения (расшифровка) по партии "+ Партия.НаименованиеПродукции;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	СтандартнаяОбработка = Ложь;
	
	ПоказатьЗначение( , Расшифровка);
	
КонецПроцедуры
