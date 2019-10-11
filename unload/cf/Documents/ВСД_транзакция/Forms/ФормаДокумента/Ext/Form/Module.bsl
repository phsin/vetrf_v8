﻿//После заполнения сюда сразу попадаем
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
		Если (Не ЗначениеЗаполнено(Объект.Организация)) и ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
			// заполняется ОбработкаЗаполнения - 	
			ДокВСД = ВСД.НайтиВСД(Объект.ДокументОснование);
			_ИмяФормы = ?(ТипЗнч(ДокВСД) = Тип("ДокументСсылка.ВСД2_транзакция"),"Документ.ВСД2_транзакция.ФормаОбъекта","Документ.ВСД_транзакция.ФормаОбъекта");
			ОткрытьФорму(_ИмяФормы,Новый Структура("Ключ", ДокВСД));
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		Объект.Статус = "";
		Объект.applicationID = "";
		Объект.Запросы.Очистить();
		Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
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
	ПараметрыОрганизации = ВСД.ЗагрузитьПараметры( Объект.Организация );
	Объект.Отправитель_ХозСубъект = ПараметрыОрганизации["Отправитель_ХозСубъект"];
	Объект.Отправитель_Площадка = ПараметрыОрганизации["Отправитель_Площадка"];
	Объект.Перевозчик_ХозСубъект = ПараметрыОрганизации["Перевозчик_ХозСубъект"];
//	Объект.РезультатыИсследований = СписокПараметров["ВСД_РезультатыИсследований");
	Объект.Местность = ПараметрыОрганизации["ВСД_Местность"];
	Объект.ОсобыеОтметки = ПараметрыОрганизации["ВСД_ОсобыеОтметки"];
	//Объект.ТермическоеСостояние = ПараметрыОрганизации["ТермУсловияПеревозки"];
    Объект.cargoInspected = true;
	АвтоЗаписьВСДСоответствия = ПараметрыОрганизации["АвтоЗаписьВСДСоответствия"];	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПлощадкиПоХС(Элемент, ГУИДХСдляОтбора)
	ГУИДХСдляОтбора = ?(ЗначениеЗаполнено(ГУИДХСдляОтбора),ГУИДХСдляОтбора,"****");
	ЗначениеОтбора = Новый Структура("GuidХозСубъекта", ГУИДХСдляОтбора);
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина,ЗначениеОтбора);	
	ОткрытьФорму("Справочник.ВСД_Площадка.ФормаВыбора", ПараметрыПодбора, Элемент);	
КонецПроцедуры

&НаКлиенте
Процедура Отправитель_ПлощадкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	// Отбор по ХС включим
	ГУИДХСдляОтбора = ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(Объект.Отправитель_ХозСубъект,"GUID");
	ВыбратьПлощадкиПоХС(Элемент,ГУИДХСдляОтбора);
КонецПроцедуры

&НаКлиенте
Процедура Получатель_ПлощадкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	// Отбор по ХС включим
	ГУИДХСдляОтбора = ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(Объект.Получатель_ХозСубъект,"GUID");
	ВыбратьПлощадкиПоХС(Элемент,ГУИДХСдляОтбора);
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
	Иначе
		СтрокаТабличнойЧасти.ЕдиницаИзмерения = ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(СтрокаТабличнойЧасти.Продукция_Элемент,"ЕдиницаИзмерения");
	КонецЕсли;
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
	КонецЕсли;
//	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) и ЗначениеЗаполнено(СтрокаТабличнойЧасти.Продукция_Элемент) и АвтоЗаписьВСДСоответствия Тогда
//		ВСД.Установить_Соответствие_ВСД_Продукция_Элемент(СтрокаТабличнойЧасти.Номенклатура,СтрокаТабличнойЧасти.Продукция_Элемент);	
//	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПартияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СписокПартийДляВыбора = ВСД.СписокАктуальныхПартийПоФильтру_Запрос(Элемент.Родитель.ТекущиеДанные.Продукция_Элемент,Объект.Отправитель_Площадка, Объект.Отправитель_ХозСубъект);	
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина,Новый Структура("Ссылка", СписокПартийДляВыбора));	
	ОткрытьФорму("Справочник.ВСД_Партия.ФормаВыбора", ПараметрыПодбора, Элемент);	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПартияПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элемент.Родитель.ТекущиеДанные;
	СтрокаТабличнойЧасти.Продукция_Элемент =  ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(СтрокаТабличнойЧасти.Партия,"Продукция_Элемент");
	СтрокаТабличнойЧасти.ЕдиницаИзмерения = ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(СтрокаТабличнойЧасти.Партия,"ЕдиницаИзмерения");
	СтрокаТабличнойЧасти.ДатаИзготовления = ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(СтрокаТабличнойЧасти.Партия,"ДатаИзготовления1");
	СтрокаТабличнойЧасти.ДатаИзготовления2 = ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(СтрокаТабличнойЧасти.Партия,"ДатаИзготовления2");
	СтрокаТабличнойЧасти.ДатаСрокГодности = ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(СтрокаТабличнойЧасти.Партия,"ДатаСрокГодности1");
	СтрокаТабличнойЧасти.ДатаСрокГодности2 = ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(СтрокаТабличнойЧасти.Партия,"ДатаСрокГодности2");
	
 //	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) и ЗначениеЗаполнено(СтрокаТабличнойЧасти.Продукция_Элемент) и АвтоЗаписьВСДСоответствия Тогда
//		ВСД.Установить_Соответствие_ВСД_Продукция_Элемент(СтрокаТабличнойЧасти.Номенклатура,СтрокаТабличнойЧасти.Продукция_Элемент);	
//	КонецЕсли;
КонецПроцедуры

#КонецОбласти

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

