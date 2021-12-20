﻿
&НаСервере
Процедура ЗаполнитьОстаткиНаСервере( СписокНоменклатуры = Неопределено )
	
	Объект.Остатки1С.Очистить();
	Объект.ОстаткиМеркурий.Очистить();
	Объект.СверкаСходится.Очистить();
	Объект.СверкаКорректировка.Очистить();
	
	ЕстьОтборПоСкладу = Истина;
	
	Запрос = Новый Запрос;
	ЗапросТекст = "ВЫБРАТЬ
	              |	ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура,
	              |	ТоварыНаСкладахОстатки.Серия.ДатаПроизводства КАК ДатаПроизводстваСерия,
	              |	СУММА(ТоварыНаСкладахОстатки.ВНаличииОстаток) КАК ВНаличииОстаток
	              |ИЗ
	              |	РегистрНакопления.ТоварыНаСкладах.Остатки(&ВыбДата, %УсловиеПоСкладу% %ОтборПоНоменклатуре%) КАК ТоварыНаСкладахОстатки
	              |ГДЕ
	              |	ТоварыНаСкладахОстатки.Серия <> &СерияПустая
	              |	И ТоварыНаСкладахОстатки.ВНаличииОстаток > 0
	              |	%УсловиеПоГруппеНоменклатуры%
	              |
	              |СГРУППИРОВАТЬ ПО
	              |	ТоварыНаСкладахОстатки.Номенклатура,
	              |	ТоварыНаСкладахОстатки.Серия.ДатаПроизводства";
	
	Если ЗначениеЗаполнено(Объект.Площадка.Склады) Тогда
		СписокСкладов = Объект.Площадка.Склады.Выгрузить(,"Склад");
		ОтборПоСкладу = "Склад В (&СписокСкладов)";
		Запрос.УстановитьПараметр("СписокСкладов", СписокСкладов);
	ИначеЕсли ЗначениеЗаполнено(Объект.Площадка.Склад) Тогда
		ОтборПоСкладу = "Склад = &ВыбСклад";
		Запрос.УстановитьПараметр("ВыбСклад", Объект.Площадка.Склад);
	Иначе
		ОтборПоСкладу = "";
		ЕстьОтборПоСкладу = Ложь;
	КонецЕсли;
	
	Если СписокНоменклатуры = Неопределено Тогда
		ОтборПоНоменклатуре = "";
		УсловиеПоГруппеНоменклатуры = "И ТоварыНаСкладахОстатки.Номенклатура В ИЕРАРХИИ(&ГруппаНоменклатуры)";
		Запрос.УстановитьПараметр( "ГруппаНоменклатуры", Объект.ГруппаНоменклатуры);
	Иначе
		ОтборПоНоменклатуре = ?(ЕстьОтборПоСкладу, "И Номенклатура В(&СписокНоменклатуры)", "Номенклатура В(&СписокНоменклатуры)");
		УсловиеПоГруппеНоменклатуры = "";
		Запрос.УстановитьПараметр( "СписокНоменклатуры", СписокНоменклатуры);
	КонецЕсли;
	
	ЗапросТекст = СтрЗаменить(ЗапросТекст, "%УсловиеПоСкладу%", ОтборПоСкладу);
	ЗапросТекст = СтрЗаменить(ЗапросТекст, "%УсловиеПоГруппеНоменклатуры%", УсловиеПоГруппеНоменклатуры);
	ЗапросТекст = СтрЗаменить(ЗапросТекст, "%ОтборПоНоменклатуре%", ОтборПоНоменклатуре);
	
	Если Не Объект.УчитыватьСерии Тогда
		ЗапросТекст=СтрЗаменить(ЗапросТекст, "ТоварыНаСкладахОстатки.Серия <> &СерияПустая
		|	И ТоварыНаСкладахОстатки.ВНаличииОстаток > 0", "ТоварыНаСкладахОстатки.ВНаличииОстаток > 0");
	Иначе
		Запрос.УстановитьПараметр( "СерияПустая", Справочники.СерииНоменклатуры.ПустаяСсылка());
	КонецЕсли;
	
	Запрос.УстановитьПараметр( "ВыбДата", ТекущаяДата());

	Запрос.Текст=ЗапросТекст;
	тзПартии = Запрос.Выполнить().Выгрузить();
	тзПартии.Колонки.Добавить("Цвет");
	тзПартии.Колонки.Добавить("Ошибки");
	тзПартии.Колонки.Добавить("ВСДСписок");
	тзПартии.Колонки.Добавить("КолВоСоотв");
	тзПартии.Колонки.Добавить("Количество");
	тзПартии.Колонки.Добавить("НоменклатураВесЧислитель");
	тзПартии.Колонки.Добавить("НоменклатураВесЗнаменатель");
	тзПартии.Колонки.Добавить("ПродукцияЭлемент");

	Для Каждого Стр Из тзПартии Цикл
		Стр.Ошибки = "";
		
		Если Стр.Номенклатура.ВесЕдиницаИзмерения = Справочники.УпаковкиЕдиницыИзмерения.НайтиПоКоду("163") Тогда
			Стр.НоменклатураВесЗнаменатель = ?(стр.Номенклатура.ВесЗнаменатель = 0, 1000, стр.Номенклатура.ВесЗнаменатель)/ 1000;
			Стр.НоменклатураВесЧислитель   = ?(стр.Номенклатура.ВесЧислитель = 0, 1000, стр.Номенклатура.ВесЧислитель)/ 1000;
		Иначе
			Стр.НоменклатураВесЗнаменатель = ?(стр.Номенклатура.ВесЗнаменатель = 0, 1, стр.Номенклатура.ВесЗнаменатель);
			Стр.НоменклатураВесЧислитель   = ?(стр.Номенклатура.ВесЧислитель = 0, 1, стр.Номенклатура.ВесЧислитель);
		КонецЕсли;

		Продукция_Элемент = кб99_ВСД.Продукция_Элемент_ПолучитьПоНоменклатуре(Стр.Номенклатура);
		стр.Количество = стр.ВНаличииОстаток/стр.НоменклатураВесЗнаменатель*стр.НоменклатураВесЧислитель; 
		стр.ПродукцияЭлемент = Продукция_Элемент;
		тзСписок= кб99_ВСД.ПолучитьСписок_ВСД_Продукция_ЭлементПоНоменклатуре( Стр.Номенклатура );
		стр.КолВоСоотв=тзСписок.количество();
		сп = новый списокЗначений;
		для каждого стрТЗСписок из  тзСписок цикл
			сп.Добавить(стрТЗСписок.ПродукцияЭлемент);
		конеццикла;
		стр.ВсдСписок=сп;
		стр.ВНаличииОстаток =стр.Количество;
		Если НЕ ЗначениеЗаполнено(Продукция_Элемент.ЕдиницаИзмерения) Тогда
			Стр.Ошибки = Стр.Ошибки + "Не заполнена ед. измерения ";
			Если НЕ ЗначениеЗаполнено(Продукция_Элемент.СрокГодности)	Тогда
				Стр.Ошибки = Стр.Ошибки +  " и срок годности.";
			КонецЕсли;
			Стр.Цвет = "Желтый";
		КонецЕсли;	
	КонецЦикла;
	
	СтруктураОтбора = Новый Структура("ПродукцияЭлемент", Справочники.ВСД_Продукция_Элемент.ПустаяСсылка());
	МассивСтрок = тзПартии.НайтиСтроки(СтруктураОтбора);
	Для Каждого ЭлементМассив Из МассивСтрок Цикл
		тзПартии.Удалить(ЭлементМассив); 
	КонецЦикла;
	
	тзПартии.Сортировать("Номенклатура Возр");
	Объект.Остатки1С.Загрузить( тзПартии );	
	
	Если ПустаяСтрока(Объект.ГруппаНоменклатуры) И СписокНоменклатуры = Неопределено Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ВСД_Партия.Ссылка КАК Партия,
		               |	ВСД_Партия.Продукция_Элемент КАК ПродукцияЭлемент,
		               |	ВСД_Партия.ДатаСрокГодности1 КАК СрокГодности1,
		               |	ВСД_Партия.ДатаСрокГодности2 КАК СрокГодности2,
		               |	ВСД_Партия.Количество КАК Количество,
		               |	ВСД_Партия.Количество КАК КоличествоПартии,
		               |	ВСД_Партия.ДатаИзготовления1 КАК ДатаПроизводства1,
		               |	ВСД_Партия.ДатаИзготовления2 КАК ДатаПроизводства2
		               |ИЗ
		               |	Справочник.ВСД_Партия КАК ВСД_Партия
		               |ГДЕ
		               |	ВСД_Партия.Получатель_Площадка = &Получатель_Площадка
		               |	И ВСД_Партия.Количество > 0
		               |	И ВСД_Партия.ПометкаУдаления = ЛОЖЬ";
		Запрос.УстановитьПараметр("Получатель_Площадка", Объект.Площадка );
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ВСД_Партия.Ссылка КАК Партия,
		               |	ВСД_Партия.Продукция_Элемент КАК ПродукцияЭлемент,
		               |	ВСД_Партия.ДатаСрокГодности1 КАК СрокГодности1,
		               |	ВСД_Партия.ДатаСрокГодности2 КАК СрокГодности2,
		               |	ВСД_Партия.Количество КАК Количество,
		               |	ВСД_Партия.Количество КАК КоличествоПартии,
		               |	ВСД_Партия.ДатаИзготовления1 КАК ДатаПроизводства1,
		               |	ВСД_Партия.ДатаИзготовления2 КАК ДатаПроизводства2
		               |ИЗ
		               |	Справочник.ВСД_Партия КАК ВСД_Партия
		               |ГДЕ
		               |	ВСД_Партия.Получатель_Площадка = &Получатель_Площадка
		               |	И ВСД_Партия.Количество > 0
		               |	И ВСД_Партия.ПометкаУдаления = ЛОЖЬ
		               |	И ВСД_Партия.Продукция_Элемент В(&Продукция_Элемент)";
		Запрос.УстановитьПараметр("Получатель_Площадка", Объект.Площадка );
		
		сп=новый СписокЗначений;
		для каждого стрПартии из тзПартии цикл
			тзСписок= кб99_ВСД.ПолучитьСписок_ВСД_Продукция_ЭлементПоНоменклатуре( стрПартии.Номенклатура );
			для каждого стрТЗСписок из  тзСписок цикл
				сп.Добавить(стрТЗСписок.ПродукцияЭлемент);
			конеццикла;
		КонецЦикла;
		Запрос.УстановитьПараметр("Продукция_Элемент",сп );
	КонецЕсли;
	
	тзПартии = Запрос.Выполнить().Выгрузить();
	тзПартии.Колонки.Добавить("ДатаСрокГодности1");
	тзПартии.Колонки.Добавить("ДатаСрокГодности2");
	тзПартии.Колонки.Добавить("ДатаИзготовления1");
	тзПартии.Колонки.Добавить("ДатаИзготовления2");

	Для Каждого стрПартия из тзПартии Цикл
		стрПартия.ДатаСрокГодности1 = кб99_ВСД_Запросы.СтрокаВДатаВремя( стрПартия.СрокГодности1 );
		стрПартия.ДатаСрокГодности2 = кб99_ВСД_Запросы.СтрокаВДатаВремя( стрПартия.СрокГодности2 );
		стрПартия.ДатаИзготовления1 = кб99_ВСД_Запросы.СтрокаВДатаВремя( стрПартия.ДатаПроизводства1 );
		стрПартия.ДатаИзготовления2 = кб99_ВСД_Запросы.СтрокаВДатаВремя( стрПартия.ДатаПроизводства2 );
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВСД_Продукция_Элемент.Ссылка КАК Ссылка,
	               |	КОЛИЧЕСТВО(ВСД_Соответсвия.Ссылка) КАК КолвоСсылок
	               |ИЗ
	               |	Справочник.ВСД_Продукция_Элемент КАК ВСД_Продукция_Элемент
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВСД_Соответсвия КАК ВСД_Соответсвия
	               |		ПО (ВСД_Соответсвия.ПродукцияЭлемент = ВСД_Продукция_Элемент.Ссылка)
	               |			И (ВСД_Соответсвия.ПометкаУдаления = ЛОЖЬ)
	               |			И (ВСД_Соответсвия.ПродукцияЭлемент.ПометкаУдаления = ЛОЖЬ)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВСД_Продукция_Элемент.Ссылка";
	тзПЭ = Запрос.Выполнить().Выгрузить();
	тзПартии.Колонки.Добавить("Цвет");
	
	Для Каждого стрПЭ из тзПЭ Цикл
		Если стрПЭ.КолвоСсылок = 0 Тогда 
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("ПродукцияЭлемент", стрПЭ.Ссылка);
			тзПартииОтбор = тзПартии.НайтиСтроки(ПараметрыОтбора);			
			
			Для Каждого стрПартия из тзПартииОтбор Цикл
				стрПартия.Цвет = "Красный";
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Объект.ОстаткиМеркурий.Загрузить( тзПартии );
	Объект.СверкаСходится.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОстатки(Команда)
	
	ЗаполнитьОстаткиНаСервере( );
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСверкуНаСервере()
	
	Объект.СверкаСходится.Очистить();
	тзТовары = Объект.Остатки1С.Выгрузить();
	тзПартии = Объект.ОстаткиМеркурий.Выгрузить();
	
	// 1. Сходится
	Для Каждого строкаТовар из тзТовары Цикл
		
		Товар = строкаТовар.Номенклатура;
		тзПЭ = кб99_ВСД.ПолучитьСписок_ВСД_Продукция_ЭлементПоНоменклатуре( Товар );
		
		Для Каждого строкаПЭ из тзПЭ Цикл
			ПЭ = СтрокаПЭ.ПродукцияЭлемент;
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("ПродукцияЭлемент", ПЭ);
			тзПартииОтбор = тзПартии.НайтиСтроки(ПараметрыОтбора);			
			
			Для Каждого стрПартия из тзПартииОтбор Цикл
				Если ( стрПартия.Количество >0 ) и (строкаТовар.Количество >0 ) Тогда 
					
					Если Объект.УчитыватьСерии и ЗначениеЗаполнено( строкаТовар.ДатаПроизводстваСерия ) Тогда 
						Если ЗначениеЗаполнено( стрПартия.ДатаИзготовления2 ) Тогда 
							Если ( стрПартия.ДатаИзготовления1 > строкаТовар.ДатаПроизводстваСерия ) ИЛИ
								 ( стрПартия.ДатаИзготовления2 < строкаТовар.ДатаПроизводстваСерия ) Тогда 
								Продолжить;
							КонецЕсли;
						Иначе
							Если стрПартия.ДатаИзготовления1 <> строкаТовар.ДатаПроизводстваСерия Тогда 
								Продолжить;
							КонецЕсли;							
						КонецЕсли;
					КонецЕсли;
										
					стрСверка = Объект.СверкаСходится.Добавить();
					ЗаполнитьЗначенияСвойств( стрСверка, стрПартия );
					стрСверка.Номенклатура = Товар;
					стрСверка.ДатаПроизводстваСерия = строкаТовар.ДатаПроизводстваСерия;
					
					Если строкаТовар.Количество > стрПартия.Количество Тогда 						
						//стрСверка.Количество = стрПартия.Количество;												
						стрСверка.Количество   = строкаТовар.Количество;												
						строкаТовар.Количество = строкаТовар.Количество - стрПартия.Количество;
						стрПартия.Количество = 0;
						стрПартия.Откоректированно=Истина;
					Иначе
						стрСверка.Количество = строкаТовар.Количество;						
						стрПартия.Откоректированно=Истина;
						стрПартия.Количество = стрПартия.КоличествоПартии - строкаТовар.Количество;
						строкаТовар.Количество = 0;
					КонецЕсли;	
					
					Если стрсверка.количество = стрсверка.партия.количество Тогда
						стрсверка.цвет = "Зеленый";	
					КонецЕсли;
				
				КонецЕсли;						
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	// 1. Корректировка
	тзПартии.Сортировать("ДатаИзготовления1 Убыв, ДатаИзготовления2 Убыв, ДатаСрокГодности1 Убыв, ДатаСрокГодности2 Убыв");
	Для Каждого строкаТовар из тзТовары Цикл
		
		Товар = строкаТовар.Номенклатура;
		тзПЭ = кб99_ВСД.ПолучитьСписок_ВСД_Продукция_ЭлементПоНоменклатуре( Товар );
		
		Для Каждого строкаПЭ из тзПЭ Цикл
			ПЭ = СтрокаПЭ.ПродукцияЭлемент;
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("ПродукцияЭлемент", ПЭ);
			тзПартииОтбор = тзПартии.НайтиСтроки(ПараметрыОтбора);			
			
			Для Каждого стрПартия из тзПартииОтбор Цикл
				если не стрПартия.Откоректированно тогда
					Если ( стрПартия.Количество >0 ) и (строкаТовар.Количество >0 ) Тогда 
						
						стрСверка = Объект.СверкаКорректировка.Добавить();
						ЗаполнитьЗначенияСвойств( стрСверка, стрПартия );
						стрСверка.Номенклатура = Товар;
						стрСверка.ДатаПроизводстваСерия = строкаТовар.ДатаПроизводстваСерия;
						
						Если строкаТовар.Количество > стрПартия.Количество Тогда 						
							стрСверка.Количество = стрПартия.Количество;												
							строкаТовар.Количество = строкаТовар.Количество - стрПартия.Количество;
							стрПартия.Количество = 0;
							стрПартия.Откоректированно=Истина;
						Иначе
							стрСверка.Количество = строкаТовар.Количество;						
							стрПартия.Количество = стрПартия.Количество - строкаТовар.Количество;
							строкаТовар.Количество = 0;
							стрПартия.Откоректированно=Истина;
						КонецЕсли;						
					КонецЕсли;
				конецесли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	
	Объект.Остатки1С.Загрузить( тзТовары );
	Объект.ОстаткиМеркурий.Загрузить( тзПартии );
	тзПартии.Колонки.Добавить("Удалить");
	для каждого стрТЗ из тзПартии цикл
		если стрТЗ.количество<>стрТЗ.партия.количество тогда
			стртз.Удалить=1;
		конецесли;
	конеццикла;
	УдаляемыеСтроки = тзПартии.НайтиСтроки(Новый Структура("Удалить",1));
	Для каждого СтрокаТаблицы Из УдаляемыеСтроки Цикл
		тзПартии.Удалить(СтрокаТаблицы)
	КонецЦикла;
	Объект.ОстаткиМеркурийУдаление.Загрузить( тзПартии );
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСверку(Команда)
	
	ЗаполнитьОстаткиНаСервере();
	
	ЗаполнитьСверкуНаСервере();
	
КонецПроцедуры

&НаСервере
Функция КорректировкаСроковГодности()
	
	ДокВСД = Документы.ВСД2_Инвентаризация.СоздатьДокумент();
	
	ДокВСД.Дата = ТекущаяДата(); 
	ДокВСД.Организация = Объект.Организация;
	ДокВСД.Владелец_ХозСубъект = Объект.ХозСубъект;
	ДокВСД.Владелец_площадка = Объект.Площадка;
	ДокВСД.ПричинаРасхождения = "Инвентаризация партий";
	ДокВСД.ОписаниеНесоответствия = "Инвентаризация партий";
	
	Партии = Объект.СверкаКорректировка.Выгрузить();
	
	Для Каждого СтрПартии Из Партии Цикл
		Если НЕ(СтрПартии.Отметка) Тогда
			Продолжить;
		КонецЕсли;

		Если ЗначениеЗаполнено(СтрПартии.ДатаИзготовления1) Тогда
			НоваяСтрока = ДокВСД.Продукция.Добавить();
			НоваяСтрока.Партия				= СтрПартии.Партия;
			НоваяСтрока.Продукция_Элемент 	= СтрПартии.ПродукцияЭлемент;
			НоваяСтрока.Количество 			= СтрПартии.Количество;
			НоваяСтрока.Продукция 			= НоваяСтрока.Продукция_Элемент.Продукция;
			НоваяСтрока.ВидПродукции 		= НоваяСтрока.Продукция_Элемент.ВидПродукции;
			НоваяСтрока.ЕдиницаИзмерения 	= НоваяСтрока.Партия.ЕдиницаИзмерения;
			Если Не ЗначениеЗаполнено( НоваяСтрока.ЕдиницаИзмерения ) Тогда 
				кб99_ВСД.СообщитьИнфо("Не заполнена ЕдиницаИзмерения в "+НоваяСтрока.Партия);	
			КонецЕсли;
			НоваяСтрока.НаименованиеПродукции = НоваяСтрока.Продукция_Элемент.Наименование;
			НоваяСтрока.ДатаИзготовления1 = СтрПартии.ДатаПроизводстваСерия;
			НоваяСтрока.ДатаСрокГодности1 = НоваяСтрока.ДатаИзготовления1 + НоваяСтрока.Продукция_Элемент.СрокГодности *86400;
			НоваяСтрока.Производитель_площадка = НоваяСтрока.Партия.Производитель_Площадка;
			НоваяСтрока.Производитель_Страна = НоваяСтрока.Производитель_площадка.Страна;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ДокВСД.Продукция) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДокВСД.Записать();

	Возврат ДокВСД.Ссылка;
	
