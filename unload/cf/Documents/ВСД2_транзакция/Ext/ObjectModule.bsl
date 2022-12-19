﻿
Функция ПолучитьДанныеДляСозданияВСДТранзакции( ПараметрыОрганизации ) 
	
	ПереопределенныйМодуль = кб99_ВСД_Общий.ФункцияПереопределена("ПолучитьДанныеДляСозданияВСДТранзакции");
	Если ПереопределенныйМодуль <> Неопределено Тогда
		Возврат ПереопределенныйМодуль.ПолучитьДанныеДляСозданияВСДТранзакции(ПараметрыОрганизации, ЭтотОбъект);
	КонецЕсли;
	
	Рез = Новый Структура;
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		Если ПараметрыОрганизации["ПарамФильтроватьРеализациюПоСкладуПлощадкиОтправителя"] Тогда   // Определим нашу площадку по Складу
			_Отправитель_Площадка = кб99_ВСД.НайтиПлощадкуПоСкладу(ДокументОснование.Склад, ПараметрыОрганизации["Отправитель_ХозСубъект"]);
		Иначе
			_Отправитель_Площадка = ПараметрыОрганизации["Отправитель_Площадка"];
		КонецЕсли;
		_Получатель_ХозСубъект = кб99_ВСД.НайтиХозСубъект(ДокументОснование.Контрагент);				
		Если ПараметрыОрганизации["РеквизитГрузополучатель"] = 0 Тогда
        	// Контрагент
        	_Получатель_Площадка = кб99_ВСД.НайтиПлощадкуПоКонтрагенту(ДокументОснование.Контрагент);
    	ИначеЕсли ПараметрыОрганизации["РеквизитГрузополучатель"] = 1 Тогда
			// Адрес доставки
        	_Получатель_Площадка = кб99_ВСД.НайтиПлощадкуПоКонтрагенту(ДокументОснование.АдресДоставки);
		Иначе
        	// Партнер
            _Получатель_Площадка = кб99_ВСД.НайтиПлощадкуПоКонтрагенту(ДокументОснование.Партнер);
    	КонецЕсли;
		
	ИначеЕсли  ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		
		_Отправитель_Площадка = кб99_ВСД.НайтиПлощадкуПоСкладу(ДокументОснование.СкладОтправитель, ПараметрыОрганизации["Отправитель_ХозСубъект"]);
		_Получатель_ХозСубъект = ПараметрыОрганизации["Отправитель_ХозСубъект"];
		_Получатель_Площадка = кб99_ВСД.НайтиПлощадкуПоСкладу(ДокументОснование.СкладПолучатель, _Получатель_ХозСубъект);
		
	Иначе
		// РасходныйОрдер
		// Списание
		
		_Отправитель_Площадка = ПараметрыОрганизации["Отправитель_Площадка"];  
		
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Контрагент", ДокументОснование.Метаданные()) Тогда 						
			Контрагент = ДокументОснование.Контрагент;
			_Получатель_ХозСубъект = кб99_ВСД.НайтиХозСубъект( Контрагент );
		Иначе
			Контрагент = Неопределено;
			_Получатель_ХозСубъект = ПараметрыОрганизации["Отправитель_ХозСубъект"];
		КонецЕсли;	
		
		Если ПараметрыОрганизации["РеквизитГрузополучатель"] = 0 Тогда 
			//контрагент
			Если ЗначениеЗаполнено(Контрагент) Тогда 
				_Получатель_Площадка = кб99_ВСД.НайтиПлощадкуПоКонтрагенту(Контрагент);
			Иначе
				кб99_ВСД.СообщитьИнфо("Получатель Площадка не определен - в документе основании нет реквизита [Контрагент]");
			КонецЕсли;
		Иначе
			//Адрес доставки
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("АдресДоставки", ДокументОснование.Метаданные()) Тогда 						
				_Получатель_Площадка = кб99_ВСД.НайтиПлощадкуПоКонтрагенту(ДокументОснование.АдресДоставки);
			Иначе
				кб99_ВСД.СообщитьИнфо("Получатель Площадка не определен - в документе основании нет реквизита [Адрес доставки]");
			КонецЕсли;
		КонецЕсли;
	
	КонецЕсли;
	
	Рез.Вставить("Отправитель_Хозсубъект", 	ПараметрыОрганизации["Отправитель_ХозСубъект"]);  // Взяли из реквизитов обработки - активные данные
	Рез.Вставить("Отправитель_Площадка", 	_Отправитель_Площадка);
	Рез.Вставить("Получатель_Хозсубъект", 	_Получатель_ХозСубъект);
	Рез.Вставить("Получатель_Площадка", 	_Получатель_Площадка);
	
	Возврат Рез;
	
