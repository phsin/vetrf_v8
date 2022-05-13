﻿Перем мНеОткрыватьФормуДокумента Экспорт;  //Запрешает открывать форму при вводе на основании, если уже введен ВСД 
Перем ПараметрыОрганизации Экспорт;

Функция ВСД2_Производство_ЗаполнитьДатыИзготовления( стрПродукция, ВыбДата ) 
	
	ПереопределенныйМодуль = кб99_ВСД_Общий.ФункцияПереопределена("ВСД2_Производство_ЗаполнитьДатыИзготовления");
	Если ПереопределенныйМодуль <> Неопределено Тогда
		Возврат ПереопределенныйМодуль.ВСД2_Производство_ЗаполнитьДатыИзготовления( ПараметрыОрганизации, стрПродукция, ВыбДата );
	КонецЕсли;
	
	стрПродукция.ДатаИзготовления1 = ВыбДата;		
	стрПродукция.ДатаСрокГодности1 = стрПродукция.ДатаИзготовления1+60*60*24*стрПродукция.Продукция_Элемент.СрокГодности;		
		
КонецФункции 

Процедура ЗаполнитьПоРеализации( ДанныеЗаполнения )
	
		// Заполнение шапки
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		Организация = ДанныеЗаполнения.Организация;
		Дата =  ДанныеЗаполнения.Дата;
		
		ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Организация );	

		Если НЕ ЗначениеЗаполнено(ПараметрыОрганизации["ПарамРазрешитьВводНаОснованииБолееОдногоВСД"] ) Тогда
			Сообщить("Сохраните параметры для Организации "+ДанныеЗаполнения.Организация);
			Возврат;
		КонецЕсли;			
		
		Если НЕ ПараметрыОрганизации["ПарамРазрешитьВводНаОснованииБолееОдногоВСД"] Тогда		
			ДокВСД = кб99_ВСД.НайтиВСД_Производство(ДанныеЗаполнения.Ссылка);
			Если ЗначениеЗаполнено(ДокВСД) Тогда
				Сообщить("Уже создан "+ДокВСД);				
				мНеОткрыватьФормуДокумента = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
			
		Производитель_ХозСубъект = ПараметрыОрганизации["Отправитель_ХозСубъект"];//ВСД.НайтиХозСубъект(КонтрагентОрганизации);
		Попытка
			Производитель_Площадка = кб99_ВСД.НайтиПлощадкуПоСкладу(ДокументОснование.Склад, Производитель_ХозСубъект);
		Исключение			
		КонецПопытки;
		Если НЕ ЗначениеЗаполнено( Производитель_Площадка ) Тогда 
			Производитель_Площадка = ПараметрыОрганизации["Отправитель_Площадка"];
		КонецЕсли;
		ЗавершитьОперацию = true;
		cargoInspected = true;
		РезультатыИсследований = ПараметрыОрганизации["ВСД_РезультатыИсследований"];//Перечисления.ВСД_РезультатИсследования.VSEFULL;
			
		Если ПараметрыОрганизации["ПарамИспользоватьСерииПродукции"] Тогда 
			//заполняем по ТЧ СерииПродукции
			Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.СерииПродукции Цикл
				Продукция_Элемент = кб99_ВСД.Продукция_Элемент_ПолучитьПоНоменклатуре( ТекСтрокаТовары.Номенклатура, ДанныеЗаполнения.Контрагент );
				Если ПараметрыОрганизации["ПропускатьПустыеСвойства"] Тогда
					Если НЕ ЗначениеЗаполнено(Продукция_Элемент) Тогда
						Сообщить("Не указано соответствие для "+ТекСтрокаТовары.Номенклатура+" -> в параметрах указано Пропускать");
						Продолжить;
					КонецЕсли;
				КонецЕсли;
			
				НоваяСтрока = Продукция.Добавить();
				НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
				НоваяСтрока.Продукция_Элемент = Продукция_Элемент;//ВСД.Получить_ВСД_Продукция_Элемент( НоваяСтрока.Номенклатура );
			
				НоваяСтрока.Продукция = НоваяСтрока.Продукция_Элемент.Продукция ;
				НоваяСтрока.ВидПродукции =  НоваяСтрока.Продукция_Элемент.ВидПродукции;
				НоваяСтрока.НаименованиеПродукции =  НоваяСтрока.Продукция_Элемент.Наименование;
				НоваяСтрока.ЕдиницаИзмерения = НоваяСтрока.Продукция_Элемент.ЕдиницаИзмерения;	
				НоваяСтрока.НомерПартии = кб99_ВСД_Производство.ПолучитьНомерПартии(ПараметрыОрганизации, ТекСтрокаТовары);
			    Попытка
					НоваяСтрока.Количество = кб99_ВСД_Общий.РассчитатьКоличествоДляВСД(ПараметрыОрганизации, ТекСтрокаТовары, НоваяСтрока.Продукция_Элемент);
				Исключение
					Сообщить(ОписаниеОшибки());
					НоваяСтрока.Количество = ТекСтрокаТовары.Количество;
				КонецПопытки;
				
				ВСД2_Производство_ЗаполнитьДатыИзготовления( НоваяСтрока, ДанныеЗаполнения.Дата );
				
			КонецЦикла;
			
		Иначе
			//заполняем по ТЧ Товары
			Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
				Продукция_Элемент = кб99_ВСД.Продукция_Элемент_ПолучитьПоНоменклатуре( ТекСтрокаТовары.Номенклатура, ДанныеЗаполнения.Контрагент );
				Если ПараметрыОрганизации["ПропускатьПустыеСвойства"] Тогда
					Если НЕ ЗначениеЗаполнено(Продукция_Элемент) Тогда
						Сообщить("Не указано соответствие для "+ТекСтрокаТовары.Номенклатура+" -> в параметрах указано Пропускать");
						Продолжить;
					КонецЕсли;
				КонецЕсли;
			
				НоваяСтрока = Продукция.Добавить();
				НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
				НоваяСтрока.Продукция_Элемент = Продукция_Элемент;//ВСД.Получить_ВСД_Продукция_Элемент( НоваяСтрока.Номенклатура );
			
				НоваяСтрока.Продукция = НоваяСтрока.Продукция_Элемент.Продукция ;
				НоваяСтрока.ВидПродукции =  НоваяСтрока.Продукция_Элемент.ВидПродукции;
				НоваяСтрока.НаименованиеПродукции =  НоваяСтрока.Продукция_Элемент.Наименование;
				НоваяСтрока.ЕдиницаИзмерения = НоваяСтрока.Продукция_Элемент.ЕдиницаИзмерения;	
			    Попытка
					НоваяСтрока.Количество = кб99_ВСД_Общий.РассчитатьКоличествоДляВСД(ПараметрыОрганизации, ТекСтрокаТовары, НоваяСтрока.Продукция_Элемент);
				Исключение
					Сообщить(ОписаниеОшибки());
					НоваяСтрока.Количество = ТекСтрокаТовары.Количество;
				КонецПопытки;
				
				ВСД2_Производство_ЗаполнитьДатыИзготовления( НоваяСтрока, ДанныеЗаполнения.Дата );
				
			КонецЦикла;
		КонецЕсли		
	
