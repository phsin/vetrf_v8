﻿&НаКлиенте
Перем АвтоЗаписьВСДСоответствия;

&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;

&НаКлиенте
Перем ПараметрыОбработчикаОжидания Экспорт;

&НаКлиенте
Перем АдресПараметров Экспорт;

#Область НемодальныеОкна
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

&НаСервере
Процедура ОбновитьДанныеКолонокТовары()
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВСД_Партия.Ссылка КАК Партия,
	|	ВСД_Партия.ДатаСрокГодности1 КАК ДатаСрокГодности,
	|	ВСД_Партия.ДатаСрокГодности2 КАК ДатаСрокГодности2,
	|	ВСД_Партия.ДатаИзготовления1 КАК ДатаИзготовления,
	|	ВСД_Партия.ДатаИзготовления2 КАК ДатаИзготовления2
	|ИЗ
	|	Справочник.ВСД_Партия КАК ВСД_Партия
	|ГДЕ
	|	ВСД_Партия.Ссылка В(&СписокПартий)"
	);
	Запрос.УстановитьПараметр("СписокПартий",Объект.Товары.Выгрузить().ВыгрузитьКолонку("Партия"));
	Выборка = Запрос.Выполнить().Выгрузить();// .Выбрать();
	Для Каждого Стр Из Объект.Товары Цикл
		СтрТЗ = Выборка.Найти(Стр.Партия,"Партия");
		Если стрТЗ <> Неопределено Тогда           //НайтиСледующий(Стр.Партия,"Партия")
			Стр.ДатаСрокГодности = стрТЗ.ДатаСрокГодности;
			Стр.ДатаСрокГодности2 = стрТЗ.ДатаСрокГодности2;
			Стр.ДатаИзготовления = стрТЗ.ДатаИзготовления;
			Стр.ДатаИзготовления2 = стрТЗ.ДатаИзготовления2;			
		Иначе
			Стр.ДатаСрокГодности = "";
			Стр.ДатаСрокГодности2 = "";
			Стр.ДатаИзготовления = "";
			Стр.ДатаИзготовления2 = "";			
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// ******* Команды Перемещение/Перезаполнение/Регионализация

&НаКлиенте
Функция МожноПерезаполнять()
	Рез = Истина;
	Если СокрЛП(Объект.Статус = "COMPLETED") Тогда
		ПредупреждениеПользователю("ВСД уже оформлен. Отмена");
		Возврат ложь;
	КонецЕсли;
	
	Если НЕ(ЗначениеЗаполнено(Объект.ДокументОснование)) Тогда
		ПредупреждениеПользователю("Не указан Документ-Основание. Отмена");
		Возврат ложь;
	КонецЕсли;	
	Возврат Рез;	
КонецФункции

&НаСервере
Процедура кнЗаполнитьНаСервере()
	Обработка = ВСД.ИнициализацияОбработки(Объект.Организация); 
	Если типЗнч(Обработка) = Тип("Строка") тогда
		Сообщить("Не удалось инициализировать обработку Интеграция");
		Возврат;
	КонецЕсли;
	Объект.Товары.Очистить();
	Объект.УровниУпаковки.Очистить();
	Объект.Маркировка.Очистить();
	Попытка
		Обработка.ЗаполнитьТЧВСД(Объект.ДокументОснование, Объект);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура кнЗаполнить(Команда)
	Если НЕ МожноПерезаполнять() Тогда
		Возврат;
	КонецЕсли;
	ТВопроса = "Табличные части документа будут перезаполнены ?";
	Ответ = Вопрос(ТВопроса,РежимДиалогаВопрос.ДаНет,0);
	Если НЕ (Ответ = КодВозвратаДиалога.Да) Тогда
		Возврат;
	КонецЕсли;
	
	кнЗаполнитьНаСервере();
КонецПроцедуры

//************** Форма события

