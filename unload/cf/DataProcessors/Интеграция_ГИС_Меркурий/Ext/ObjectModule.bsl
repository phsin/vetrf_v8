﻿// https://vetis.kb99.pro
// phsin@kb99.pro
// zhukov@kb99.pro 
//
// Для УФ цвета в Условном Оформлении брать не из Стилей !!! Иначе слетают.

//Процедура РаскраситьТЧПартий() Экспорт
//	Для Каждого ДанныеСтроки Из Партии Цикл
//		Если НЕ ЗначениеЗаполнено(ДанныеСтроки.ВСД_Продукция_Элемент) Тогда
//			 ДанныеСтроки.сЦвет = 1;   // красный
//		ИначеЕсли ДанныеСтроки.Партия = Справочники.ВСД_Партия.ПустаяСсылка() Тогда
//			ДанныеСтроки.сЦвет = 2;   // желтый
//		ИначеЕсли ДанныеСтроки.Количество < ДанныеСтроки.КоличествоСписания Тогда
//			ДанныеСтроки.сЦвет = 1;   // красный
//		ИначеЕсли ДанныеСтроки.Количество >= ДанныеСтроки.КоличествоСписания Тогда
//			ДанныеСтроки.сЦвет = 3;  // зеленый
//		КонецЕсли;
//		Если ЗначениеЗаполнено(ДанныеСтроки.ВСД_Производство) Тогда
//			ДокОбъект = ДанныеСтроки.ВСД_Производство.ПолучитьОбъект();
//			Если ЗначениеЗаполнено(ДокОбъект.ApplicationID) и НЕ(СокрЛП(ДокОбъект.Статус = "COMPLETED")) Тогда
//				ДанныеСтроки.сЦвет = 1;   // красный
//			КонецЕсли;
//		КонецЕсли;
//	КонецЦикла;
//КонецПроцедуры

Процедура УменьшитьАктуальныеПартииНаРаспределенные(тзАктуальныхПартий)
	// Уменьшаем Акт партии на Неотправленные ВСД
	// Подберем уже заполненнные, но не отправленные ВСД, 
	// Выбираем ВСЕ документы, т.к. они м.б. не отмечены, но в них есть эти партии к отправке!!!
	// тзАктуальныхПартий.ВыбратьСтроку(); ТЕСТ
	тз = Отгрузки.Выгрузить();
	тз.Свернуть("ВСД","");
	//	тз.Сортировать("ВСД");
	Для Каждого Строкатз Из Тз Цикл
		Если НЕ ЗначениеЗаполнено(Строкатз.ВСД) Тогда
		    Продолжить;
		КонецЕсли;
		Если (Строкатз.ВСД.Проведен) или (СокрЛП(Строкатз.ВСД.Статус) = "COMPLETED") Тогда
		    Продолжить;
		КонецЕсли;
		
		тзДокВСД = Строкатз.ВСД.Товары.Выгрузить();
		тзДокВСД.Свернуть("Партия","Количество");
		
		Для Каждого СтрокаВСД Из тзДокВСД Цикл
		    Если НЕ ЗначениеЗаполнено(СтрокаВСД.Партия) Тогда
		        Продолжить;
			КонецЕсли;
			
			НайденнаяСтрока = ТзАктуальныхПартий.Найти(СтрокаВСД.Партия,"Партия");

			Если НайденнаяСтрока = Неопределено Тогда
    			// Предупреждение("Товар не найден!");
			Иначе
				НайденнаяСтрока.Количество = НайденнаяСтрока.Количество - СтрокаВСД.Количество;
				Если НайденнаяСтрока.Количество < 0  Тогда
					кб99_ВСД.СообщитьИнфо("В заполненных ранее ВСД на отправку обнаружено ПРЕВЫШЕНИЕ количества имеющейся партии по "+НайденнаяСтрока.Продукция_Элемент+"; (№ записи : "+СокрЛП(НайденнаяСтрока.Партия.НомерЗаписи)+") ; документ "+Строкатз.ВСД);
					НайденнаяСтрока.Количество = 0;    
				КонецЕсли;
				// ВСД.СообщитьИнфо("Есть в документах на отправку "+ТзАктуальныхПартий.ВСД_Партия+ ", уменьшаем на " + тздокСтр.Количество)
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	// Совсем выкинем уже распределенные Партии из списка Актуальных
	НайденнаяСтрока = ТзАктуальныхПартий.Найти(0,"Количество");
	Пока НЕ(НайденнаяСтрока = Неопределено) Цикл
		ТзАктуальныхПартий.Удалить(НайденнаяСтрока);
		НайденнаяСтрока = ТзАктуальныхПартий.Найти(0,"Количество");
	КонецЦикла;
	
