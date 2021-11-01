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
		
	Для Каждого Стр Из Объект.Товары Цикл
		Если ЗначениеЗаполнено( стр.Партия ) Тогда 
			Стр.ДатаСрокГодности = кб99_ВСД_Запросы.СтрокаВДатаВремя( стр.Партия.ДатаСрокГодности1 );
			Стр.ДатаСрокГодности2 = кб99_ВСД_Запросы.СтрокаВДатаВремя( стр.Партия.ДатаСрокГодности2 );
			Стр.ДатаИзготовления = кб99_ВСД_Запросы.СтрокаВДатаВремя( стр.Партия.ДатаИзготовления1 );
			Стр.ДатаИзготовления2 = кб99_ВСД_Запросы.СтрокаВДатаВремя( стр.Партия.ДатаИзготовления2 );			
		Иначе
			Стр.ДатаСрокГодности = "";
			Стр.ДатаСрокГодности2 = "";
			Стр.ДатаИзготовления = "";
			Стр.ДатаИзготовления2 = "";			
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьНадписи( ЭтаФорма );
	
КонецПроцедуры

// ******* Команды Перемещение/Перезаполнение/Регионализация

&НаКлиенте
Функция МожноПерезаполнять()
	
	Рез = Истина;
	
	Если НЕ(ЗначениеЗаполнено(Объект.ДокументОснование)) Тогда
		ПредупреждениеПользователю("Не указан Документ-Основание. Отмена");
		Возврат Ложь;
	КонецЕсли;	
	
	Возврат Рез;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.Ключ.Пустая() Тогда
		Если (Не ЗначениеЗаполнено(Объект.Организация)) и ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
			// заполняется ОбработкаЗаполнения - 	
			ДокВСД = кб99_ВСД.НайтиВСД(Объект.ДокументОснование,Объект.ЭтоПеремещениеОтПоставщика);
			Если ЗначениеЗаполнено( ДокВСД ) Тогда 
				_ИмяФормы = ?(ТипЗнч(ДокВСД) = Тип("ДокументСсылка.ВСД2_транзакция"),"Документ.ВСД2_транзакция.ФормаОбъекта","Документ.ВСД_транзакция.ФормаОбъекта");
				ОткрытьФорму(_ИмяФормы,Новый Структура("Ключ", ДокВСД));
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		Объект.СтатусВСД=Неопределено;
		
		Если Объект.УсловияПеревозки.Количество()>0 Тогда
			Ответ = Вопрос("Очистить условия перевозки, полученные из копируемого документа?",РежимДиалогаВопрос.ДаНет,0);
			Если Ответ = КодВозвратаДиалога.Да Тогда
    			Объект.УсловияПеревозки.Очистить();
			КонецЕсли;			
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
       		Объект.Организация   =  кб99_ВСД_Общий.ПолучитьОрганизациюПоУмолчанию();
			ОрганизацияПриИзменении("");
		Иначе
			СписокПараметров = кб99_ВСД.ЗагрузитьПараметры( Объект.Организация );
			АвтоЗаписьВСДСоответствия = СписокПараметров["АвтоЗаписьВСДСоответствия"];
		КонецЕсли;
	Иначе
		СписокПараметров = кб99_ВСД.ЗагрузитьПараметры( Объект.Организация );
		АвтоЗаписьВСДСоответствия = СписокПараметров["АвтоЗаписьВСДСоответствия"];
	КонецЕсли;
	
	ОбновитьДанныеКолонокТовары();
	
	Если ЗначениеЗаполнено( Объект.СтатусВСД ) Тогда 
		ЭтаФорма.ТолькоПросмотр = Истина;	
		ЭтаФорма.Элементы.ТоварыПодборПоДокументуОснованию.Доступность=Ложь;
		ЭтаФорма.Элементы.ТоварыкнПодбор.Доступность=Ложь;
		ЭтаФорма.Элементы.ТоварыЗаполнитьПросроченнымиТоварами.Доступность=Ложь;
	КонецЕсли;	
	
 	ЭлементОтбора = ЭтаФорма.дсЗапросы.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ; 
	ЭлементОтбора.ПравоеЗначение = Объект.Ссылка;
		
 	ЭлементОтбора = ЭтаФорма.дсВСД.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДокументОснование");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ; 
	ЭлементОтбора.ПравоеЗначение = Объект.Ссылка;
	
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
	СписокПараметров = кб99_ВСД.ЗагрузитьПараметры( Объект.Организация );
	Объект.Отправитель_ХозСубъект = СписокПараметров["Отправитель_ХозСубъект"];
	Объект.Отправитель_Площадка = СписокПараметров["Отправитель_Площадка"];
	Объект.Перевозчик_ХозСубъект = СписокПараметров["Перевозчик_ХозСубъект"];
	Объект.РезультатыИсследований = СписокПараметров["ВСД_РезультатыИсследований"];
	Объект.Местность = СписокПараметров["ВСД_Местность"];
	Объект.ОсобыеОтметки = СписокПараметров["ВСД_ОсобыеОтметки"];
	Объект.ТермическиеУсловияПеревозки = СписокПараметров["ТермическиеУсловияПеревозки"];
    Объект.cargoInspected = true;
	АвтоЗаписьВСДСоответствия = СписокПараметров["АвтоЗаписьВСДСоответствия"];	