//После заполнения сюда сразу попадаем
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Ключ.Пустая() Тогда //ЭтоНовый   https://helpf.pro/faq83/view/1829.html
		
	КонецЕсли;
	Если Объект.Номер = "" Тогда  // тоже новый
		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Параметры.Ключ.Пустая() Тогда
		Если (Не ЗначениеЗаполнено(Объект.Организация)) и ЗначениеЗаполнено(Объект.ДокументОснование) тогда
			// заполняется ОбработкаЗаполнения - 	
			ДокВСД = ВСД.НайтиВСД(Объект.ДокументОснование,Объект.ЭтоПеремещениеОтПоставщика);
			Если ЗначениеЗаполнено( ДокВСД ) Тогда 
				_ИмяФормы = ?(ТипЗнч(ДокВСД) = Тип("ДокументСсылка.ВСД2_транзакция"),"Документ.ВСД2_транзакция.ФормаОбъекта","Документ.ВСД_транзакция.ФормаОбъекта");
				ОткрытьФорму(_ИмяФормы,Новый Структура("Ключ", ДокВСД));
				Отказ = истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
		Объект.Статус = "";
		Объект.applicationID = "";		
		Объект.Комментарий="";
		Объект.Запросы.Очистить();
		Если Объект.УсловияПеревозки.Количество()>0 Тогда
			Ответ = Вопрос("Очистить условия перевозки, полученные из копируемого документа?",РежимДиалогаВопрос.ДаНет,0);
			Если Ответ = КодВозвратаДиалога.Да Тогда
    			Объект.УсловияПеревозки.Очистить();
			КонецЕсли;			
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Объект.Организация) тогда
       		Объект.Организация   =  ВСД_Общий.ПолучитьОрганизациюПоУмолчанию();
			ОрганизацияПриИзменении("");
		Иначе
			СписокПараметров = ВСД.ЗагрузитьПараметры( Объект.Организация );
			АвтоЗаписьВСДСоответствия = СписокПараметров["АвтоЗаписьВСДСоответствия"];
		КонецЕсли;
	Иначе
		СписокПараметров = ВСД.ЗагрузитьПараметры( Объект.Организация );
		АвтоЗаписьВСДСоответствия = СписокПараметров["АвтоЗаписьВСДСоответствия"];
	КонецЕсли;
	ОбновитьДанныеКолонокТовары();
	Если СокрЛП(Объект.Статус) = "COMPLETED" Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;	
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ОбновитьДанныеКолонокТовары();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбновитьДанныеКолонокТовары();
КонецПроцедуры

// События Формы
# Область События_Шапка_документа

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	СписокПараметров = ВСД.ЗагрузитьПараметры( Объект.Организация );
	Объект.Отправитель_ХозСубъект = СписокПараметров["Отправитель_ХозСубъект"];
	Объект.Отправитель_Площадка = СписокПараметров["Отправитель_Площадка"];
	Объект.Перевозчик_ХозСубъект = СписокПараметров["Перевозчик_ХозСубъект"];
	Объект.РезультатыИсследований = СписокПараметров["ВСД_РезультатыИсследований"];
	Объект.Местность = СписокПараметров["ВСД_Местность"];
	Объект.ОсобыеОтметки = СписокПараметров["ВСД_ОсобыеОтметки"];
	//Объект.ТермическоеСостояние = СписокПараметров["ТермУсловияПеревозки");
	Объект.ТермическиеУсловияПеревозки = СписокПараметров["ТермическиеУсловияПеревозки"];
    Объект.cargoInspected = true;
	АвтоЗаписьВСДСоответствия = СписокПараметров["АвтоЗаписьВСДСоответствия"];	
КонецПроцедуры

//&НаКлиенте
//Процедура ВыбратьПлощадкиПоХС(Элемент, ГУИДХСдляОтбора)
//	//ГУИДХСдляОтбора = ?(ЗначениеЗаполнено(ГУИДХСдляОтбора),ГУИДХСдляОтбора,"****");
//	//ЗначениеОтбора = Новый Структура("GuidХозСубъекта", ГУИДХСдляОтбора);
//	
//	ЗначениеОтбора = Новый Структура("ХозСубъект", Объект.Отправитель_ХозСубъект);
//	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина,ЗначениеОтбора);	
//	ОткрытьФорму("Справочник.ВСД_Площадка.ФормаВыбора", ПараметрыПодбора, Элемент);	
//КонецПроцедуры