КонецПроцедуры

//// Заполняем Партии на форме с Распределением
//Процедура ЗаполнитьТаблицуПартий() Экспорт
//	
//	СписокКонстант = кб99_ВСД.ЗагрузитьПараметры( Организация );
//	
//	Партии.Очистить();
//	ВремПартии = Новый ТаблицаЗначений;   
//	ВремПартии.Колонки.Добавить("Номенклатура");
//	ВремПартии.Колонки.Добавить("ВСД_Продукция_Элемент");
//	ВремПартии.Колонки.Добавить("КоличествоСписания");
//	
//	РаспределеннаяПартии = Новый ТаблицаЗначений; // итоговая ТЗ
//	РаспределеннаяПартии.Колонки.Добавить("Номенклатура");
//	РаспределеннаяПартии.Колонки.Добавить("ВСД_Продукция_Элемент");
//	РаспределеннаяПартии.Колонки.Добавить("Партия");
//	РаспределеннаяПартии.Колонки.Добавить("Количество");
//	РаспределеннаяПартии.Колонки.Добавить("КоличествоСписания");
//	РаспределеннаяПартии.Колонки.Добавить("ПолеСортировки");
//	
//	Для Каждого СтрОтгрузки Из Отгрузки Цикл
//		Если НЕ(СтрОтгрузки.Отметка) Тогда
//			Продолжить;
//		КонецЕсли;
//		
//		// ЖД Контроль уже отправленного/удаленного ВСД
//		Если ЗначениеЗаполнено(СтрОтгрузки.ВСД) Тогда
//			кб99_ВСД.СообщитьИнфо("Для "+СтрОтгрузки.Док+" уже создан "+СтрОтгрузки.ВСД+" ->Пропускаю");
//			// Если (СтрОтгрузки.ВСД.Проведен) или (СтрОтгрузки.ВСД.ПометкаУдаления)  Тогда 
//				Продолжить;
//			// КонецЕсли;
//		КонецЕсли;
//		
//		тз = кб99_ВСД_Общий.ВыгрузитьТЧ(СтрОтгрузки.Док, СписокКонстант);
//		Для Каждого стрТЗ Из ТЗ Цикл
//	        СтрПартий = Времпартии.Добавить();
//			СтрПартий.Номенклатура = стрТЗ.Номенклатура;
//			СтрПартий.ВСД_Продукция_Элемент = стрТЗ.Продукция_Элемент;
//			СтрПартий.КоличествоСписания = стрТЗ.Количество;
//		КонецЦикла;
//	КонецЦикла;
//	ВремПартии.Свернуть("ВСД_Продукция_Элемент","КоличествоСписания");    // !!!
//	ВремПартии.Сортировать("ВСД_Продукция_Элемент");