КонецПроцедуры

&НаКлиенте
Процедура Отправитель_ПлощадкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗначениеОтбора = Новый Структура("ХозСубъект", Объект.Отправитель_ХозСубъект);
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина,ЗначениеОтбора);	
	ОткрытьФорму("Справочник.ВСД_Площадка.ФормаВыбора", ПараметрыПодбора, Элемент);	
	
КонецПроцедуры

&НаКлиенте
Процедура Получатель_ПлощадкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
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

#Область События_ТЧ_Товары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	// поищем ВСД Элемент и Партию
	СтрокаТабличнойЧасти = Элемент.Родитель.ТекущиеДанные;
	СтрокаТабличнойЧасти.Продукция_Элемент = кб99_ВСД.Получить_ВСД_Продукция_Элемент( СтрокаТабличнойЧасти.Номенклатура );
	СтрокаТабличнойЧасти.Партия = кб99_ВСД.ВыбратьПартию(СтрокаТабличнойЧасти.Продукция_Элемент, Объект.Отправитель_Площадка, Объект.Отправитель_ХозСубъект);
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Партия) Тогда
		ТоварыПартияПриИзменении(Элемент);
	Иначе
		СтрокаТабличнойЧасти.ЕдиницаИзмерения = кб99_ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(СтрокаТабличнойЧасти.Продукция_Элемент,"ЕдиницаИзмерения");
	КонецЕсли;
	ТоварыПриАктивизацииСтроки(Элемент.Родитель);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПродукция_ЭлементПриИзменении(Элемент)
	// Сопоставить Номенклатуру с ПродукцияЭлемент
	СтрокаТабличнойЧасти = Элемент.Родитель.ТекущиеДанные;
	СтрокаТабличнойЧасти.Партия = кб99_ВСД.ВыбратьПартию(СтрокаТабличнойЧасти.Продукция_Элемент, Объект.Отправитель_Площадка, Объект.Отправитель_ХозСубъект);
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Партия) Тогда
		ТоварыПартияПриИзменении(Элемент);
	Иначе
		СтрокаТабличнойЧасти.ЕдиницаИзмерения = кб99_ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(СтрокаТабличнойЧасти.Продукция_Элемент,"ЕдиницаИзмерения");
	КонецЕсли;
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) и ЗначениеЗаполнено(СтрокаТабличнойЧасти.Продукция_Элемент) и АвтоЗаписьВСДСоответствия Тогда
		Установить_Соответствие_ВСД_Продукция_Элемент(СтрокаТабличнойЧасти.Номенклатура,СтрокаТабличнойЧасти.Продукция_Элемент);	
	КонецЕсли;
	ТоварыПриАктивизацииСтроки(Элемент.Родитель);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПартияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СтруктураОтбора = СтруктураОтбораПартий( Элемент.Родитель.ТекущиеДанные.Продукция_Элемент , Объект.Отправитель_Площадка, Объект.Отправитель_ХозСубъект);
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина, СтруктураОтбора);	
	
	ОткрытьФорму("Справочник.ВСД_Партия.ФормаВыбора", ПараметрыПодбора, Элемент);	