&НаКлиенте
Процедура Отправитель_ПлощадкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//// Отбор по ХС включим
	//ГУИДХСдляОтбора = ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(Объект.Отправитель_ХозСубъект,"GUID");
	//ВыбратьПлощадкиПоХС(Элемент,ГУИДХСдляОтбора);
	
	ЗначениеОтбора = Новый Структура("ХозСубъект", Объект.Отправитель_ХозСубъект);
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина,ЗначениеОтбора);	
	ОткрытьФорму("Справочник.ВСД_Площадка.ФормаВыбора", ПараметрыПодбора, Элемент);	
	
КонецПроцедуры

&НаКлиенте
Процедура Получатель_ПлощадкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//// Отбор по ХС включим
	//ГУИДХСдляОтбора = ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(Объект.Получатель_ХозСубъект,"GUID");
	//ВыбратьПлощадкиПоХС(Элемент,ГУИДХСдляОтбора);
	
	ЗначениеОтбора = Новый Структура("ХозСубъект", Объект.Получатель_ХозСубъект);
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина,ЗначениеОтбора);	
	ОткрытьФорму("Справочник.ВСД_Площадка.ФормаВыбора", ПараметрыПодбора, Элемент);	
	
КонецПроцедуры

&НаКлиенте
Процедура Получатель_ХозСубъектПриИзменении(Элемент)
	Объект.Получатель_Площадка = "";
КонецПроцедуры

&НаКлиенте
Процедура Отправитель_ХозСубъектПриИзменении(Элемент)
	Объект.Отправитель_Площадка = "";
КонецПроцедуры

#КонецОбласти

	//ЖД  - ту косяк - все строки Товаров ниже удаленной сдвигаются - вот незадача !!!!
	// а у нас связь по № строки тч. Товары  - нужно что то уникальное
	// сдвиг строк в ТЧ Товары стандартный - аналогичный косяк !!!