//	Если ВремПартии.Количество() = 0 Тогда
//		кб99_ВСД.СообщитьИнфо("Нет документов к созданию ВСД ->");
//		Возврат;
//	КонецЕсли;
//	
//	тзАктуальныхПартий = кб99_ВСД.ПолучитьАктуальныеПартии(СписокКонстант, ВремПартии.ВыгрузитьКолонку("ВСД_Продукция_Элемент"), Отправитель_Площадка, Отправитель_ХозСубъект );
//	
//	Если НЕ (ТипЗнч(тзАктуальныхПартий) = Тип("ТаблицаЗначений")) и НЕ ПарамЗаполнятьТранзакциюПриОтсутствииПартий Тогда
//		кб99_ВСД.СообщитьИнфо("Нет актуальных партий для создания Документов ");
//		Возврат;
//	КонецЕсли;
//	
//	УменьшитьАктуальныеПартииНаРаспределенные(тзАктуальныхПартий);
//	
//	Для Каждого стрНужныеПартии Из ВремПартии Цикл
//		// Код из ЗаполнитьТЧВСД, только с отключенным Условием ПарамЗаполнятьТранзакциюПриОтсутствииПартий - покажем недостающие партии
//		СтрокиПартий = кб99_ВСД.ПодобратьПартииПоПродукцияЭлемент( СписокКонстант, тзАктуальныхПартий, стрНужныеПартии.ВСД_Продукция_Элемент, стрНужныеПартии.КоличествоСписания );
//		Если СтрокиПартий.Количество() = 0  Тогда
//			НоваяСтрока = РаспределеннаяПартии.Добавить();
//			НоваяСтрока.ВСД_Продукция_Элемент = стрНужныеПартии.ВСД_Продукция_Элемент;
//			НоваяСтрока.КоличествоСписания = стрНужныеПартии.КоличествоСписания;
//			НоваяСтрока.Количество = 0;
//			кб99_ВСД.СообщитьИнфо("Нет партий для ["+стрНужныеПартии.ВСД_Продукция_Элемент +"]");
//		   	Продолжить;
//		КонецЕсли;
//		
//		Для Каждого СтрПартии Из СтрокиПартий Цикл
//			НоваяСтрока = РаспределеннаяПартии.Добавить();
//			НоваяСтрока.Партия = СтрПартии.Партия;
//			НоваяСтрока.ВСД_Продукция_Элемент = стрНужныеПартии.ВСД_Продукция_Элемент;
//			НоваяСтрока.Количество = СтрПартии.Количество; 
//			НоваяСтрока.КоличествоСписания = СтрПартии.Количество;
//			НоваяСтрока.ПолеСортировки 		= СтрПартии.ПолеСортировки;
//		КонецЦикла;
//		
//		Если (СтрокиПартий.Итог("Количество") < стрНужныеПартии.КоличествоСписания) Тогда 
//			// Добавим с пустыми партиями
//			НоваяСтрока = РаспределеннаяПартии.Добавить();
//			НоваяСтрока.ВСД_Продукция_Элемент = стрНужныеПартии.ВСД_Продукция_Элемент;
//			НоваяСтрока.КоличествоСписания	=  стрНужныеПартии.КоличествоСписания - СтрокиПартий.Итог("Количество") ;
//			НоваяСтрока.Количество = 0; 
//		КонецЕсли;
//	КонецЦикла;
//	Партии.Загрузить(РаспределеннаяПартии);
//	РаскраситьТЧПартий();
//КонецПроцедуры