КонецПроцедуры

&НаСервере
Процедура Установить_Соответствие_ВСД_Продукция_Элемент(Номенклатура, Продукция_Элемент)
	кб99_ВСД.Установить_Соответствие_ВСД_Продукция_Элемент( Номенклатура, Продукция_Элемент );	
КонецПроцедуры	

&НаКлиенте
Процедура ТоварыПартияПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элемент.Родитель.ТекущиеДанные;
	ДанныеСтрокиТЧ = СтруктураРеквизитовСтроки();
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТЧ, СтрокаТабличнойЧасти);
	ЗаполнитьРеквизитыСтрокиПродукцияСервер(ДанныеСтрокиТЧ);
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ДанныеСтрокиТЧ);
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) и ЗначениеЗаполнено(СтрокаТабличнойЧасти.Продукция_Элемент) и АвтоЗаписьВСДСоответствия Тогда
		Установить_Соответствие_ВСД_Продукция_Элемент(СтрокаТабличнойЧасти.Номенклатура,СтрокаТабличнойЧасти.Продукция_Элемент);	
	КонецЕсли;
	ТоварыПриАктивизацииСтроки(Элемент.Родитель);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	// Фильтруем Уровни Упаковки
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		ЭтаФорма.Элементы.УровниУпаковки.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции", "");
	Иначе
		ЭтаФорма.Элементы.УровниУпаковки.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции", Элемент.ТекущиеДанные.КлючСтроки);
		ЭтаФорма.Элементы.Маркировка.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции",Элемент.ТекущиеДанные.КлючСтроки);
	КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	СтруктураДляПоиска = Новый Структура("СтрокаПродукции", Элемент.ТекущиеДанные.КлючСтроки); 
	//Получаем список строк соответсвтвующих отбору, и перебором удаляем.
	МассивПустыхСтрок = Объект.Маркировка.НайтиСтроки(СтруктураДляПоиска); 
	Для Каждого Строка Из МассивПустыхСтрок Цикл 
		Объект.Маркировка.Удалить(Строка); 
	КонецЦикла; 
	МассивПустыхСтрок = Объект.УровниУпаковки.НайтиСтроки(СтруктураДляПоиска); 
	Для Каждого Строка Из МассивПустыхСтрок Цикл 
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
		ЭтаФорма.Элементы.Маркировка.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции", "");
	ИначеЕсли (Элемент.ТекущиеДанные <> Неопределено) Тогда  //Непонятный момент Чему равна ТекущаяСтрока
		ОтборСтрок = Новый Структура;
		ОтборСтрок.Вставить("СтрокаПродукции",Элемент.ТекущиеДанные.СтрокаПродукции);
		ОтборСтрок.Вставить("НомерУровня",Элемент.ТекущиеДанные.НомерУровня);
		Отбор2 = Новый ФиксированнаяСтруктура(ОтборСтрок);
		ЭтаФорма.Элементы.Маркировка.ОтборСтрок = Отбор2; 
	КонецЕсли;

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
	Для Каждого Строка Из МассивПустыхСтрок Цикл 
		Объект.Маркировка.Удалить(Строка); 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УровниУпаковкиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Элемент.ТекущиеДанные.СтрокаПродукции = ЭтаФорма.Элементы.Товары.ТекущиеДанные.КлючСтроки;
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
	УровниУпаковкиПриАктивизацииСтроки(Элемент);
КонецПроцедуры

#КонецОбласти

