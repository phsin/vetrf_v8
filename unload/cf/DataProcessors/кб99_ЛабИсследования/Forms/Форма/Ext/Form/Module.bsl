﻿&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;

&НаКлиенте
Перем ПараметрыОбработчикаОжидания Экспорт;

&НаКлиенте
Перем АдресПараметров Экспорт;

&НаСервере
Функция ПолучитьСообщенияНаСервере( ) 
    
	// Сообщения=ПолучитьСообщенияПользователю(Истина);
	Попытка		
		Сообщения = ДлительныеОперации.СообщенияПользователю( Истина, ИдентификаторЗадания );
	Исключение
		// если в ОбщемМодуле нет функции 
		// например в Бухгалтерии 2.0
		Сообщения = кб99_ВСД_Общий.СообщенияПользователю( Истина, ИдентификаторЗадания );
	КонецПопытки;
	
 	Возврат Сообщения;
    
КонецФункции

&НаКлиенте
Процедура ЗакрытьФормуДлительнойОперации()
	
	ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации( ФормаДлительнойОперации );
	
	// Если ТипЗнч(ФормаДлительнойОперации) = Тип("УправляемаяФорма") Тогда
	//	Если ФормаДлительнойОперации.Открыта() Тогда
	//		ФормаДлительнойОперации.Закрыть();
	//	КонецЕсли;
	// КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ЗаданиеВыполнено() 
	Возврат ДлительныеОперации.ЗаданиеВыполнено( ИдентификаторЗадания );
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	МассивСообщений = ПолучитьСообщенияНаСервере( );
	// МассивСообщений = ПолучитьСообщенияПользователю(Истина);
	Для Каждого Сообщение Из МассивСообщений Цикл
		Сообщение.Сообщить();
		Сообщение.ИдентификаторНазначения = УникальныйИдентификатор;
		Сообщение.Сообщить();
	КонецЦикла;
	
	Попытка
		Если ЗаданиеВыполнено() Тогда 
			// ЗагрузитьПодготовленныеДанные();
			ЗагрузитьПараметры( );
			
			ЗакрытьФормуДлительнойОперации();
			Возврат;
		КонецЕсли;		
	Исключение
		ЗакрытьФормуДлительнойОперации();
		ВызватьИсключение;
	КонецПопытки;
 
	ПараметрыОбработчикаОжидания.ТекущийИнтервал = ПараметрыОбработчикаОжидания.ТекущийИнтервал * ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала;
	Если ПараметрыОбработчикаОжидания.ТекущийИнтервал > ПараметрыОбработчикаОжидания.МаксимальныйИнтервал Тогда
		ПараметрыОбработчикаОжидания.ТекущийИнтервал = ПараметрыОбработчикаОжидания.МаксимальныйИнтервал;
	КонецЕсли;
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
КонецПроцедуры

