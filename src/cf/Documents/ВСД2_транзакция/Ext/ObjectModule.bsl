﻿Перем мНеОткрыватьФормуДокумента Экспорт;  //Запрешает открывать форму при вводе на основании, если уже введен ВСД2 Транзакция

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

		Если (ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваровУслуг")) или
			(ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПеремещениеТоваров")) Тогда
			// Заполнение шапки

			//Найдем уже созданный
			ДокВСД = ВСД.НайтиВСД2(ДанныеЗаполнения.Ссылка);
			Если ЗначениеЗаполнено(ДокВСД) Тогда
				Сообщить("Уже создан "+ДокВСД);
				//Форма = ДокВСД.ПолучитьФорму();
				//Форма.Открыть();
				мНеОткрыватьФормуДокумента = Истина;
				Возврат;
			КонецЕсли;
			
			ДокументОснование = ДанныеЗаполнения.Ссылка;
			Организация = ДанныеЗаполнения.Организация;
			Обработка = ВСД.ИнициализацияОбработки(Организация);   // воспользуемся ф-цией ЗаполнитьТЧВСД() или РассчитатьКоличествоДляВСД()
			Если типЗнч(Обработка) = Тип("Строка") тогда
				Сообщить("Не удалось инициализировать обработку Интеграция");
				Возврат;
			КонецЕсли;
			
			СписокПараметров = ВСД.ЗагрузитьПараметры( ДанныеЗаполнения.Организация );
			//КонтрагентОрганизации = ВСД.НайтиКонтрагентаОрганизации(ДанныеЗаполнения.Организация);
			Отправитель_ХозСубъект = СписокПараметров.Получить("Отправитель_ХозСубъект");//ВСД.НайтиХозСубъект(КонтрагентОрганизации);			
			Перевозчик_ХозСубъект = СписокПараметров.Получить("Перевозчик_ХозСубъект");
			
			РеквизитГрузополучатель 	= СписокПараметров.Получить("РеквизитГрузополучатель");
			
			Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
				Отправитель_Площадка = ВСД.НайтиПлощадкуПоСкладу(ДокументОснование.Склад, Отправитель_ХозСубъект);
				Получатель_ХозСубъект = ВСД.НайтиХозСубъект(ДанныеЗаполнения.Контрагент);				
				номерАвто = ВСД.ПолучитьНомерАвто(ДанныеЗаполнения.Ссылка); //Газель
				
				Если РеквизитГрузополучатель = 0 Тогда 
					//контрагент
					Получатель_Площадка = ВСД.НайтиПлощадкуПоКонтрагенту(ДанныеЗаполнения.Контрагент);
				Иначе
					//Адрес доставки
					Получатель_Площадка = ВСД.НайтиПлощадкуПоКонтрагенту(ДанныеЗаполнения.АдресДоставки);
				КонецЕсли;
				
			Иначе //Перемещение
				Отправитель_Площадка = ВСД.НайтиПлощадкуПоСкладу(ДокументОснование.СкладОтправитель, Отправитель_ХозСубъект);
				Получатель_ХозСубъект = Отправитель_ХозСубъект;
				
				номерАвто = "Не используется"; 
//				Если РеквизитГрузополучатель = 0 Тогда 
					//контрагент
					Получатель_Площадка = ВСД.НайтиПлощадкуПоСкладу(ДокументОснование.СкладПолучатель, Получатель_ХозСубъект);
					//Получатель_Площадка = ВСД.НайтиПлощадкуПоКонтрагенту(ДанныеЗаполнения.СкладПолучатель);
//				Иначе
					//Адрес доставки
					//проверить!!
//					Получатель_Площадка = ВСД.НайтиПлощадкуПоКонтрагенту(ДанныеЗаполнения.СкладПолучатель);
//				КонецЕсли;

			КонецЕсли;
			
//			Перевозчик_ХозСубъект = Отправитель_ХозСубъект;
			
			ТтнНомер = ДанныеЗаполнения.Номер;
			ТтнДата = ДанныеЗаполнения.Дата;
			
			РезультатыИсследований = СписокПараметров.Получить("ВСД_РезультатыИсследований");
			cargoInspected = true;			
			
			Если НЕ(ЗначениеЗаполнено( Отправитель_Площадка )) Тогда 
				Отправитель_Площадка = СписокПараметров.Получить("Отправитель_Площадка");				
			КонецЕсли;			
			
			
			//Экспертиза = СписокПараметров.Получить("ВСД_Экспертиза");
			Местность = СписокПараметров.Получить("ВСД_Местность");
			ОсобыеОтметки = СписокПараметров.Получить("ВСД_ОсобыеОтметки");
			ТермическоеСостояние = 4;
			ПропускатьПустыеСвойства = СписокПараметров.Получить("ПропускатьПустыеСвойства");
			Попытка 
				//Обработка.ЗаполнитьТЧВСД(ДанныеЗаполнения, Товары, УровниУпаковки, Маркировка , ТермическоеСостояние, СписокПараметров);
				Обработка.ЗаполнитьТЧВСД(ДанныеЗаполнения, ЭтотОбъект);
				Возврат;
			Исключение 
				Сообщить("Не удалось заполнить ТЧ Транзакции из Интеграции - используем код модуля документа");
				Сообщить(ОписаниеОшибки(),СтатусСообщения.Важное);
			КонецПопытки;
			
			Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
				Продукция_Элемент = ВСД.Получить_ВСД_Продукция_Элемент( ТекСтрокаТовары.Номенклатура );
				Если НЕ ЗначениеЗаполнено(Продукция_Элемент) Тогда
					Сообщить("Не указано соответствие для "+ТекСтрокаТовары.Номенклатура);
					Если ПропускатьПустыеСвойства Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				
				НоваяСтрока = Товары.Добавить();
				НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
				НоваяСтрока.Продукция_Элемент = Продукция_Элемент;//ВСД.Получить_ВСД_Продукция_Элемент( НоваяСтрока.Номенклатура );
				НоваяСтрока.Партия = ВСД.ВыбратьПартию(НоваяСтрока.Продукция_Элемент, Отправитель_Площадка, Отправитель_ХозСубъект );
				НоваяСтрока.Количество = Обработка.РассчитатьКоличествоДляВСД(ТекСтрокаТовары);
				НоваяСтрока.Артикул = НоваяСтрока.Продукция_Элемент.Артикул;
				НоваяСтрока.GTIN = НоваяСтрока.Продукция_Элемент.GTIN;
				НоваяСтрока.ЕдиницаИзмерения = НоваяСтрока.Партия.ЕдиницаИзмерения;	
				
				ТермическоеСостояние = МИН(НоваяСтрока.Продукция_Элемент.ТермическиеУсловияПеревозки,ТермическоеСостояние) ;
			КонецЦикла;
			ТермическоеСостояние = ?(ТермическоеСостояние=0,1,ТермическоеСостояние);
		КонецЕсли;
	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
КонецПроцедуры

мНеОткрыватьФормуДокумента = ложь;