// *********** Подбор в ТЧ
&НаСервере
Процедура ЗаполнитьРеквизитыСтрокиПродукцияСервер(СтрокаТЧ)
	
	ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Объект.Организация );

	ПереопределенныйМодуль = кб99_ВСД_Общий.ФункцияПереопределена("ЗаполнитьРеквизитыСтрокиПродукцияСервер");
	Если ПереопределенныйМодуль <> Неопределено Тогда		
		ПереопределенныйМодуль.ЗаполнитьРеквизитыСтрокиПродукцияСервер( СтрокаТЧ,  ПараметрыОрганизации, Объект);
		Возврат;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(СтрокаТЧ.Партия) Тогда
		СтрокаТЧ.Продукция_Элемент = СтрокаТЧ.Партия.Продукция_Элемент;
		СтрокаТЧ.ЕдиницаИзмерения = СтрокаТЧ.Партия.ЕдиницаИзмерения;
		Если НЕ(типЗНч(СтрокаТЧ) = Тип("Структура")) Тогда
			СтрокаТЧ.Количество = СтрокаТЧ.Партия.Количество;
		КонецЕсли;
		СтрокаТЧ.ДатаИзготовления = кб99_ВСД_Запросы.СтрокаВДатаВремя( СтрокаТЧ.Партия.ДатаИзготовления1 );
		СтрокаТЧ.ДатаИзготовления2 = кб99_ВСД_Запросы.СтрокаВДатаВремя( СтрокаТЧ.Партия.ДатаИзготовления2 );
		СтрокаТЧ.ДатаСрокГодности = кб99_ВСД_Запросы.СтрокаВДатаВремя( СтрокаТЧ.Партия.ДатаСрокГодности1 );
		СтрокаТЧ.ДатаСрокГодности2 = кб99_ВСД_Запросы.СтрокаВДатаВремя( СтрокаТЧ.Партия.ДатаСрокГодности2 );
		СтрокаТЧ.ВидПроисхожденияНеПищевойПродукции = ?(ТипЗнч(СтрокаТЧ.Продукция_Элемент.ВидПроисхожденияНеПищевойПродукции) = Тип("ПеречислениеСсылка.кб99_ВидПроисхожденияНепищевойПродукции"),СтрокаТЧ.Продукция_Элемент.ВидПроисхожденияНеПищевойПродукции,"");
		СтрокаТЧ.РезультатыИсследований = ?(ЗначениеЗаполнено(СтрокаТЧ.Партия.vetDocument.РезультатыИсследований),СтрокаТЧ.Партия.vetDocument.РезультатыИсследований, ПараметрыОрганизации["ВСД_РезультатыИсследований"]);
		СтрокаТЧ.КлючСтроки = Новый УникальныйИдентификатор();
		СтрокаУпак = Объект.УровниУпаковки.Добавить();
		СтрокаУпак.СтрокаПродукции = СтрокаТЧ.КлючСтроки;
		СтрокаУпак.Количество = 1;
		СтрокаУпак.НомерУровня = ПараметрыОрганизации["ПарамНомерУровняУпаковкиДляВСД"];
		Если ЗначениеЗаполнено(СтрокаТЧ.Продукция_Элемент.ФормаУпаковки) Тогда
			СтрокаУпак.ФормаУпаковки = СтрокаТЧ.Продукция_Элемент.ФормаУпаковки;
		Иначе
			СтрокаУпак.ФормаУпаковки = ПараметрыОрганизации["ПарамФормаУпаковкиДляВСД"];
		КонецЕсли;
		//Маркировки
		СтрокаМарк = Объект.Маркировка.Добавить();
		СтрокаМарк.Строкапродукции = СтрокаУпак.СтрокаПродукции;
		СтрокаМарк.НомерУровня = СтрокаУпак.НомерУровня;
		СтрокаМарк.Класс = Перечисления.кб99_Маркировка.UNDEFINED;
		СтрокаМарк.Маркировка = СтрокаТЧ.Партия.Производитель_Площадка.Наименование;
	КонецЕсли;
		СтрокаТЧ.Цель = ?(ЗначениеЗаполнено(СтрокаТЧ.Продукция_Элемент.ВидПродукции.Цель), СтрокаТЧ.Продукция_Элемент.ВидПродукции.Цель, ПараметрыОрганизации["ВСДЦель"]);

КонецПроцедуры

&НаКлиенте
Процедура кнПодбор(Команда)

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
	СтандартнаяОбработка = Ложь;
	ПродукцияОбработкаВыбораНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаСервере
Функция кнОтправитьНаСервере( )
	
	Записать();
	
	ИдентификаторЗадания = Неопределено;
	
	ПараметрыФункции = Новый Структура;
	ПараметрыФункции.Вставить("ДокСсылка", Объект.Ссылка );
	
	НаименованиеЗадания = НСтр("ru = 'Ветис отправка запроса'");
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне( УникальныйИдентификатор, 
		"кб99_ВСД_Запросы.ОтправитьВСДвГИС",
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
	
КонецПроцедуры

&НаСервере
Функция ЗаданиеВыполнено() 
	Возврат ДлительныеОперации.ЗаданиеВыполнено( ИдентификаторЗадания );
КонецФункции

&НаСервере
Функция ПолучитьСообщения()
    
	Сообщения = ДлительныеОперации.СообщенияПользователю(Истина,ИдентификаторЗадания);
	    
    Возврат Сообщения;
    
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	МассивСообщений = ПолучитьСообщения();
	Для Каждого Сообщение Из МассивСообщений Цикл
		Сообщение.Сообщить(); // в окне ДлительноеОжидание
		Сообщение.ИдентификаторНазначения = УникальныйИдентификатор;
		Сообщение.Сообщить(); // в окне документа
	КонецЦикла;
	
	Попытка
		Если ЗаданиеВыполнено() Тогда 
			Попытка 
				ЭтаФорма.ТолькоПросмотр(Истина);
			Исключение КонецПопытки;
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
	
	ПараметрыПодбора = Новый Структура("Организация", Объект.Организация);
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

&НаСервере
Процедура ЗаполнитьПросроченнымиТоварамиНаСервере( МинДатаСрокГодности, МаксКолвоПартийВдокументе=100 )
	
	Объект.Товары.Очистить();
	Объект.УровниУпаковки.Очистить();
	Объект.Маркировка.Очистить();
	
	ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Объект.Организация );	
	СписокПартий = кб99_ВСД.СписокАктуальныхПартийПоФильтру_Запрос( , Объект.Отправитель_Площадка, Объект.Отправитель_ХозСубъект );
	
	Для Каждого стрПартия Из СписокПартий Цикл
		
		Если объект.Товары.Количество() > (МаксКолвоПартийВдокументе-1) Тогда
			Прервать;	
		КонецЕсли;
		
		ДатаСрокГодности1= кб99_ВСД_Запросы.СтрокаВДатаВремя( стрПартия.ДатаСрокГодности1 );
		
		Если ДатаСрокГодности1 > МинДатаСрокГодности Тогда
			Продолжить;	
		КонецЕсли;
	
		стрТовары = объект.Товары.Добавить();
		стрТовары.Партия = стрПартия;
		стрТовары.Продукция_Элемент = стрТовары.Партия.Продукция_Элемент;
		стрТовары.Количество = стрПартия.Количество;
		стрТовары.ЕдиницаИзмерения 	= стрТовары.Партия.ЕдиницаИзмерения;
		ЗаполнитьРеквизитыСтрокиПродукцияСервер(стрТовары);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаДаты(Дата, Параметры) Экспорт
	
	Если Дата = Неопределено Тогда
		Дата = ТекущаяДата();		
	КонецЕсли;
	
	ЗаполнитьПросроченнымиТоварамиНаСервере( Дата );
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПросроченнымиТоварами(Команда)
		
	ДатаНапоминания = ТекущаяДата();
	Подсказка = "Введите срок годности";
	ЧастьДаты = ЧастиДаты.Дата;
	Оповещение = Новый ОписаниеОповещения("ПослеВводаДаты", ЭтаФорма);
	ПоказатьВводДаты(Оповещение, ДатаНапоминания, Подсказка, ЧастьДаты);	

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьНадписи(Форма)
	
	Объект = Форма.Объект;
	
	Запрос = кб99_ВСД_Общий.НайтиПоследнийЗапрос( Объект.Ссылка );
	Форма.ApplicationID = Запрос.ApplicationID;
	Форма.СтатусЗапроса = Запрос.СтатусЗапроса;
	
	Если ЗначениеЗаполнено( Запрос.Ошибки ) Тогда
		Форма.Элементы.Ошибки.Видимость = Истина;
		Форма.Ошибки = Запрос.Ошибки;
	Иначе
		Форма.Элементы.Ошибки.Видимость = Ложь;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекДанные = Элемент.ТекущиеДанные;
	Если НЕ ЗначениеЗаполнено(ТекДанные.КлючСтроки) Тогда
		ТекДанные.КлючСтроки = Новый УникальныйИдентификатор;
		ЭтаФорма.Элементы.УровниУпаковки.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции", ТекДанные.КлючСтроки);
		ЭтаФорма.Элементы.Маркировка.ОтборСтрок = Новый ФиксированнаяСтруктура("СтрокаПродукции",ТекДанные.КлючСтроки);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция СтруктураРеквизитовСтроки()
	
	ДанныеСтрокиТЧ = Новый Структура();
	ДанныеСтрокиТЧ.Вставить("Партия");
	ДанныеСтрокиТЧ.Вставить("Количество");
	ДанныеСтрокиТЧ.Вставить("Номенклатура");
	ДанныеСтрокиТЧ.Вставить("Продукция_Элемент");
	ДанныеСтрокиТЧ.Вставить("ЕдиницаИзмерения");
	ДанныеСтрокиТЧ.Вставить("ДатаИзготовления");
	ДанныеСтрокиТЧ.Вставить("ДатаИзготовления2");
	ДанныеСтрокиТЧ.Вставить("ДатаСрокГодности");
	ДанныеСтрокиТЧ.Вставить("ДатаСрокГодности2");
	ДанныеСтрокиТЧ.Вставить("Цель");
	ДанныеСтрокиТЧ.Вставить("КлючСтроки");
	ДанныеСтрокиТЧ.Вставить("ВидПроисхожденияНеПищевойПродукции");
	ДанныеСтрокиТЧ.Вставить("РезультатыИсследований");
	
	Возврат ДанныеСтрокиТЧ;
	