КонецФункции

&НаКлиенте
Процедура СоздатьИнвентаризациюДаты(Ответ,Парам) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ДокВСД = КорректировкаСроковГодности();
		Если Не ДокВСД = Неопределено Тогда
			ОткрытьФорму("Документ.ВСД2_Инвентаризация.ФормаОбъекта",Новый Структура("Ключ", ДокВСД));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура кнКорректировкаДаты(Команда)
	
	Если ЗначениеЗаполнено(Объект.СверкаКорректировка) Тогда
		ТВопроса = "Создать ВСД2_Инвентаризация по списку корректировки сроков годности ?";
		Оповещение = Новый ОписаниеОповещения("СоздатьИнвентаризациюДаты",ЭтаФорма);	
		ПоказатьВопрос(Оповещение, ТВопроса, РежимДиалогаВопрос.ДаНет,  0, КодВозвратаДиалога.Да, ""   ); 	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура кнОтметитьВсе(Команда)
	
	Для Каждого Стр Из Объект.СверкаКорректировка Цикл
		Стр.Отметка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура кнСнятьВсе(Команда)
	
	Для Каждого Стр Из Объект.СверкаКорректировка Цикл
		Стр.Отметка = Ложь;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция КорректировкаОстатков()
	
	ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры(Объект.Организация);
	
	ДокВСД = Документы.ВСД2_Инвентаризация.СоздатьДокумент();
	
	ДокВСД.Дата = ТекущаяДата(); 
	ДокВСД.Организация = Объект.Организация;
	ДокВСД.Владелец_ХозСубъект = Объект.ХозСубъект;
	ДокВСД.Владелец_площадка = Объект.Площадка;
	ДокВСД.ПричинаРасхождения = "Инвентаризация партий";
	ДокВСД.ОписаниеНесоответствия = "Инвентаризация партий";
	
	тзОстатки1с = Объект.Остатки1С.Выгрузить();
	тзОстаткиМеркурий = Объект.ОстаткиМеркурий.Выгрузить();
	тзСверка = Объект.СверкаСходится.Выгрузить();
	тзСверка.Свернуть("ПродукцияЭлемент,Партия","Количество");

	тзСверкаДаты = Объект.СверкаКорректировка.Выгрузить();
	
	// Добавление недостающих партий
	Для Каждого СтрОстатки1с Из тзОстатки1с Цикл
		Если ЗначениеЗаполнено(СтрОстатки1с.Количество) И СтрОстатки1с.Количество = СтрОстатки1с.ВНаличииОстаток Тогда
			НоваяСтрока = ДокВСД.Продукция.Добавить();
			НоваяСтрока.Продукция_Элемент = кб99_ВСД.Продукция_Элемент_ПолучитьПоНоменклатуре(  СтрОстатки1с.Номенклатура );
			НоваяСтрока.Количество 			= СтрОстатки1с.Количество;
			НоваяСтрока.Продукция 			= НоваяСтрока.Продукция_Элемент.Продукция;
			НоваяСтрока.ВидПродукции 		= НоваяСтрока.Продукция_Элемент.ВидПродукции;
			НоваяСтрока.ЕдиницаИзмерения 	= НоваяСтрока.Продукция_Элемент.ЕдиницаИзмерения;
			Если Не ЗначениеЗаполнено( НоваяСтрока.ЕдиницаИзмерения ) Тогда 
				кб99_ВСД.СообщитьИнфо("Не заполнена ЕдиницаИзмерения в "+НоваяСтрока.Продукция_Элемент);	
			КонецЕсли;
			НоваяСтрока.НаименованиеПродукции = НоваяСтрока.Продукция_Элемент.Наименование;
			НоваяСтрока.ДатаИзготовления1 = СтрОстатки1с.ДатаПроизводстваСерия;
			НоваяСтрока.ДатаСрокГодности1 = НоваяСтрока.ДатаИзготовления1 + НоваяСтрока.Продукция_Элемент.СрокГодности *86400;
			НоваяСтрока.Производитель_площадка = НоваяСтрока.Продукция_Элемент.Площадка;
			НоваяСтрока.Производитель_Страна = НоваяСтрока.Производитель_площадка.Страна;
		КонецЕсли;
	КонецЦикла;
	
	// Выравнивание количества имеющихся партий с остатками из 1с 
	Для Каждого СтрОстатки1с Из тзСверка Цикл
		Если СтрОстатки1с.Количество<>СтрОстатки1с.Партия.Количество Тогда
			НоваяСтрока = ДокВСД.Продукция.Добавить();
			НоваяСтрока.Продукция_Элемент   = СтрОстатки1с.ПродукцияЭлемент;
			НоваяСтрока.Количество 			= СтрОстатки1с.Количество;
			НоваяСтрока.Партия 			    = СтрОстатки1с.Партия;
			НоваяСтрока.Продукция 			= СтрОстатки1с.ПродукцияЭлемент.Продукция;
			НоваяСтрока.ВидПродукции 		= СтрОстатки1с.ПродукцияЭлемент.ВидПродукции;
			НоваяСтрока.ЕдиницаИзмерения 	= НоваяСтрока.Продукция_Элемент.ЕдиницаИзмерения;
			Если Не ЗначениеЗаполнено( НоваяСтрока.ЕдиницаИзмерения ) Тогда 
				кб99_ВСД.СообщитьИнфо("Не заполнена ЕдиницаИзмерения в "+НоваяСтрока.Продукция_Элемент);	
			КонецЕсли;
			НоваяСтрока.НаименованиеПродукции = НоваяСтрока.Продукция_Элемент.Наименование;
			НоваяСтрока.ДатаСрокГодности1 =кб99_ВСД_Запросы.СтрокаВДатаВремя(НоваяСтрока.Партия.ДатаСрокГодности1);
			НоваяСтрока.ДатаСрокГодности2 = кб99_ВСД_Запросы.СтрокаВДатаВремя(НоваяСтрока.Партия.ДатаСрокГодности2);

			НоваяСтрока.ДатаИзготовления1 = кб99_ВСД_Запросы.СтрокаВДатаВремя(НоваяСтрока.Партия.ДатаИзготовления1);
			НоваяСтрока.ДатаИзготовления2 = кб99_ВСД_Запросы.СтрокаВДатаВремя(НоваяСтрока.Партия.ДатаИзготовления2);
			
			НоваяСтрока.Производитель_площадка =  СтрОстатки1с.Партия.Производитель_Площадка;
			Если ЗначениеЗаполнено(НоваяСтрока.Производитель_площадка.Страна) Тогда
				НоваяСтрока.Производитель_Страна = НоваяСтрока.Производитель_площадка.Страна;
			Иначе
				НоваяСтрока.Производитель_Страна = ПараметрыОрганизации["Страна"];
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	// Корректировка сроков годности у имеющихся партий по серии номенклатуры
	Для Каждого СтрПартии Из тзСверкаДаты Цикл

		Если ЗначениеЗаполнено(СтрПартии.ДатаИзготовления1) Тогда
			НоваяСтрока = ДокВСД.Продукция.Добавить();
			НоваяСтрока.Партия				= СтрПартии.Партия;
			НоваяСтрока.Продукция_Элемент 	= СтрПартии.ПродукцияЭлемент;
			НоваяСтрока.Количество 			= СтрПартии.Количество;
			НоваяСтрока.Продукция 			= НоваяСтрока.Продукция_Элемент.Продукция;
			НоваяСтрока.ВидПродукции 		= НоваяСтрока.Продукция_Элемент.ВидПродукции;
			НоваяСтрока.ЕдиницаИзмерения 	= НоваяСтрока.Партия.ЕдиницаИзмерения;
			Если Не ЗначениеЗаполнено( НоваяСтрока.ЕдиницаИзмерения ) Тогда 
				кб99_ВСД.СообщитьИнфо("Не заполнена ЕдиницаИзмерения в "+НоваяСтрока.Партия);	
			КонецЕсли;
			НоваяСтрока.НаименованиеПродукции = НоваяСтрока.Продукция_Элемент.Наименование;
			НоваяСтрока.ДатаИзготовления1 = СтрПартии.ДатаПроизводстваСерия;
			НоваяСтрока.ДатаСрокГодности1 = НоваяСтрока.ДатаИзготовления1 + НоваяСтрока.Продукция_Элемент.СрокГодности *86400;
			НоваяСтрока.Производитель_площадка = НоваяСтрока.Партия.Производитель_Площадка;
			НоваяСтрока.Производитель_Страна = НоваяСтрока.Производитель_площадка.Страна;
		КонецЕсли;
		
	КонецЦикла;
	
	// Списание лишних партий
	Для Каждого СтрПартии Из тзОстаткиМеркурий Цикл
		Если СтрПартии.Количество = СтрПартии.КоличествоПартии Тогда
			Если СтрПартии.Количество > 0 И НЕ СтрПартии.Цвет = "Красный" Тогда
				НоваяСтрока = ДокВСД.Продукция.Добавить();
				НоваяСтрока.Партия				= СтрПартии.Партия;
				НоваяСтрока.Продукция_Элемент 	= СтрПартии.ПродукцияЭлемент;
				НоваяСтрока.Количество 			= 0;
				НоваяСтрока.Продукция 			= НоваяСтрока.Продукция_Элемент.Продукция;
				НоваяСтрока.ВидПродукции 		= НоваяСтрока.Продукция_Элемент.ВидПродукции;
				НоваяСтрока.ЕдиницаИзмерения 	= НоваяСтрока.Партия.ЕдиницаИзмерения;
				НоваяСтрока.НаименованиеПродукции = НоваяСтрока.Продукция_Элемент.Наименование;
				СтрДата1 = НоваяСтрока.Партия.ДатаИзготовления1;
				НоваяСтрока.ДатаИзготовления1 = кб99_ВСД_Запросы.СтрокаВДатаВремя(СтрДата1);
				НоваяСтрока.ДатаСрокГодности1 = СтрПартии.ДатаСрокГодности1;
				СтрДата2 = НоваяСтрока.Партия.ДатаИзготовления2;
				НоваяСтрока.ДатаИзготовления2 = кб99_ВСД_Запросы.СтрокаВДатаВремя(СтрДата2);
				НоваяСтрока.ДатаСрокГодности2 = СтрПартии.ДатаСрокГодности2;
				НоваяСтрока.Производитель_площадка = НоваяСтрока.Партия.Производитель_Площадка;
				НоваяСтрока.Производитель_Страна = НоваяСтрока.Производитель_площадка.Страна;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ДокВСД.Записать();

	Возврат ДокВСД.Ссылка;