&НаСервере
// как результат выполнения функции в фоне
Процедура ЗагрузитьПараметры( )
	ФОбъект = РеквизитФормыВЗначение("Объект");
	
	Попытка
		Результат = ПолучитьИзВременногоХранилища( АдресХранилища );
		
		Если ЗначениеЗаполнено( Результат["Параметры"] ) Тогда 	
			кб99_ВСД.ЗагрузитьПараметрыВОбработку( ФОбъект , Результат["Параметры"] );
		КонецЕсли;
	Исключение КонецПопытки;
	
	// ФОбъект.ЗагрузитьПараметры(ФОбъект.Организация);
	// ФОбъект.ЗаполнитьТабличныеЧасти(флПеремещения);
	ЗначениеВРеквизитФормы(ФОбъект, "Объект");			
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТабличныеЧасти()
	
    Запрос = Новый Запрос;	
    Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

    Запрос.Текст =
    "ВЫБРАТЬ
    |	ВСД_Партия.Ссылка КАК Партия,
    |	ВСД_Партия.ВсдДата КАК ВсдДата,
    |	ВСД_Партия.ДатаИзготовления1 КАК ДатаИзготовления1,
    |	ВСД_Партия.Продукция_Элемент КАК Продукция,
    |	ВСД_Партия.НомерЗаписи КАК НомерЗаписи,
    |	ВСД_Партия.Статус КАК СтатусПартии,
    |	ВСД_Партия.Количество КАК Количество,
    |	ВСД2_ЛабораторныеИсследования.Ссылка КАК ЛабИсследования,
    |	кб99_ЗапросыСрезПоследних.СтатусЗапроса КАК СтатусЗапроса,
    |	кб99_ЗапросыСрезПоследних.ApplicationID КАК ApplicationID,
    |	кб99_ЗапросыСрезПоследних.Ошибки КАК Ошибки
    |ИЗ
    |	Справочник.ВСД_Партия КАК ВСД_Партия
    |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВСД2_ЛабораторныеИсследования КАК ВСД2_ЛабораторныеИсследования
    |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.кб99_Запросы.СрезПоследних КАК кб99_ЗапросыСрезПоследних
    |			ПО ВСД2_ЛабораторныеИсследования.Ссылка = кб99_ЗапросыСрезПоследних.Объект
    |		ПО (ВСД2_ЛабораторныеИсследования.Партия = ВСД_Партия.Ссылка)
    |			И (ВСД2_ЛабораторныеИсследования.ПометкаУдаления = ЛОЖЬ)
    |ГДЕ
    |	ВСД_Партия.ПометкаУдаления = ЛОЖЬ";

	Если ЗначениеЗаполнено( Объект.ДатаСоздания	) Тогда 
		Запрос.Текст = Запрос.Текст + "
		| И ВСД_Партия.ВсдДата = &ДатаСоздания";
		Запрос.УстановитьПараметр("ДатаСоздания", Объект.ДатаСоздания );
	КонецЕсли;
	Если ЗначениеЗаполнено( Объект.ВыбПродукция	) Тогда 
		Запрос.Текст = Запрос.Текст + "
		| И ВСД_Партия.Продукция_Элемент = &Продукция_Элемент";
		Запрос.УстановитьПараметр("Продукция_Элемент", Объект.ВыбПродукция );
	КонецЕсли;
	
    Попытка
        РезультатЗапроса = Запрос.Выполнить();
		
		Объект.Партии.Загрузить( РезультатЗапроса.Выгрузить());
    Исключение
        РезультатЗапроса = Неопределено;
        кб99_ВСД.СообщитьИнфо("Указан неверный параметр "+Описаниеошибки());
    КонецПопытки;

КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьТабличныеЧасти();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Объект.ДатаНачалаОтбора = НачалоДня(ТекущаяДата());
	// Объект.ДатаОкончанияОтбора = КонецДня(ТекущаяДата());
	//
	Объект.Организация = кб99_ВСД_Общий.ПолучитьОрганизациюПоУмолчанию();	
	// СписокКонстант = ВСД.ЗагрузитьПараметры( Объект.Организация );
	// ВСД.ЗагрузитьПараметрыВОбработку( Объект, СписокКонстант ); 
	
	//ЗаполнитьТабличныеЧасти();
	Попытка
		Если НЕ ЗначениеЗаполнено(Параметры.Док) Тогда
			ЗаполнитьТабличныеЧасти();
		Иначе
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ДокОснование", Параметры.Док);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ВСД_Партия.Продукция,
			|	ВСД_Партия.ДатаИзготовления1,
			|	ВСД_Партия.ВсдДата,
			|	ВСД_Партия.Количество,
			|	ВСД_Партия.Ссылка КАК Партия,
			|	ВСД_Партия.НомерЗаписи,
			|	ВСД_Партия.Статус КАК СтатусПартии
			|ИЗ
			|	Справочник.ВСД_Партия КАК ВСД_Партия
			|ГДЕ
			|	ВСД_Партия.ДокОснование = &ДокОснование";
			Рез = Запрос.Выполнить();
			Объект.Партии.Загрузить(Рез.Выгрузить());
			Объект.ВыбДокПроизводства = Параметры.Док;
		КонецЕсли;
	Исключение
		ЗаполнитьТабличныеЧасти();
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Процедура СоздатьЛИНаСервере()
		
	фОбъект = РеквизитФормыВЗначение("Объект");
	фОбъект.СоздатьЛИ();
	ЗначениеВРЕквизитФормы(фОбъект, "Объект");
		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЛИ(Команда)
	СоздатьЛИНаСервере();