Процедура ОтправитьВсе_ВСД2_Производство(СписокВСД="",НачДата, КонДата) Экспорт
	// стандартное поведение функции		
	// Состояние("Меркурий: отправка ВСД Производство");
	кб99_ВСД.СообщитьИнфо("Начало отправки документов");
	
	Если НЕ(ЗначениеЗаполнено(СписокВСД)) Тогда 
		// Выберем документы производства  - запросом
		СписокВСД = Новый СписокЗначений;
 		Запрос = Новый Запрос;
    	Запрос.Текст = 
        "ВЫБРАТЬ
        |	ВСД_Производство.Ссылка
        |ИЗ
        |	Документ.ВСД_Производство КАК ВСД_Производство
        |ГДЕ
        |	ВСД_Производство.Производитель_ХозСубъект = &ВыбХС
        |	И ВСД_Производство.ПометкаУдаления = ЛОЖЬ
        |	И ВСД_Производство.Дата МЕЖДУ &ДатаН И &ДатаК
        |	И ВСД_Производство.Проведен = ЛОЖЬ";
 
	    Запрос.УстановитьПараметр("ДатаН", НачалоДня(НачДата));
		Запрос.УстановитьПараметр("ДатаК", КонецДня(КонДата));
    	Запрос.УстановитьПараметр("ВыбХС", Отправитель_Хозсубъект);
	    // МассивВСД = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		СписокВСД.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
		кб99_ВСД.СообщитьИнфо("отправляются ВСД производство за период "+ПредставлениеПериода(НачДата,КонецДня(КонДата),"ФП=ИСТИНА")+ "в количестве "+СписокВСД.Количество());//ПериодСтр(НачДата, КонДата));
	Иначе
		кб99_ВСД.СообщитьИнфо("отправляются ВСД производство "+СписокВСД.Количество()+" документов");
	КонецЕсли;
		
	Для Каждого стрСпискаВСД Из СписокВСД Цикл
		ВСДСсылка = стрСпискаВСД.Значение ;
	
		Если ВСДСсылка.Проведен Тогда 
			Продолжить;
		КонецЕсли;
		Если ВСДСсылка.ПометкаУдаления Тогда 
			Продолжить;
		КонецЕсли;
		Если ЗначениеЗаполнено(ВСДСсылка.applicationID) Тогда
			//кб99_ВСД.СообщитьИнфо("Разработчик - > Диалог на сервере ОтправитьВсе_ВСД2_Производство - Нужно решить!!!");
			// Ответ = Вопрос("Документ ["+ВСДСсылка+"] статус=["+СокрЛП(ВСДСсылка.Статус)+"] уже был отправлен, отправить ПОВТОРНО?",РежимДиалогаВопрос.ДаНет,0);
			// Если Ответ = КодВозвратаДиалога.Нет Тогда
    			Продолжить;
			// КонецЕсли;
		КонецЕсли;		
	
		// Отправить_ВСД2_производство( ВСДСсылка );
		Параметры = кб99_ВСД.ЗагрузитьПараметры( Организация );
		кб99_ВСД_Запросы.ВСД2_Производство_Отправить( Параметры, ВСДСсылка );

	КонецЦикла;
	
	кб99_ВСД.СообщитьИнфо("Отправка документов завершена");
КонецПроцедуры

Процедура СоздатьВСД2( СписокКонстант="" ) Экспорт
	// Создает ВСД по списку из тч Отгрузки
 	// С учетом актуальных Партий (за минусом неотправленных ВСД изи списка ГО
	Если Партии.Количество()=0 Тогда
		кб99_ВСД.СообщитьИнфо("Не заполнена таблица партий.");
		Возврат;
	КонецЕсли;
	