КонецФункции

&НаКлиенте
Процедура СоздатьИнвентаризациюОстатки(Ответ,Парам) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ДокВСД = КорректировкаОстатков();
		ОткрытьФорму("Документ.ВСД2_Инвентаризация.ФормаОбъекта",Новый Структура("Ключ", ДокВСД));	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура кнКорректировкаОстатков(Команда)
			
	ТВопроса = "Создать ВСД2_Инвентаризация для корректировки остатков партий ?";
    Оповещение = Новый ОписаниеОповещения("СоздатьИнвентаризациюОстатки",ЭтаФорма);	
    ПоказатьВопрос(Оповещение, ТВопроса, РежимДиалогаВопрос.ДаНет,  0, КодВозвратаДиалога.Да, ""   ); 	

КонецПроцедуры

&НаКлиенте
Процедура Остатки1СПриАктивизацииСтроки(Элемент)
	
	если Объект.Фильтровать тогда
		если Элемент.ТекущиеДанные<>Неопределено тогда 
			СписокСравнения = ЭтаФорма.Элементы.ОстаткиМеркурий; 
			СписокСравнения.ОтборСтрок = Новый ФиксированнаяСтруктура("ПродукцияЭлемент",  Элемент.ТекущиеДанные.ПродукцияЭлемент );
			СписокСравненияОстатки= ЭтаФорма.Элементы.Сверка;
			СписокСравненияОстатки.ОтборСтрок = Новый ФиксированнаяСтруктура("Номенклатура", Элемент.ТекущиеДанные.Номенклатура);
			СписокСравненияОстаткиЕМЕ= ЭтаФорма.Элементы.СверкаКорректировка;
			СписокСравненияОстаткиЕМЕ.ОтборСтрок = Новый ФиксированнаяСтруктура("Номенклатура", Элемент.ТекущиеДанные.Номенклатура);
		конецесли;
	иначе
		ЭтаФорма.Элементы.ОстаткиМеркурий.ОтборСтрок =Неопределено; 
		ЭтаФорма.Элементы.Сверка.ОтборСтрок =Неопределено;
		ЭтаФорма.Элементы.СверкаКорректировка.ОтборСтрок =Неопределено;
	конецесли;