КонецФункции

&НаКлиенте
Процедура ПодборПоДокументуОснованию(Команда)
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ОповещениеОбОкончанииПодбора = Новый ОписаниеОповещения("ПеренестиПодобранныеПартии", ЭтаФорма, Неопределено);
		ПараметрыОткрытияПодбора = Новый Структура();
		ПараметрыОткрытияПодбора.Вставить("ДокументОснование", Объект.ДокументОснование);
		ПараметрыОткрытияПодбора.Вставить("Отправитель_ХозСубъект", Объект.Отправитель_ХозСубъект);
		ПараметрыОткрытияПодбора.Вставить("Отправитель_Площадка", Объект.Отправитель_Площадка); 
		ПараметрыОткрытияПодбора.Вставить("Получатель_ХозСубъект", Объект.Получатель_ХозСубъект);
		ПараметрыОткрытияПодбора.Вставить("Получатель_Площадка", Объект.Получатель_Площадка);
		ОткрытьФорму("Документ.ВСД2_транзакция.Форма.ПодборПартий", ПараметрыОткрытияПодбора,ЭтаФорма,,,,ОповещениеОбОкончанииПодбора);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиПодобранныеПартии(РезультатПодбора, ДополнительныеПараметры) Экспорт

	Если РезультатПодбора <> Неопределено Тогда
		Объект.Товары.Очистить();
		Объект.УровниУпаковки.Очистить();
		Объект.Маркировка.Очистить();
		ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры(Объект.Организация);
		
		Для Каждого СтрРезультат Из РезультатПодбора.ПодобранныеТовары Цикл
			ДанныеСтрокиТЧ = СтруктураРеквизитовСтроки();
			ЗаполнитьЗначенияСвойств(ДанныеСтрокиТЧ, СтрРезультат);
			ЗаполнитьРеквизитыСтрокиПродукцияСервер(ДанныеСтрокиТЧ);
			нСтрТовары = Объект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(нСтрТовары, ДанныеСтрокиТЧ);
		КонецЦикла;
		
		Если ПараметрыОрганизации["ПарамЗаполнятьТранзакциюПриОтсутствииПартий"] Тогда
			Для Каждого СтрНеподобранныеТовары Из РезультатПодбора.НеПодобранныеТовары Цикл
				нСтрТовары = Объект.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(нСтрТовары, СтрНеподобранныеТовары);
				нСтрТовары.ЕдиницаИзмерения = кб99_ВСД.ПолучитьЗначениеРевизитаОбъекта_НаСервере(нСтрТовары.Продукция_Элемент,"ЕдиницаИзмерения");
				нСтрТовары.КлючСтроки = Новый УникальныйИдентификатор;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