КонецФункции

Процедура ОбработкаЗаполнения( ДанныеЗаполнения, СтандартнаяОбработка)
	
	ПереопределенныйМодуль = кб99_ВСД_Общий.ФункцияПереопределена("ОбработкаЗаполнения_ВСД2_Транзакция");
	Если ПереопределенныйМодуль <> Неопределено Тогда
		ПереопределенныйМодуль.ОбработкаЗаполнения_ВСД2_Транзакция(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
		Возврат;
	КонецЕсли;

	ОтПоставщика = Ложь; // временно
	
	Если (ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваровУслуг")) Тогда
		
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		Организация = ДокументОснование.Организация;
		
		ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Организация );
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыОрганизации );
		
		ЭтоПеремещениеОтПоставщика = ОтПоставщика;
		
		ПараметрыДокумента = ПолучитьДанныеДляСозданияВСДТранзакции( ПараметрыОрганизации );
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыДокумента );
		
		Дата = ?(ЗначениеЗаполнено(ДокументОснование), ДокументОснование.Дата, ТекущаяДата());			
		ТтнСерия = ""; 
		ТтнНомер = кб99_ВСД_Общий.ПолучитьНомерДокБезПрефикса( ДокументОснование );
		ТтнДата = Дата; 
		номерАвто = кб99_ВСД_Общий.ПолучитьНомерАвто( ДокументОснование ); 
		
		Местность 		= ПараметрыОрганизации["ВСД_Местность"];
		ОсобыеОтметки 	= ПараметрыОрганизации["ВСД_ОсобыеОтметки"];
		cargoInspected  	= Истина;			
		РезультатыИсследований = ПараметрыОрганизации["ВСД_РезультатыИсследований"]; 
		
		кб99_ВСД_Общий.ЗаполнитьТабЧастьВСД( ПараметрыОрганизации, ДокументОснование, ЭтотОбъект,,, ДокументОснование.Контрагент );

	ИначеЕсли ( ТипЗнч(ДанныеЗаполнения) = Тип("Структура") ) Тогда 
		
		Если ДанныеЗаполнения.Свойство("ОтПоставщика") и ДанныеЗаполнения.ОтПоставщика Тогда 
			// внутреннее перемещение ОТ поставщика
			ДокументОснование = ДанныеЗаполнения.Основание;
			ЭтоПеремещениеОтПоставщика = Истина;
			тзАктуальныхПартий = Неопределено;
			Комментарий = "Перемещение от поставщика на основании "+ДокументОснование;
			
			ОрганизацияПолучатель = ДокументОснование.Организация;
			ПараметрыОрганизацииПолучателя = кб99_ВСД.ЗагрузитьПараметры( ОрганизацияПолучатель );
			Организация = ПараметрыОрганизацииПолучателя.ПарамПоставщикОрганизация;			
			ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Организация );
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыОрганизации );			
			
			Отправитель_ХозСубъект = ПараметрыОрганизацииПолучателя.ПарамПоставщикХозСубъект;
			Отправитель_Площадка = ПараметрыОрганизацииПолучателя.ПарамПоставщикПлощадка;			
			Получатель_ХозСубъект = ПараметрыОрганизацииПолучателя.Отправитель_ХозСубъект;
			Получатель_Площадка = ПараметрыОрганизацииПолучателя.Отправитель_Площадка;
			
			кб99_ВСД_Общий.ЗаполнитьТабЧастьВСД( ПараметрыОрганизации, ДокументОснование, ЭтотОбъект, тзАктуальныхПартий );
		Иначе
			// заполнение по ТЗ Партий
			ПараметрыДокумента = ДанныеЗаполнения.ПараметрыДокумента;
			Если ДанныеЗаполнения.Свойство("тзАктуальныхПартий") Тогда 
				тзАктуальныхПартий = ДанныеЗаполнения.тзАктуальныхПартий;
			Иначе
				тзАктуальныхПартий = Неопределено;
			КонецЕсли;
			Если ПараметрыДокумента.Свойство("ДокОснование") Тогда 
				ДокументОснование  = ПараметрыДокумента.ДокОснование;

				Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Контрагент", ДокументОснование.Метаданные()) Тогда 			
					Контрагент = ДокументОснование.Контрагент;
				КонецЕсли;

				Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Организация", ДокументОснование.Метаданные()) Тогда 			
					Организация = ДокументОснование.Организация;
				Иначе
					Организация = ПараметрыДокумента.Организация;
				КонецЕсли;
				
			Иначе
				Организация = ПараметрыДокумента.Организация;
				ДокументОснование = Неопределено;
			КонецЕсли;
			
			ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Организация );
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыОрганизации );			
			
			//загрузим входящие параметры
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыДокумента);
			
			Если ДанныеЗаполнения.Свойство("ТермическиеУсловияПеревозки") Тогда
				ТермическиеУсловияПеревозки = ДанныеЗаполнения.ТермическиеУсловияПеревозки;
				ТермУсловияДляОтбора = ДанныеЗаполнения.ТермическиеУсловияПеревозки;
			Иначе
				ТермическиеУсловияПеревозки = ПараметрыОрганизации["ТермическиеУсловияПеревозки"];
				ТермУсловияДляОтбора = Неопределено;
			КонецЕсли;
			
			Если ДанныеЗаполнения.Свойство("Партии") Тогда 
				
				// заполним Товары подготовленной таблицей Партий				
				Для Каждого стрПартия из ДанныеЗаполнения.Партии Цикл
					СтрТовары = ЭтотОбъект.Товары.Добавить();
					СтрТовары.КлючСтроки = Новый УникальныйИдентификатор();
					ЗаполнитьЗначенияСвойств( стрТовары, стрПартия );
					кб99_ВСД_Общий.ЗаполнитьРеквизитыСтрокиВСД(ПараметрыОрганизации,СтрТовары,стрПартия, ЭтотОбъект);
				КонецЦикла;
				
			ИначеЕсли ПараметрыДокумента.Свойство("Товары") Тогда 
				кб99_ВСД_Общий.ЗаполнитьТабЧастьВСДпоТЗ( ПараметрыОрганизации, ПараметрыДокумента.Товары, ЭтотОбъект, тзАктуальныхПартий, ТермУсловияДляОтбора);
			Иначе
				кб99_ВСД_Общий.ЗаполнитьТабЧастьВСД( ПараметрыОрганизации, ДокументОснование, ЭтотОбъект, тзАктуальныхПартий, ТермУсловияДляОтбора, Контрагент);
			КонецЕсли;
			
		КонецЕсли;		
		
		Дата = ?(ЗначениеЗаполнено(ДокументОснование), ДокументОснование.Дата, ТекущаяДата());			
		ТтнСерия = ""; 
		Если Не ЗначениеЗаполнено( ТтнНомер ) Тогда 
			ТтнНомер = кб99_ВСД_Общий.ПолучитьНомерДокБезПрефикса( ДокументОснование );
		КонецЕсли;
		Если Не ЗначениеЗаполнено( ТтнДата ) Тогда 
			ТтнДата = Дата; 
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("НомерАвто") Тогда
			НомерАвто = ДанныеЗаполнения.НомерАвто;
		Иначе
			НомерАвто = кб99_ВСД_Общий.ПолучитьНомерАвто( ДокументОснование );
		КонецЕсли;
		
		Если ПараметрыОрганизации.Свойство("ВСД_Местность") Тогда 
			Местность = ПараметрыОрганизации["ВСД_Местность"];
		КонецЕсли;
		Если ПараметрыОрганизации.Свойство("ВСД_ОсобыеОтметки") Тогда 
			ОсобыеОтметки = ПараметрыОрганизации["ВСД_ОсобыеОтметки"];
		КонецЕсли;
		cargoInspected = Истина;			
		Если ПараметрыОрганизации.Свойство("ВСД_РезультатыИсследований") Тогда 
			РезультатыИсследований = ПараметрыОрганизации["ВСД_РезультатыИсследований"]; 
		КонецЕсли;
	ИначеЕсли (ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ВСД2_транзакция")) Тогда
		
		ДокументОснование = ДанныеЗаполнения;
		Дата = ТекущаяДата();
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, , "Номер, Дата, ДокументОснование, Товары, УровниУпаковки, Маркировка, УсловияПеревозки, ТочкиМаршрута" );
		ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры(ДанныеЗаполнения.Организация);
		кб99_ВСД_Общий.ЗаполнитьКорректировочныйВСД(ПараметрыОрганизации, ДанныеЗаполнения, ЭтотОбъект);
		Если Товары.Количество() = 0 Тогда
			кб99_ВСД.СообщитьИнфо("Нет данных для создания корректирвочного ВСД");
			Возврат;
		КонецЕсли;
	ИначеЕсли ДанныеЗаполнения <> Неопределено Тогда
		//Перемещение
		//Списание
		//Расходный Ордер
		
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		Организация = ДокументОснование.Организация;		
		
		ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Организация );
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыОрганизации );
		
		ЭтоПеремещениеОтПоставщика = ОтПоставщика;
		
		ПараметрыДокумента = ПолучитьДанныеДляСозданияВСДТранзакции( ПараметрыОрганизации );
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыДокумента );
		
		Если ЗначениеЗаполнено(ДокументОснование) Тогда 
			Дата = ДокументОснование.Дата;
		Иначе
			Дата = ТекущаяДата();			
		КонецЕсли;
		
		ТтнСерия = ""; 
		ТтнНомер = кб99_ВСД_Общий.ПолучитьНомерДокБезПрефикса( ДокументОснование );
		ТтнДата = Дата; 
		номерАвто = кб99_ВСД_Общий.ПолучитьНомерАвто( ДокументОснование ); 
		
		Местность 		= ПараметрыОрганизации["ВСД_Местность"];
		ОсобыеОтметки 	= ПараметрыОрганизации["ВСД_ОсобыеОтметки"];
		cargoInspected  	= Истина;			
		РезультатыИсследований = ПараметрыОрганизации["ВСД_РезультатыИсследований"]; 
		
		ЗаполнитьЗначенияСвойств( ПараметрыОрганизации, ПараметрыДокумента ); // Заполняем Получатель Площадка
		
		Если ЗначениеЗаполнено( Отправитель_Площадка ) Тогда 
			кб99_ВСД_Общий.ЗаполнитьТабЧастьВСД( ПараметрыОрганизации, ДокументОснование, ЭтотОбъект );
		Иначе
			кб99_ВСД.СообщитьИнфо("Не заполнена Площадка Отправитель, проверьте соответствия");
		КонецЕсли;
	
	КонецЕсли;
	
	Если Не (ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ВСД2_транзакция")) Тогда
		кб99_ВСД_Общий.ЗаполнитьСвязанныеДокументы( ЭтотОбъект ); 	
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если кб99_ВСД_Общий.ФормироватьДвиженияПартий(Организация) Тогда
		Если Не СтатусВСД = Перечисления.кб99_СтатусВСД.CONFIRMED Тогда
			кб99_ВСД.СообщитьИнфо("Документ не обработан. Проведение запрещено");
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Движения.кб99_ОстаткиПартийВСД.Записывать = Истина;
		Движения.Записать();
		
		Движения.кб99_ОстаткиПартийВСД.Записывать = Истина;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВСД2_транзакцияТовары.Партия КАК Партия,
		|	СУММА(ВСД2_транзакцияТовары.Количество) КАК Количество
		|ИЗ
		|	Документ.ВСД2_транзакция.Товары КАК ВСД2_транзакцияТовары
		|ГДЕ
		|	ВСД2_транзакцияТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ВСД2_транзакцияТовары.Партия";	
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			// регистр кб99_ОстаткиПартийВСД Расход
			Движение				 = Движения.кб99_ОстаткиПартийВСД.Добавить();
			Движение.ВидДвижения	 = ВидДвиженияНакопления.Расход;
			Движение.Период			 = Дата;
			Движение.Партия			 = Выборка.Партия;
			Движение.Количество		 = Выборка.Количество;	
		КонецЦикла
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если кб99_ВСД_Общий.ФормироватьДвиженияПартий(Организация) И СтатусВСД = Перечисления.кб99_СтатусВСД.CONFIRMED Тогда
		кб99_ВСД.СообщитьИнфо("Документ был отправлен в Меркурий, после отмены проведения выполните корректировку остатков партий документом ""Партии ВСД""");
	КонецЕсли;

КонецПроцедуры