КонецПроцедуры

&НаСервере
Функция КорректировкаОстатковСошлось()
		
	ДокВСД = Документы.ВСД2_Инвентаризация.СоздатьДокумент();
	
	ДокВСД.Дата = ТекущаяДата(); 
	ДокВСД.Организация = Объект.Организация;
	ДокВСД.Владелец_ХозСубъект = Объект.ХозСубъект;
	ДокВСД.Владелец_площадка = Объект.Площадка;
	ДокВСД.ПричинаРасхождения = "Инвентаризация партий";
	ДокВСД.ОписаниеНесоответствия = "Инвентаризация партий";
	
	тзОстатки1с = Объект.СверкаСходится.Выгрузить();
	тзостатки1с.Свернуть("ПродукцияЭлемент,Партия","Количество");
	
	Для Каждого СтрОстатки1с Из тзОстатки1с Цикл
		Если СтрОстатки1с.Количество<>СтрОстатки1с.Партия.Количество Тогда
			НоваяСтрока = ДокВСД.Продукция.Добавить();
			НоваяСтрока.Продукция_Элемент = СтрОстатки1с.ПродукцияЭлемент;
			НоваяСтрока.Количество 			= СтрОстатки1с.Количество;
			НоваяСтрока.Партия 			= СтрОстатки1с.Партия;
			НоваяСтрока.Продукция 			= СтрОстатки1с.ПродукцияЭлемент.Продукция;
			НоваяСтрока.ВидПродукции 		= СтрОстатки1с.ПродукцияЭлемент.ВидПродукции;
			НоваяСтрока.ЕдиницаИзмерения 	= НоваяСтрока.Продукция_Элемент.ЕдиницаИзмерения;
			Если Не ЗначениеЗаполнено( НоваяСтрока.ЕдиницаИзмерения ) Тогда 
				кб99_ВСД.СообщитьИнфо("Не заполнена ЕдиницаИзмерения в "+НоваяСтрока.Продукция_Элемент);	
			КонецЕсли;
			НоваяСтрока.НаименованиеПродукции = НоваяСтрока.Продукция_Элемент.Наименование;
			НоваяСтрока.ДатаСрокГодности1 =кб99_ВСД_Запросы.СтрокаВДатаВремя(НоваяСтрока.Партия.ДатаСрокГодности1);
			НоваяСтрока.ДатаСрокГодности2 = кб99_ВСД_Запросы.СтрокаВДатаВремя(НоваяСтрока.Партия.ДатаСрокГодности2);

			НоваяСтрока.ДатаИзготовления1 = кб99_ВСД_Запросы.СтрокаВДатаВремя(НоваяСтрока.Партия.ДатаИзготовления1);
			НоваяСтрока.ДатаИзготовления2 = кб99_ВСД_Запросы.СтрокаВДатаВремя(НоваяСтрока.Партия.ДатаИзготовления2);
			
			НоваяСтрока.Производитель_площадка =  СтрОстатки1с.Партия.Производитель_Площадка;
			НоваяСтрока.Производитель_Страна = НоваяСтрока.Производитель_площадка.Страна;
		КонецЕсли;
	КонецЦикла;
		
	ДокВСД.Записать();

	Возврат ДокВСД.Ссылка;