КонецПроцедуры

&НаСервере
Функция ПодготовитьСписокВСДКОтправке() Экспорт
	
	сзДокументыКОтправке = новый Массив;
	Для Каждого СтрПартии Из Объект.Партии Цикл
		
		Если НЕ(ЗначениеЗаполнено(СтрПартии.ЛабИсследования)) или НЕ( СтрПартии.Пометка) Тогда 		
			Продолжить;    
		КонецЕсли;
		
		Если ( СтрПартии.СтатусЗапроса = "COMPLETED") или ( СтрПартии.ЛабИсследования.ПометкаУдаления ) Тогда
			// ВСД.СообщитьИнфоСервер("Документ ["+_ВСД+"] статус=["+_ВСД.Статус+"] уже был обработан");
			Продолжить;
		КонецЕсли;
		
		// Если ЗначениеЗаполнено( СтрПартии.ЛабИсследования.applicationID) и НЕ ОтправлятьРанееОтправленные Тогда 
		//	Продолжить;
		// КонецЕсли;
		
		сзДокументыКОтправке.Добавить( СтрПартии.ЛабИсследования );
		// ВСД.СообщитьИнфоСервер(""+_ВСД+" Добавлен в очередь на отправку");
	КонецЦикла;
	Возврат сзДокументыКОтправке;
КонецФункции

&НаСервере
Функция ОтправитьВСД_НаСервере( )
	
	сзДокументыКОтправке = ПодготовитьСписокВСДКОтправке( );	

	// ПараметрыОрганизации = ВСД.ЗагрузитьПараметры( Объект.Организация );									
	// ПараметрыФункции = ВСД_Общий.ПараметрыСервер( ПараметрыОрганизации );
	ПараметрыФункции = кб99_ВСД.ЗагрузитьПараметры( Объект.Организация );
	ПараметрыФункции.Вставить("СписокДокументов", сзДокументыКОтправке);
	
	Если Объект.ОтправлятьВФоне Тогда 
		ИдентификаторЗадания = Неопределено;		
		НаименованиеЗадания = НСтр("ru = 'Ветис отправка ВСД'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне( УникальныйИдентификатор, 
			"кб99_ВСД_Запросы.ОтправитьВСДвГИС",
			ПараметрыФункции,
			НаименованиеЗадания);
		
		// результат обработки
		АдресХранилища       = Результат.АдресХранилища;		
		// для получения сообщений
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
	Иначе;
		Для Каждого ДокСсылка Из сзДокументыКОтправке Цикл
			// ПараметрыФункции = ВСД.ЗагрузитьПараметры( ДокСсылка.Организация );
			Ответ = кб99_ВСД_Запросы.ВСД2_ЛабораторныеИсследования_Отправить( ПараметрыФункции, ДокСсылка);
		КонецЦикла;
		Результат = Новый Структура;
		Результат.Вставить("ЗаданиеВыполнено", Истина);
	КонецЕсли; 

	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура Отправить(Команда)	
	
	ПоказатьОповещениеПользователя("Выполняется отправка ВСД",,"Ожидайте...",БиблиотекаКартинок.Информация32);
	
	Результат = ОтправитьВСД_НаСервере( );
	
	Если Результат.ЗаданиеВыполнено Тогда
		// Задание отработало, результат получен
		ПоказатьОповещениеПользователя("Выполнено");
	ИначеЕсли ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;			
	
	ЗаполнитьТабличныеЧасти();
КонецПроцедуры

