﻿Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Наименование");
	Поля.Добавить("Код");

КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Данные.Код) Тогда
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 %2", Число(Данные.Код), Данные.Наименование);
	Иначе
		Представление = Данные.Наименование;	
	КонецЕсли;

КонецПроцедуры
