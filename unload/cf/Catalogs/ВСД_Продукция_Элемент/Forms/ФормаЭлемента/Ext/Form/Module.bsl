﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
 	ЭлементОтбора = ЭтаФорма.дсСоответствия.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПродукцияЭлемент");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ; // Опционально
	ЭлементОтбора.ПравоеЗначение = Объект.Ссылка;
	
	ЭлементОтбораСпец = ЭтаФорма.дсСпецификация.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораСпец.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Продукция");
	ЭлементОтбораСпец.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
	ЭлементОтбораСпец.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ; // Опционально
	ЭлементОтбораСпец.ПравоеЗначение = Объект.Ссылка;
КонецПроцедуры

&НаКлиенте
Процедура дсСоответствияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
    Отказ = Истина;
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора", Истина, Истина);	
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", ПараметрыПодбора, Элементы.дсСоответствия);
КонецПроцедуры

&НаСервере
Процедура Установить_Соответствие_ВСД_Продукция_Элемент( ВыбНоменклатура, ВыбПродукцияЭлемент) 
	кб99_ВСД.Установить_Соответствие_ВСД_Продукция_Элемент( ВыбНоменклатура, ВыбПродукцияЭлемент );
КонецПроцедуры

&НаКлиенте
Процедура дсСоответствияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Установить_Соответствие_ВСД_Продукция_Элемент(ВыбранноеЗначение, Объект.Ссылка);
	Элементы.дсСоответствия.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура дсСпецификацияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
//    Отказ = Истина;
//	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора", Истина, Истина);	
//	ОткрытьФорму("Справочник.ВСД_Продукция_Элемент.ФормаВыбора", ПараметрыПодбора, Элементы.дсСпецификация);
КонецПроцедуры

&НаКлиенте
Процедура дсСпецификацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
КонецПроцедуры