&НаСервере
Процедура СоздатьЛабИсследПоСырьюНаСервере()
	// Вставить содержимое обработчика.
	запрос=новый запрос;
	запрос.Текст= "ВЫБРАТЬ
	              |	ВСД2_ПроизводствоПартииСписания.Партия КАК ПартияСписания,
	              |	ВСД2_ПроизводствоПартииСписания.Количество КАК КоличествоСписания,
	              |	ВСД_Партия.ДокОснование КАК ДокОснование,
	              |	ВСД_Партия.Ссылка КАК Партия,
	              |	ВСД_Партия.Количество КАК Количество,
	              |	ВСД_Партия.ДатаИзготовления1 КАК ДатаИзготовления1,
	              |	ВСД_Партия.Статус КАК СтатусПартии,
	              |	ПОДСТРОКА(ВСД_Партия.НомерЗаписи, 1, 10) КАК НомерЗаписи,
	              |	ВСД_Партия.Продукция_Элемент КАК Продукция,
				  // | NULL КАК ЛабИсследования,
	              |	ВСД_Партия.ВсдДата КАК ВсдДата
	              |ИЗ
	              |	Документ.ВСД2_Производство.ПартииСписания КАК ВСД2_ПроизводствоПартииСписания
	              |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВСД_Партия КАК ВСД_Партия
	              |		ПО ВСД2_ПроизводствоПартииСписания.Ссылка = ВСД_Партия.ДокОснование
	              |ГДЕ
	              |	ВСД_Партия.ДокОснование = &ДокОснование
	              |	И ВСД_Партия.Статус = ""103""
	              |
	              |СГРУППИРОВАТЬ ПО
	              |	ВСД2_ПроизводствоПартииСписания.Партия,
	              |	ВСД_Партия.ДокОснование,
	              |	ВСД_Партия.Ссылка,
	              |	ВСД2_ПроизводствоПартииСписания.Количество,
	              |	ВСД_Партия.Количество,
	              |	ВСД_Партия.ДатаИзготовления1,
	              |	ПОДСТРОКА(ВСД_Партия.НомерЗаписи, 1, 10),
	              |	ВСД_Партия.Статус,
	              |	ВСД_Партия.Продукция_Элемент" ;
	
	запрос.УстановитьПараметр("ДокОснование", Объект.ВыбДокПроизводства );
	// запрос.УстановитьПараметр("КонДата", КонецДня( Объект.ДатаСоздания ));
	тзРезультатЗапроса = запрос.Выполнить().Выгрузить();
	
	тзРезультатЗапроса.Колонки.Добавить("ЛабИсследования");
	
	Для Каждого стр Из тзРезультатЗапроса Цикл
		лабы=стр.ПартияСписания.ЛабораторныеИсследования;
		Если лабы.Количество()=0 Тогда
			Продолжить;
		КонецЕсли;			
		
		новыйДок=документы.ВСД2_ЛабораторныеИсследования.СоздатьДокумент();
		новыйдок.дата=текущаядата();
		новыйдок.Партия = стр.Партия;
		новыйдок.Организация = Объект.Организация;
		новыйдок.Исследования.Загрузить( лабы.выгрузить() );
		Попытка
			новыйдок.записать(РежимЗаписиДокумента.Запись);	
		Исключение
			Сообщить(ОписаниеОшибки());
			Продолжить;
		КонецПопытки;
		стр.ЛабИсследования = НовыйДок.Ссылка;
	КонецЦикла;
	
	Объект.Партии.Загрузить( тзРезультатЗапроса );
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЛабИсследПоСырью(Команда)
	СоздатьЛабИсследПоСырьюНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсеНесозданные(Команда)
		
	Для Каждого стр Из Объект.Партии Цикл
		Если Стр.СтатусПартии = "102" или Стр.СтатусПартии = "103" Тогда
			 Стр.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеОтметки(Команда)
			
	Для Каждого стр Из Объект.Партии Цикл
		Если Стр.Пометка = Истина Тогда
			 Стр.Пометка = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