//	Если (КомпонентаНаСервере = Неопределено) и ЗначениеЗаполнено(АдресКомпонентыНаСервере) тогда
//		ЗагрузитьГлПеременныеИзВременногоХранилища();
//	КонецЕсли;
	// Если СписокКонстант = Неопределено Тогда
	// СписокКонстант = ВСД.ЗагрузитьПараметры( Организация );
	// КонецЕсли;
	СписокКонстант = кб99_ВСД.ЗагрузитьПараметры( Организация );
	
	тзАктуальныхПартий = кб99_ВСД.ПолучитьАктуальныеПартии(СписокКонстант, Партии.ВыгрузитьКолонку("ВСД_Продукция_Элемент"), Отправитель_Площадка, Отправитель_ХозСубъект );
	
	Если НЕ (ТипЗнч(тзАктуальныхПартий) = Тип("ТаблицаЗначений")) и НЕ ПарамЗаполнятьТранзакциюПриОтсутствииПартий Тогда
		кб99_ВСД.СообщитьИнфо("Нет актуальных партий для создания Документов ");
		Возврат;
	КонецЕсли;
	
	УменьшитьАктуальныеПартииНаРаспределенные(тзАктуальныхПартий);
	
	Для Каждого СтрОтгрузки Из Отгрузки Цикл
		Если НЕ(СтрОтгрузки.Отметка) Тогда
			Продолжить;
		КонецЕсли;

		// Если НЕ(СтрОтгрузки.ВСД=Документы.ВСД2_транзакция.ПустаяСсылка()) и НЕ(СтрОтгрузки.ВСД=Документы.ВСД_транзакция.ПустаяСсылка()) Тогда       
		Если СтрОтгрузки.ВСД <> Неопределено Тогда
			Если СтрОтгрузки.ВСД.Проведен Тогда
				кб99_ВСД.СообщитьИнфо("Для "+СтрОтгрузки.Док+" уже отправлен "+СтрОтгрузки.ВСД+", Статус:"+СтрОтгрузки.ВСД.Статус);
				Продолжить;
			КонецЕсли;
			Если (ПустаяСтрока(СтрОтгрузки.ВСД.Статус) = 1) Тогда 
				кб99_ВСД.СообщитьИнфо("Для "+СтрОтгрузки.Док+" ВСД уже создан, но не отправлен");
				Продолжить;
			КонецЕсли;		
		КонецЕсли;		
		
		Если НЕ(ЗначениеЗаполнено(СтрОтгрузки.Площадка)) или НЕ(ЗначениеЗаполнено(СтрОтгрузки.ХозСубъект)) Тогда
			кб99_ВСД.СообщитьИнфо("Для "+СтрОтгрузки.Док+" неизвестен ХС или Площадка получателя ");
			Продолжить;
		КонецЕсли;
		//// Доп контроль Переходный Период с 1.4 на 2.*
		// ДокВСД = ВСД.НайтиВСД(СтрОтгрузки.Док);
		// Если ЗначениеЗаполнено(ДокВСД) Тогда
		//		ВСД.СообщитьИнфо("Уже создан "+ДокВСД +" для "+СтрОтгрузки.Док);
		//	Продолжить;
		// КонецЕсли;
				
		// ХС = СтрОтгрузки.ХозСубъект;
		// Площадка = СтрОтгрузки.Площадка;
		
		ПараметрыДокумента = Новый Структура;
		ПараметрыДокумента.Вставить("Получатель_ХозСубъект", СтрОтгрузки.ХозСубъект );
		ПараметрыДокумента.Вставить("Получатель_Площадка", СтрОтгрузки.Площадка );
		ПараметрыДокумента.Вставить("ДокОснование", СтрОтгрузки.Док);
		ПараметрыЗаполнения = Новый Структура;
		ПараметрыЗаполнения.Вставить("ПараметрыДокумента", ПараметрыДокумента);
		ПараметрыЗаполнения.Вставить("ДокументОснование", СтрОтгрузки.Док);
		ПараметрыЗаполнения.Вставить("тзАктуальныхПартий", тзАктуальныхПартий);
		
		ДокВСД = Документы.ВСД2_Транзакция.СоздатьДокумент();
		ДокВСД.Заполнить( ПараметрыЗаполнения );
		ДокВСД.Записать();
		// ДокВСД = СоздатьДокумент_ВСД2_Транзакция( ПолучитьДанныеДляСозданияВСДТранзакции(СтрОтгрузки.Док, ХС, СтрОтгрузки.Площадка) );
		// Если ЗначениеЗаполнено(ДокВСД) тогда
			СтрОтгрузки.ВСД = ДокВСД.Ссылка;		
			кб99_ВСД.СообщитьИнфо("["+СтрОтгрузки.Грузополучатель+"] создан документ "+СтрОтгрузки.ВСД, СтрОтгрузки.ВСД);		
		// КонецЕсли;
	КонецЦикла;								

КонецПроцедуры

