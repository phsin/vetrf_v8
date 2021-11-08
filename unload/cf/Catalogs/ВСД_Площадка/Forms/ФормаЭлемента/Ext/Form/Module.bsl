﻿&НаКлиенте
Процедура ОбновитьСоответствия()
	
	ЭтаФорма.дсСоответствия.Отбор.Элементы.Очистить();
	ЭлементОтбора = ЭтаФорма.дсСоответствия.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ; // Опционально
	ЭлементОтбора.ПравоеЗначение = Объект.ХозСубъект;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьСоответствия();
	ОбновитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура дсСоответствияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора", Истина, Истина);	
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", ПараметрыПодбора, Элементы.дсСоответствия);
	
КонецПроцедуры

&НаКлиенте
Процедура дсСоответствияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	кб99_ВСД.Установить_Соответствие(ВыбранноеЗначение,Объект.Ссылка);
	Элементы.дсСоответствия.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ХозСубъектПриИзмененииНаСервере()
	Объект.GuidХозСубъекта = Объект.ХозСубъект.GUID;
КонецПроцедуры

&НаКлиенте
Процедура ХозСубъектПриИзменении(Элемент)
	ХозСубъектПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Группа1ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ОбновитьСоответствия();
КонецПроцедуры

&НаКлиенте
Процедура ПерсональныеПараметрыСписанияПартийПриИзменении(Элемент)
	ОбновитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьЭлементов()
	Если Объект.ПерсональныеПараметрыСписанияПартий Тогда 
		ЭтаФорма.Элементы.ПарамЗнакСортировкиУбывание.Видимость = Истина;
		ЭтаФорма.Элементы.ПарамКолонкаСортировкиПартииСписания.Видимость = Истина;		
	Иначе		
		ЭтаФорма.Элементы.ПарамЗнакСортировкиУбывание.Видимость = Ложь;
		ЭтаФорма.Элементы.ПарамКолонкаСортировкиПартииСписания.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

#Область ОбработчикиЭлементовАдрес

&НаКлиенте
Процедура СформироватьПредставлениеАдреса()
	
	Разделитель = ", ";
	
	Страна 			= ?(ЗначениеЗаполнено(Объект.Страна), Строка(Объект.Страна), "");
	Регион 			= ?(ЗначениеЗаполнено(Объект.Регион), Разделитель+Строка(Объект.Регион), "");
	Район  			= ?(ЗначениеЗаполнено(Объект.Район), Разделитель+Строка(Объект.Район), "");
	Город  			= ?(ЗначениеЗаполнено(Объект.Город), Разделитель+Строка(Объект.Город), "");
	НаселенныйПункт = ?(ЗначениеЗаполнено(Объект.НаселенныйПункт), Разделитель+Строка(Объект.НаселенныйПункт), "");
	Улица 			= ?(ЗначениеЗаполнено(Объект.Улица), Разделитель+Строка(Объект.Улица), "");
	НомерДома 		= ?(ЗначениеЗаполнено(Объект.НомерДома), Разделитель+Строка(Объект.НомерДома), "");
	
	Объект.Адрес = Страна+Регион+Район+Город+НаселенныйПункт+Улица+НомерДома;
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаПриИзменении(Элемент)
	
	Объект.Регион 		   = Неопределено;
	Объект.Район 		   = Неопределено;
	Объект.Город  		   = Неопределено;
	Объект.НаселенныйПункт = Неопределено;
	Объект.Улица  		   = Неопределено;
    Объект.НомерДома	   = Неопределено;
	
	СформироватьПредставлениеАдреса();

КонецПроцедуры

&НаКлиенте
Процедура РегионПриИзменении(Элемент)
	
	Объект.Район 		   = Неопределено;
	Объект.Город  		   = Неопределено;
	Объект.НаселенныйПункт = Неопределено;
	Объект.Улица  		   = Неопределено;
    Объект.НомерДома	   = Неопределено;
	
	СформироватьПредставлениеАдреса();

КонецПроцедуры

&НаКлиенте
Процедура РайонПриИзменении(Элемент)
	
	Объект.Город  		   = Неопределено;
	Объект.НаселенныйПункт = Неопределено;
	Объект.Улица  		   = Неопределено;
    Объект.НомерДома	   = Неопределено;
	
	СформироватьПредставлениеАдреса();
	