КонецПроцедуры
	
Процедура ЗаполнитьПоТЗ( тзПартии, ВыбДата=Неопределено, ПараметрыОрганизации)	
	
	Если НЕ ЗначениеЗаполнено(ВыбДата) Тогда 
		ВыбДата = ТекущаяДата();
	КонецЕсли;
	
	ПараметрыОрганизации["Отправитель_Площадка"] = Производитель_Площадка;
	
	//Таблица Партий для произвосдтва
	Для Каждого стрПартий Из тзПартии Цикл
		Если НЕ(ЗначениеЗаполнено(стрПартий.Продукция_Элемент)) Тогда
			кб99_ВСД.СообщитьИнфо("В строке партий № "+(тзПартии.Индекс(стрПартий)+1)+"  не указан ВСД_Продукция_Элемент. Пропускаем...");
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(стрПартий.Партия) Тогда
			кб99_ВСД.СообщитьИнфо("В строке партий № "+(тзПартии.Индекс(стрПартий)+1)+" указана партия. Пропускаем...");
			Продолжить;
		КонецЕсли;
		Если СтрПартий.КоличествоСписания <= СтрПартий.Количество Тогда
			Продолжить;	
		КонецЕсли;
		
		Если НЕ(ЗначениеЗаполнено(стрПартий.Продукция_Элемент.ЕдиницаИзмерения)) Тогда
			кб99_ВСД.СообщитьИнфо("В строке партий № "+(тзПартии.Индекс(стрПартий)+1)+" у "+СокрЛП(стрПартий.Продукция_Элемент.Наименование)+" не указана Единица измерения. Пропускаем...");
			Продолжить;
		КонецЕсли;
		
		Если НЕ(ЗначениеЗаполнено(стрПартий.Продукция_Элемент.СрокГодности)) Тогда
			кб99_ВСД.СообщитьИнфо("В строке партий № "+(тзПартии.Индекс(стрПартий)+1)+" у "+СокрЛП(стрПартий.Продукция_Элемент.Наименование)+" не указан Срок годности. Пропускаем...");
			Продолжить;
		КонецЕсли;
		// Возможно несколько производителей-площадок  / продумать
		//Если НЕ(стрПартий.Продукция_Элемент.Площадка = ПараметрыОрганизации["Отправитель_Площадка"] )  Тогда
		//	кб99_ВСД.СообщитьИнфо("В строке партий № "+стрПартий.НомерСтроки+" у "+СокрЛП(стрПартий.Продукция_Элемент.Наименование)+" Производителем является "+стрПартий.Продукция_Элемент.Площадка+". Пропускаем...");
		//	Продолжить;
		//КонецЕсли;
		КоличествоНом =  стрПартий.КоличествоСписания - стрПартий.Количество;
		стрПродукция = Продукция.Добавить();	
		стрПродукция.Продукция_Элемент 	= стрПартий.Продукция_Элемент;
		стрПродукция.Количество 		= КоличествоНом + КоличествоНом/100*ПараметрыОрганизации["КоэфПересчетаКоличестваПриПроизводстве"] ;
		стрПродукция.ЕдиницаИзмерения 	= стрПродукция.Продукция_Элемент.ЕдиницаИзмерения;
		стрПродукция.Продукция 			= стрПродукция.Продукция_Элемент.Продукция;
		стрПродукция.ВидПродукции 		= стрПродукция.Продукция_Элемент.ВидПродукции;
		стрПродукция.НаименованиеПродукции = стрПродукция.Продукция_Элемент.Наименование;
		стрПродукция.Номенклатура 		= кб99_ВСД.ПолучитьНоменклатуруПоПродукцияЭлемент( стрПартий.Продукция_Элемент, Истина );					
		стрПродукция.НомерПартии 		= кб99_ВСД_Производство.ПолучитьНомерПартии(ПараметрыОрганизации, стрПродукция);	
		
		ВСД2_Производство_ЗаполнитьДатыИзготовления( стрПродукция, ВыбДата );
		
	КонецЦикла;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ПереопределенныйМодуль = кб99_ВСД_Общий.ФункцияПереопределена("ВСД2_Производство_ОбработкаЗаполнения");
	Если ПереопределенныйМодуль <> Неопределено Тогда
		ПереопределенныйМодуль.ВСД2_Производство_ОбработкаЗаполнения( ДанныеЗаполнения, СтандартнаяОбработка );
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваровУслуг")  или
		(ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПеремещениеТоваров")) Тогда
		
		ЗаполнитьПоРеализации( ДанныеЗаполнения );
					
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда 
		// заполнение из групповой обработки 
		ПараметрыОрганизации = ДанныеЗаполнения.ПараметрыОрганизации;
		
		ЗаполнитьПоТЗ( ДанныеЗаполнения["тзПартии"], ДанныеЗаполнения["ВыбДата"], ПараметрыОрганизации);
	КонецЕсли;
		
	Попытка
		Если ПараметрыОрганизации["ПарамПроизводствоЗаполнятьПоСправочнику"] Тогда 			
			тзПартии = кб99_ВСД_Производство.ЗаполнитьТчСписаниеИзСпецификацииНоменклатуры( ПараметрыОрганизации, Продукция.Выгрузить() );
		Иначе
			Сырье = кб99_ВСД_Производство.ЗаполнитьСырьеИзВСД_Продукция_Элемент( Продукция.Выгрузить() );
			тзПартии = кб99_ВСД.тзПартииСписанияПоТзПродукция_Элемент( ПараметрыОрганизации, Сырье );
		КонецЕсли;
		ПартииСписания.Загрузить( тзПартии );
		Если ЗначениеЗаполнено(тзПартии) Тогда
			ПолучитьВторичнуюПродукциюПриПереработке(ДанныеЗаполнения, тзПартии);	
		КонецЕсли;
	Исключение
		кб99_ВСД.СообщитьИнфо("Не удалось загрузить партии списания");
	КонецПопытки;			

КонецПроцедуры

// Заполним вторичную продукцию если такая имеется при переработке используемого сырья.
Процедура ПолучитьВторичнуюПродукциюПриПереработке(ДанныеЗаполнения, тзПартииСписания)
	
	ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Организация );
	Попытка
		тзВторичнаяПродукция = Новый ТаблицаЗначений;
		тзВторичнаяПродукция.Колонки.Добавить("Продукция_Элемент",новый ОписаниеТипов("СправочникСсылка.ВСД_Продукция_Элемент"));
		тзВторичнаяПродукция.Колонки.Добавить("Количество",новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15, 3)));
		
		тзПартииСписания.Свернуть("Продукция_Элемент", "Количество");
		Для Каждого СтрСырье Из тзПартииСписания Цикл
			ВторичнаяПродукция = СтрСырье.Продукция_Элемент.ВторичнаяПродукцияПриПереработке.Выгрузить();
			Для Каждого СтрВторПродукция Из ВторичнаяПродукция Цикл
				нСтр = тзВторичнаяПродукция.Добавить();
				нСтр.Продукция_Элемент = СтрВторПродукция.Продукция_Элемент;
				нСтр.Количество = СтрСырье.Количество/100*СтрВторПродукция.Коэффициент;
			КонецЦикла;
		КонецЦикла;
		
		тзВторичнаяПродукция.Свернуть("Продукция_Элемент", "Количество");
		Для Каждого стрВторПродукция Из тзВторичнаяПродукция Цикл
			стрПродукция = Продукция.Добавить();	
			стрПродукция.Продукция_Элемент 	= СтрВторПродукция.Продукция_Элемент;
			стрПродукция.Количество 		= стрВторПродукция.Количество;
			стрПродукция.ЕдиницаИзмерения 	= стрПродукция.Продукция_Элемент.ЕдиницаИзмерения;
			стрПродукция.Продукция 			= стрПродукция.Продукция_Элемент.Продукция;
			стрПродукция.ВидПродукции 		= стрПродукция.Продукция_Элемент.ВидПродукции;
			стрПродукция.НаименованиеПродукции = стрПродукция.Продукция_Элемент.Наименование;
			стрПродукция.Номенклатура 		= кб99_ВСД.ПолучитьНоменклатуруПоПродукцияЭлемент(стрПродукция.Продукция_Элемент, Истина );					
			стрПродукция.НомерПартии 		= кб99_ВСД_Производство.ПолучитьНомерПартии(ПараметрыОрганизации, стрПродукция);	
			ВыбДата = ДанныеЗаполнения["ВыбДата"];
			Если НЕ ЗначениеЗаполнено(ВыбДата) Тогда 
				ВыбДата = ТекущаяДата();
			КонецЕсли;
			// Если биоотходы: Некачественный = ИСТИНА;
			// ДатаСрокГодности не заполняется;	
			Если стрПродукция.Продукция.GUID = "ae1a8750-3faf-4d93-b2d9-1f2111486d34" Тогда 
				стрПродукция.ДатаИзготовления1 = ВыбДата;
				стрПродукция.Некачественный = Истина;
			Иначе
				ВСД2_Производство_ЗаполнитьДатыИзготовления( стрПродукция, ВыбДата );
			КонецЕсли;
		КонецЦикла;
	Исключение
		кб99_ВСД.СообщитьИнфо("Не удалось заполнить вторичную продукцию при переработке сырья");
	КонецПопытки;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОтправкаПоРасписанию Тогда
		Если ЗначениеЗаполнено(ДатаОтправки) Тогда
			Если Не ЗавершитьОперацию Тогда // контроль что отправка раньше чем запланировано завершение производства
				Запрос = Новый Запрос;
				Запрос.Текст = 
				"ВЫБРАТЬ
				|	ВСД2_Производство.Ссылка КАК ДокПроизводство
				|ИЗ
				|	Документ.ВСД2_Производство КАК ВСД2_Производство
				|ГДЕ
				|	ВСД2_Производство.operationId ПОДОБНО &operationId
				|	И ВСД2_Производство.Ссылка <> &Ссылка
				|	И НЕ ВСД2_Производство.ПометкаУдаления
				|	И ВЫБОР
				|			КОГДА ВСД2_Производство.ЗавершениеПоРасписанию
				|				ТОГДА ВСД2_Производство.ДатаЗавершения < &ДатаОтправки
				|			ИНАЧЕ ЛОЖЬ
				|		КОНЕЦ
				|	И НЕ ВСД2_Производство.ЗавершитьОперацию";
				Запрос.УстановитьПараметр("operationId", operationId);
				Запрос.УстановитьПараметр("Ссылка", Ссылка);
				Запрос.УстановитьПараметр("ДатаОтправки", ДатаОтправки);
				Результат = Запрос.Выполнить();
				Если Не Результат.Пустой() Тогда
					Выборка = Результат.Выбрать();
					Пока Выборка.Следующий() Цикл
						кб99_ВСД.СообщитьПользователю(СтрШаблон("В документе: %1 запланировано завершение производственной транзакции с номером %2 раньше даты отправки текущего документа", Выборка.ДокПроизводство, operationId),
						Выборка.ДокПроизводство,,Выборка.ДокПроизводство, Отказ);	
					КонецЦикла;	
				КонецЕсли;
			КонецЕсли;
		Иначе
			кб99_ВСД.СообщитьПользователю("Заполните дату отправки документа",,,,Отказ);		
		КонецЕсли;
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗавершениеПоРасписанию Тогда
		
		Если Не ЗначениеЗаполнено(ДатаЗавершения) Тогда
			кб99_ВСД.СообщитьПользователю("Не указана дата завершения производства",,,,Отказ);		
		КонецЕсли;
		
		Если ОтправкаПоРасписанию И ДатаОтправки>ДатаЗавершения Тогда
			кб99_ВСД.СообщитьПользователю("Дата отправки не может быть позднее даты завершения",,,,Отказ);		
		КонецЕсли;
		
		Если ЗначениеЗаполнено(operationId) Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВСД2_Производство.Ссылка КАК ДокПроизводство
			|ИЗ
			|	Документ.ВСД2_Производство КАК ВСД2_Производство
			|ГДЕ
			|	ВСД2_Производство.ЗавершениеПоРасписанию
			|	И НЕ ВСД2_Производство.ЗавершитьОперацию
			|	И ВСД2_Производство.operationId ПОДОБНО &operationId
			|	И НЕ ВСД2_Производство.ПометкаУдаления
			|	И ВСД2_Производство.Ссылка <> &Ссылка";
			Запрос.УстановитьПараметр("operationId", operationId);
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Результат = Запрос.Выполнить();
			
			Если Не Результат.Пустой() Тогда
				Выборка = Результат.Выбрать();
				Пока Выборка.Следующий() Цикл
					кб99_ВСД.СообщитьПользователю(СтрШаблон("Уже запланировано завершение производственной транзакция с номером %1 документ: %2", operationId, Выборка.ДокПроизводство),
												  Выборка.ДокПроизводство,,Выборка.ДокПроизводство,Отказ);	
				КонецЦикла;
			КонецЕсли;
		Иначе
			кб99_ВСД.СообщитьПользователю("Заполните номер незавершенного производства",,,,Отказ);	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

мНеОткрыватьФормуДокумента = Ложь;