#Область События_ТЧ_Товары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	// поищем ВСД Элемент и Партию
	СтрокаТабличнойЧасти = Элемент.Родитель.ТекущиеДанные;
	СтрокаТабличнойЧасти.Продукция_Элемент = ВСД.Получить_ВСД_Продукция_Элемент( СтрокаТабличнойЧасти.Номенклатура );
	СтрокаТабличнойЧасти.Партия = ВСД.ВыбратьПартию(СтрокаТабличнойЧасти.Продукция_Элемент, Объект.Отправитель_Площадка, Объект.Отправитель_ХозСубъект);
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Партия) Тогда
		ТоварыПартияПриИзменении(Элемент);
	иначе
		СтрокаТабличнойЧасти.ЕдиницаИзмерения = ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(СтрокаТабличнойЧасти.Продукция_Элемент,"ЕдиницаИзмерения");
	Конецесли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПродукция_ЭлементПриИзменении(Элемент)
	// Сопоставить Номенклатуру с ПродукцияЭлемент
	СтрокаТабличнойЧасти = Элемент.Родитель.ТекущиеДанные;
	СтрокаТабличнойЧасти.Партия = ВСД.ВыбратьПартию(СтрокаТабличнойЧасти.Продукция_Элемент, Объект.Отправитель_Площадка, Объект.Отправитель_ХозСубъект);
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Партия) Тогда
		ТоварыПартияПриИзменении(Элемент);
	Иначе
		СтрокаТабличнойЧасти.ЕдиницаИзмерения = ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(СтрокаТабличнойЧасти.Продукция_Элемент,"ЕдиницаИзмерения");
	Конецесли;
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) и ЗначениеЗаполнено(СтрокаТабличнойЧасти.Продукция_Элемент) и АвтоЗаписьВСДСоответствия Тогда
		ВСД.Установить_Соответствие_ВСД_Продукция_Элемент(СтрокаТабличнойЧасти.Номенклатура,СтрокаТабличнойЧасти.Продукция_Элемент);	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПартияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//СписокПартийДляВыбора = ВСД.СписокАктуальныхПартийПоФильтру_Запрос(Элемент.Родитель.ТекущиеДанные.Продукция_Элемент,Объект.Отправитель_Площадка, Объект.Отправитель_ХозСубъект);	
	//ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина,Новый Структура("Ссылка", СписокПартийДляВыбора));	
	
	СтруктураОтбора = СтруктураОтбораПартий( Элемент.Родитель.ТекущиеДанные.Продукция_Элемент , Объект.Отправитель_Площадка, Объект.Отправитель_ХозСубъект);
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина, СтруктураОтбора);	
	
	ОткрытьФорму("Справочник.ВСД_Партия.ФормаВыбора", ПараметрыПодбора, Элемент);	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПартияПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элемент.Родитель.ТекущиеДанные;
	ДанныеСтрокиТЧ = новый структура("Партия, Продукция_Элемент, ЕдиницаИзмерения, ДатаИзготовления, ДатаИзготовления2, ДатаСрокГодности, ДатаСрокГодности2, Цель");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТЧ, СтрокаТабличнойЧасти);
	ЗаполнитьРеквизитыСтрокиПродукцияСервер(ДанныеСтрокиТЧ);
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ДанныеСтрокиТЧ);
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) и ЗначениеЗаполнено(СтрокаТабличнойЧасти.Продукция_Элемент) и АвтоЗаписьВСДСоответствия Тогда
		ВСД.Установить_Соответствие_ВСД_Продукция_Элемент(СтрокаТабличнойЧасти.Номенклатура,СтрокаТабличнойЧасти.Продукция_Элемент);	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	// Фильтруем Уровни Упаковки
	к=0;	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		ЭтаФорма.Элементы.УровниУпаковки.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции", 0);//.СтрокаПродукции.Установить(0);
	Иначе
		ЭтаФорма.Элементы.УровниУпаковки.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции", Элемент.ТекущиеДанные.НомерСтроки);
		//.СтрокаПродукции.Установить(Элемент.ТекущиеДанные.НомерСтроки);
		ЭтаФорма.Элементы.Маркировка.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции",Элемент.ТекущиеДанные.НомерСтроки);
	КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	к = 0;
	// Удалить связанные уровни упаковки и маркировки
	//ЖД  - ту косяк - все строки ниже удаленной сдвигаются - вот незадача !!!!
	// а у нас связь по № строки тч. Товары  - нужно что то уникальное
	// сдвиг строк в ТЧ Товары стандартный - аналогичный косяк !!!
	
	СтруктураДляПоиска = Новый Структура("СтрокаПродукции", Элемент.ТекущиеДанные.НомерСтроки); 
	//ТабличнаяЧастьДок = ОбъектДок.Товары; 
	//Получаем список строк соответсвтвующих отбору, и перебором удаляем.
	МассивПустыхСтрок = Объект.Маркировка.НайтиСтроки(СтруктураДляПоиска); 
	Для каждого Строка Из МассивПустыхСтрок Цикл 
		Объект.Маркировка.Удалить(Строка); 
	КонецЦикла; 
	МассивПустыхСтрок = Объект.УровниУпаковки.НайтиСтроки(СтруктураДляПоиска); 
	Для каждого Строка Из МассивПустыхСтрок Цикл 
		Объект.УровниУпаковки.Удалить(Строка); 
	КонецЦикла; 
КонецПроцедуры
#КонецОбласти

//***** Работа с уровнями упаковки : на событиях и фильтрация.
#Область ТЧ_УровниУпаковки_Маркировка