КонецПроцедуры

&НаКлиенте
Процедура ГородПриИзменении(Элемент)
	
	Владелец_ = ?(ЗначениеЗаполнено(Объект.Район),Объект.Район,Объект.Регион);
	
	Если Не кб99_ВСД_Общий.ПроверитьВладельцаСправочника(Объект.Город, Владелец_) Тогда
    	Объект.Город = Неопределено;
	КонецЕсли;

	Объект.НаселенныйПункт = Неопределено;
	Объект.Улица  		   = Неопределено;
    Объект.НомерДома	   = Неопределено;
	
	СформироватьПредставлениеАдреса();

КонецПроцедуры

&НаКлиенте
Процедура ГородНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповещениеОВыбореГорода = Новый ОписаниеОповещения("ВыборГорода", ЭтаФорма, Новый Структура());
	СтруктураОтбора = Новый Структура("Владелец", ?(ЗначениеЗаполнено(Объект.Район),Объект.Район,Объект.Регион));
	ПараметрыОткрытия = Новый Структура("Отбор, ЗакрыватьПриВыборе", СтруктураОтбора, Истина);
	
	ОткрытьФорму("Справочник.ВСД_Город.ФормаВыбора", ПараметрыОткрытия,,,,, ОповещениеОВыбореГорода);
	
КонецПроцедуры 

&НаКлиенте
Процедура ВыборГорода(Результат, ДопПараметры = Неопределено) Экспорт
	
	Объект.Город = Результат; 
	ГородПриИзменении("");
	
КонецПроцедуры

&НаКлиенте
Процедура НаселенныйПунктПриИзменении(Элемент)
	
	Объект.Улица 	 = Неопределено;
    Объект.НомерДома = Неопределено;
	
	СформироватьПредставлениеАдреса();

КонецПроцедуры

&НаКлиенте
Процедура УлицаПриИзменении(Элемент)
	
	Объект.НомерДома = Неопределено;
	
	Владелец_ = ?(ЗначениеЗаполнено(Объект.НаселенныйПункт), Объект.НаселенныйПункт, Объект.Город);
	
	Если Не кб99_ВСД_Общий.ПроверитьВладельцаСправочника(Объект.Улица, Владелец_) Тогда
    	Объект.Улица = Неопределено;
	КонецЕсли;

	СформироватьПредставлениеАдреса();

КонецПроцедуры

&НаКлиенте
Процедура УлицаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповещениеОВыбореУлицы = Новый ОписаниеОповещения("ВыборУлицы", ЭтаФорма, Новый Структура());
	Если Не ЗначениеЗаполнено(Объект.НаселенныйПункт) И Не ЗначениеЗаполнено(Объект.Город) 
														 И ЗначениеЗаполнено(Объект.Регион) Тогда
		НаселенныйПункт = Объект.Регион;
	ИначеЕсли ЗначениеЗаполнено(Объект.НаселенныйПункт) Тогда
		НаселенныйПункт = Объект.НаселенныйПункт;
	ИначеЕсли ЗначениеЗаполнено(Объект.Город) Тогда
		НаселенныйПункт = Объект.Город;
	Иначе
		НаселенныйПункт = Неопределено;
	КонецЕсли;

	СтруктураОтбора = Новый Структура("Владелец", НаселенныйПункт);
	ПараметрыОткрытия = Новый Структура("Отбор, ЗакрыватьПриВыборе", СтруктураОтбора, Истина);
	
	ОткрытьФорму("Справочник.ВСД_Улица.ФормаВыбора", ПараметрыОткрытия,,,,, ОповещениеОВыбореУлицы);

КонецПроцедуры

&НаКлиенте
Процедура ВыборУлицы(Результат, ДопПараметры = Неопределено) Экспорт
	
	Объект.Улица = Результат;
	УлицаПриИзменении("");
	
КонецПроцедуры

&НаКлиенте
Процедура НомерДомаПриИзменении(Элемент)
	
	СформироватьПредставлениеАдреса();
	
КонецПроцедуры

#КонецОбласти