КонецФункции

&НаКлиенте
Процедура ОткорректироватьНаСервере(Ответ,Парам) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ДокВСД = КорректировкаОстатковСошлось();
		ОткрытьФорму("Документ.ВСД2_Инвентаризация.ФормаОбъекта",Новый Структура("Ключ", ДокВСД));	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Откорректировать(Команда)
	
	ТВопроса = "Создать ВСД2_Инвентаризация для корректировки остатков партий ?";
    Оповещение = Новый ОписаниеОповещения("ОткорректироватьНаСервере",ЭтаФорма);	
    ПоказатьВопрос(Оповещение, ТВопроса, РежимДиалогаВопрос.ДаНет,  0, КодВозвратаДиалога.Да, ""   ); 	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СписокПартий") Тогда
		
		ЗаполнитьЗначенияСвойств(Объект, Параметры, "Организация, ХозСубъект, Площадка, УчитыватьСерии");
		
		СписокПартий = Параметры.СписокПартий;
		
		Если ТипЗнч(СписокПартий) = Тип("Массив") Тогда
			мсНоменклатура = СписокПартий;
		Иначе
			тзСписокПартий = СписокПартий.Выгрузить();
			тзСписокПартий.Свернуть("Номенклатура, Продукция_Элемент, Партия");
			
			СтруктураОтбора = Новый Структура();
			СтруктураОтбора.Вставить("Партия", Справочники.ВСД_Партия.ПустаяСсылка());
			
			ОтобранныеСтроки = тзСписокПартий.НайтиСтроки(СтруктураОтбора);
			мсНоменклатура = Новый Массив;
			Для Каждого Стр Из ОтобранныеСтроки Цикл
				Если ЗначениеЗаполнено(Стр.Продукция_Элемент) Тогда
					мсНоменклатура.Добавить(Стр.Номенклатура);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		ЗаполнитьОстаткиНаСервере(мсНоменклатура);
		ЗаполнитьСверкуНаСервере();

		Элементы.Группа1.ТолькоПросмотр = Истина;
		Элементы.ФормаЗаполнитьСверку.Доступность = Ложь;
		
	Иначе
	    Объект.Организация    = кб99_ВСД_Общий.ПолучитьОрганизациюПоУмолчанию();
		ПараметрыОрганизации  = кб99_ВСД.ЗагрузитьПараметры(Объект.Организация);
		Объект.ХозСубъект 	  = ПараметрыОрганизации["Отправитель_ХозСубъект"];
		Объект.Площадка		  = ПараметрыОрганизации["Отправитель_Площадка"];
		Объект.УчитыватьСерии = Истина;
	КонецЕсли;
	
КонецПроцедуры