&НаКлиенте
Процедура УровниУпаковкиПриАктивизацииСтроки(Элемент)
	Если (ЭтаФорма.Элементы.Товары.ТекущаяСтрока = Неопределено) или
		(ЭтаФорма.Элементы.УровниУпаковки.ТекущаяСтрока = Неопределено) Тогда
		ЭтаФорма.Элементы.Маркировка.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции", 0);
	ИначеЕсли (Элемент.ТекущиеДанные <> Неопределено) тогда  //Непонятный момент Чему равна ТекущаяСтрока
		ЭтаФорма.Элементы.Маркировка.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции",Элемент.ТекущиеДанные.СтрокаПродукции);
		ЭтаФорма.Элементы.Маркировка.ОтборСтрок = Новый ФиксированнаяСтруктура("НомерУровня",Элемент.ТекущиеДанные.НомерУровня);
	КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура УровниУпаковкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если ЭтаФорма.Элементы.Товары.ТекущаяСтрока = Неопределено Тогда
		Отказ = true;
	КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура УровниУпаковкиПередУдалением(Элемент, Отказ)
	// Удалить маркировки по уровню
	СтруктураДляПоиска = Новый Структура("НомерУровня", Элемент.ТекущиеДанные.НомерУровня); 
	//Получаем список строк соответсвтвующих отбору, и перебором удаляем.
	МассивПустыхСтрок = Объект.Маркировка.НайтиСтроки(СтруктураДляПоиска); 
	Для каждого Строка Из МассивПустыхСтрок Цикл 
		Объект.Маркировка.Удалить(Строка); 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УровниУпаковкиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Элемент.ТекущиеДанные.СтрокаПродукции = ЭтаФорма.Элементы.Товары.ТекущиеДанные.НомерСтроки;
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

// *********** Подбор в ТЧ
&НаСервере
Процедура ЗаполнитьРеквизитыСтрокиПродукцияСервер(СтрокаТЧ)
	Если ЗначениеЗаполнено(СтрокаТЧ.Партия) тогда
		СтрокаТЧ.Продукция_Элемент = СтрокаТЧ.Партия.Продукция_Элемент;
		СтрокаТЧ.ЕдиницаИзмерения =СтрокаТЧ.Партия.ЕдиницаИзмерения;
		Если НЕ(типЗНч(СтрокаТЧ) = Тип("Структура")) Тогда
			СтрокаТЧ.Количество = СтрокаТЧ.Партия.Количество;
		КонецЕсли;
		СтрокаТЧ.ДатаИзготовления =СтрокаТЧ.Партия.ДатаИзготовления1;
		СтрокаТЧ.ДатаИзготовления2 =СтрокаТЧ.Партия.ДатаИзготовления2;
		СтрокаТЧ.ДатаСрокГодности =СтрокаТЧ.Партия.ДатаСрокГодности1;
		СтрокаТЧ.ДатаСрокГодности2 =СтрокаТЧ.Партия.ДатаСрокГодности2;		
	КонецЕсли;
	ПараметрыОрганизации = ВСД.ЗагрузитьПараметры( Объект.Организация );
	СтрокаТЧ.Цель = ПараметрыОрганизации["ВСДЦель"];
	
КонецПроцедуры

&НаКлиенте
Процедура кнПодбор(Команда)
	//СписокПартийДляВыбора = ВСД.СписокАктуальныхПартийПоФильтру_Запрос(,Объект.Отправитель_Площадка, Объект.Отправитель_ХозСубъект);	
	//ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,МножественныйВыбор,Отбор", Истина, Истина, Истина,Новый Структура("Ссылка", СписокПартийДляВыбора));	
	
	СтруктураОтбора = СтруктураОтбораПартий( Неопределено , Объект.Отправитель_Площадка, Объект.Отправитель_ХозСубъект);
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора, МножественныйВыбор, Отбор", Истина, Истина, Истина, СтруктураОтбора);	
	
	ОткрытьФорму("Справочник.ВСД_Партия.ФормаВыбора", ПараметрыПодбора, Этаформа.Элементы.Товары);	
КонецПроцедуры

&НаСервере
Процедура ПродукцияОбработкаВыбораНаСервере(ВыбранноеЗначение)
    Для Каждого вЗнч Из ВыбранноеЗначение Цикл
        Если объект.Товары.НайтиСтроки(Новый Структура("Партия", вЗнч)).Количество() = 0 Тогда
           нСтр = объект.Товары.Добавить();
           нСтр.Партия = вЗнч.Ссылка;
           ЗаполнитьРеквизитыСтрокиПродукцияСервер(нСтр);
        КонецЕсли;
     КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПродукцияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
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

&НаСервере
Функция кнОтправитьНаСервере( )
	Записать();
	
	//ВСД.ОтправитьВСДвГИС(ДокСсылка);
	//ПоказатьОповещениеПользователя("Выполнено");
	ИдентификаторЗадания = Неопределено;
	
	// нет в УТ 11 10.3.4
	//ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	//ПараметрыВыполнения.ОжидатьЗавершение = 0;
	//ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Ветис запрос продукции'");
	//ПараметрыПроцедуры = Новый Структура;
	////ПараметрыПроцедуры.Вставить("Тип", А);		
	//Результат = ДлительныеОперации.ВыполнитьВФоне("ВСД_Запросы.ИнициализацияХС_ЗагрузитьПродукцию_Все", ПараметрыПроцедуры, ПараметрыВыполнения);
	
	// Устарела. Следует использовать ВыполнитьВФоне.
	ПараметрыФункции = Новый Структура;
	ПараметрыФункции.Вставить("ДокСсылка", Объект.Ссылка );
	
	НаименованиеЗадания = НСтр("ru = 'Ветис отправка запроса'");
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне( УникальныйИдентификатор, 
		"ВСД_Запросы.ОтправитьВСДвГИС",
		ПараметрыФункции,
		НаименованиеЗадания);
	
	//результат обработки
	АдресХранилища       = Результат.АдресХранилища;
	
	//для получения сообщений
	ИдентификаторЗадания = Результат.ИдентификаторЗадания;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура кнОтправить(Команда)
	Результат = кнОтправитьНаСервере( );
	
	Если Результат.ЗаданиеВыполнено Тогда
		// Задание отработало, результат получен
		ПоказатьОповещениеПользователя("Выполнено");
	ИначеЕсли ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;		

КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуДлительнойОперации()
	
	ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации( ФормаДлительнойОперации );
	
	//Если ТипЗнч(ФормаДлительнойОперации) = Тип("УправляемаяФорма") Тогда
	//	Если ФормаДлительнойОперации.Открыта() Тогда
	//		ФормаДлительнойОперации.Закрыть();
	//	КонецЕсли;
	//КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ЗаданиеВыполнено() 
	Возврат ДлительныеОперации.ЗаданиеВыполнено( ИдентификаторЗадания );
КонецФункции

&НаСервере
Функция ПолучитьСообщения()
    
    //Сообщения=ПолучитьСообщенияПользователю(Истина);
	Сообщения = ДлительныеОперации.СообщенияПользователю(истина,ИдентификаторЗадания);
	    
    Возврат Сообщения;
    
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	МассивСообщений = ПолучитьСообщения();
	//МассивСообщений = ПолучитьСообщенияПользователю(Истина);
	Для Каждого Сообщение Из МассивСообщений Цикл
		Сообщение.Сообщить(); // в окне ДлительноеОжидание
		Сообщение.ИдентификаторНазначения = УникальныйИдентификатор;
		Сообщение.Сообщить(); // в окне документа
	КонецЦикла;
	
	Попытка
		Если ЗаданиеВыполнено() Тогда 
			//ЗагрузитьПодготовленныеДанные();
			//ЗагрузитьПараметры( );
			ЭтаФорма.ТолькоПросмотр(истина);
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

&НаКлиенте
Процедура ДобавитьММ(Команда)
	//ОткрытьФорму("Документ.ВСД2_транзакция.Форма.ФормаТочкаМультиМодульнойПеревозки", Новый Структура("Ключ", Объект));
	ПараметрыПодбора = Новый Структура("Ключ", Объект);
	ОткрытьФорму("Документ.ВСД2_транзакция.Форма.ФормаТочкаМультиМодульнойПеревозки", ПараметрыПодбора, ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.ВСД2_транзакция.Форма.ФормаТочкаМультиМодульнойПеревозки" Тогда
		
		ДобавитьТочкуМультиМодальнойПеревозки( ВыбранноеЗначение );
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ДобавитьТочкуМультиМодальнойПеревозки( ВыбранноеЗначение )
	
	НоваяСтрока = Объект.ТочкиМаршрута.Добавить();
	ЗаполнитьЗначенияСвойств( НоваяСтрока, ВыбранноеЗначение );
	
КонецПроцедуры

