﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
	//	ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа.
	//	                             |
	//	                             |Изменение свойств регламентного задания
	//	                             |выполняется только администраторами.'");
	//КонецЕсли;
	
	Действие = Параметры.Действие;
	
	Если СтрНайти(", Добавить, Скопировать, Изменить,", ", " + Действие + ",") = 0 Тогда
		
		ВызватьИсключение НСтр("ru = 'Неверные параметры открытия формы ""Регламентное задание"".'");
	КонецЕсли;
	
	Если Действие = "Добавить" Тогда
		
		//ПараметрыОтбора        = Новый Структура;
		ПараметризуемыеЗадания = Новый Массив;
		//ЗависимостиЗаданий     = РегламентныеЗаданияСлужебный.РегламентныеЗаданияЗависимыеОтФункциональныхОпций();
		
		//ПараметрыОтбора.Вставить("Параметризуется", Истина);
		//РезультатПоиска = ЗависимостиЗаданий.НайтиСтроки(ПараметрыОтбора);
		//
		//Для Каждого СтрокаТаблицы Из РезультатПоиска Цикл
		//	ПараметризуемыеЗадания.Добавить(СтрокаТаблицы.РегламентноеЗадание);
		//КонецЦикла;
		
		Расписание = Новый РасписаниеРегламентногоЗадания;
		
		Для Каждого РегламентноеЗаданиеМетаданные Из Метаданные.РегламентныеЗадания Цикл
			Если ПараметризуемыеЗадания.Найти(РегламентноеЗаданиеМетаданные) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ОписанияМетаданныхРегламентныхЗаданий.Добавить(
				РегламентноеЗаданиеМетаданные.Имя
					+ Символы.ПС
					+ РегламентноеЗаданиеМетаданные.Синоним
					+ Символы.ПС
					+ РегламентноеЗаданиеМетаданные.ИмяМетода,
				?(ПустаяСтрока(РегламентноеЗаданиеМетаданные.Синоним),
				  РегламентноеЗаданиеМетаданные.Имя,
				  РегламентноеЗаданиеМетаданные.Синоним) );
		КонецЦикла;
	Иначе
		Задание = кб99_РегламентныеЗадания.ПолучитьРегламентноеЗадание(Параметры.Идентификатор);
		ЗаполнитьЗначенияСвойств(
			ЭтотОбъект,
			Задание,
			"Ключ,
			|Предопределенное,
			|Использование,
			|Наименование,
			|ИмяПользователя,
			|ИнтервалПовтораПриАварийномЗавершении,
			|КоличествоПовторовПриАварийномЗавершении");
		
		Идентификатор = Строка(Задание.УникальныйИдентификатор);
		Если Задание.Метаданные = Неопределено Тогда
			ИмяМетаданных        = НСтр("ru = '<нет метаданных>'");
			СинонимМетаданных    = НСтр("ru = '<нет метаданных>'");
			ИмяМетодаМетаданных  = НСтр("ru = '<нет метаданных>'");
		Иначе
			ИмяМетаданных        = Задание.Метаданные.Имя;
			СинонимМетаданных    = Задание.Метаданные.Синоним;
			ИмяМетодаМетаданных  = Задание.Метаданные.ИмяМетода;
		КонецЕсли;
		Расписание = Задание.Расписание;
		
		Если Действие = "Скопировать" Тогда
			ЭтотОбъект.Предопределенное = Ложь;
		Иначе
			СообщенияПользователюИОписаниеИнформацииОбОшибке =
				кб99_РегламентныеЗадания.СообщенияИОписанияОшибокРегламентногоЗадания(Задание);
		КонецЕсли;
		
		Элементы.Наименование.Видимость = Не ЭтотОбъект.Предопределенное;
		
		МассивПараметров = Задание.Параметры;
		Если ТипЗнч(МассивПараметров) = Тип("Массив") И МассивПараметров.Количество() > 0 Тогда
			МассивНастроек = МассивПараметров[0];
			Организация = МассивНастроек.Организация;
			Площадки = МассивНастроек.Площадки;
		КонецЕсли;
	КонецЕсли;
	
	Если Действие <> "Изменить" Тогда
		Идентификатор = НСтр("ru = '<будет создан при записи>'");
		Использование = Ложь;
		
		Наименование = ?(
			Действие = "Добавить",
			"",
			кб99_РегламентныеЗадания.ПредставлениеРегламентногоЗадания(Задание));
	КонецЕсли;
	
	// Заполнение списка выбора имени пользователя.
	МассивПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей(); // Массив из ПользовательИнформационнойБазы
	Для каждого Пользователь Из МассивПользователей Цикл
		Элементы.ИмяПользователя.СписокВыбора.Добавить(Пользователь.Имя);
	КонецЦикла;
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Действие = "Добавить" Тогда
		//ПодключитьОбработчикОжидания("ВыборШаблонаНовогоРегламентногоЗадания", 0.1, Истина);
		ИмяМетаданных = "кб99_ГашениеВходящихВСД";
		СинонимМетаданных = "кб99 Гашение входящих ВСД";
		ИмяМетодаМетаданных = "кб99_РегламентныеЗадания.кб99_ГашениеВСД";
		Наименование = "кб99 Гашение входящих ВСД";
	КонецЕсли;
	
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьЗавершение", ЭтотОбъект);
	кб99_ВСД_Клиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	МожноЗаписать = Истина;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Поле = "Организация";
		МожноЗаписать = Ложь;
	КонецЕсли;
	
	Если Площадки.Количество()=0 Тогда
		Поле = "Площадки";
		МожноЗаписать = Ложь;
	КонецЕсли;
	
	Если МожноЗаписать Тогда
		ЗаписатьРегламентноеЗадание();
	Иначе
		ОчиститьСообщения();
		ТекстСообщения = СтрШаблон("Не заполнены обязательные параметры регламентного задания: %1", Поле);
		кб99_ВСД.СообщитьПользователю(ТекстСообщения,, Поле);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	МожноЗаписать = Истина;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Поле = "Организация";
		МожноЗаписать = Ложь;
	КонецЕсли;
	
	Если Площадки.Количество()=0 Тогда
		Поле = "Площадки";
		МожноЗаписать = Ложь;
	КонецЕсли;
	
	Если МожноЗаписать Тогда
		ЗаписатьИЗакрытьЗавершение();
	Иначе
		ОчиститьСообщения();
		ТекстСообщения = СтрШаблон("Не заполнены обязательные параметры регламентного задания: %1", Поле);
		кб99_ВСД.СообщитьПользователю(ТекстСообщения,, Поле);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеВыполнить()

	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	Диалог.Показать(Новый ОписаниеОповещения("ОткрытьРасписаниеЗавершение", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьИЗакрытьЗавершение(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЗаписатьРегламентноеЗадание();
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборШаблонаНовогоРегламентногоЗадания()
	
	// Выбор шаблона регламентного задания (метаданные).
	ОписанияМетаданныхРегламентныхЗаданий.ПоказатьВыборЭлемента(
		Новый ОписаниеОповещения("ВыборШаблонаНовогоРегламентногоЗаданияЗавершение", ЭтотОбъект),
		НСтр("ru = 'Выберите шаблон регламентного задания'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборШаблонаНовогоРегламентногоЗаданияЗавершение(ЭлементСписка, Контекст) Экспорт
	
	Если ЭлементСписка = Неопределено Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
	
	ИмяМетаданных       = СтрПолучитьСтроку(ЭлементСписка.Значение, 1);
	СинонимМетаданных   = СтрПолучитьСтроку(ЭлементСписка.Значение, 2);
	ИмяМетодаМетаданных = СтрПолучитьСтроку(ЭлементСписка.Значение, 3);
	Наименование        = ЭлементСписка.Представление;
	
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеЗавершение(НовоеРасписание, Контекст) Экспорт

	Если НовоеРасписание <> Неопределено Тогда
		Расписание = НовоеРасписание;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьРегламентноеЗадание()
	
	Результат = Новый Структура(
	"Наименование,
	|Организация,
	|Идентификатор,
	|Использование,
	|Расписание");

	Если НЕ ЗначениеЗаполнено(ИмяМетаданных) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийИдентификатор = ?(Действие = "Изменить", Идентификатор, Неопределено);
	
	ЗаписатьРегламентноеЗаданиеНаСервере();
	ОбновитьЗаголовокФормы();
	
	ЗаполнитьЗначенияСвойств(Результат, ЭтотОбъект,, "Расписание");
	мПредставлениеПустогоРасписания = Строка(Новый РасписаниеРегламентногоЗадания);
	ПредставлениеРасписания = Строка(Расписание);
	Если ПредставлениеРасписания = мПредставлениеПустогоРасписания Тогда
		ПредставлениеРасписания = НСтр("ru = 'Расписание не задано'");
	КонецЕсли;
	Результат.Расписание = ПредставлениеРасписания;
	
	Оповестить("Запись_РегламентныеЗаданияГашение", Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьРегламентноеЗаданиеНаСервере()
	
	МассивПараметров   = Новый Массив;
	СтруктураНастройки = Новый Структура();
	СтруктураНастройки.Вставить("Организация", Организация);
	СтруктураНастройки.Вставить("Площадки",	   Площадки);
	МассивПараметров.Добавить(СтруктураНастройки);

	ПараметрыЗадания = Новый Структура(
	"Ключ,
	|Наименование,
	|Использование,
	|ИмяПользователя,
	|ИнтервалПовтораПриАварийномЗавершении,
	|КоличествоПовторовПриАварийномЗавершении,
	|Параметры,
	|Расписание");
	ЗаполнитьЗначенияСвойств(ПараметрыЗадания, ЭтотОбъект);
	ПараметрыЗадания.Параметры = МассивПараметров;
	
	Если Действие = "Изменить" Тогда
		кб99_РегламентныеЗадания.ИзменитьРегламентноеЗадание(Идентификатор, ПараметрыЗадания);
	Иначе
		ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания[ИмяМетаданных]);
		
		Задание = кб99_РегламентныеЗадания.ДобавитьРегламентноеЗадание(ПараметрыЗадания);
		
		Идентификатор = Строка(Задание.УникальныйИдентификатор);
		Действие = "Изменить";
	КонецЕсли;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовокФормы()
	
	Если НЕ ПустаяСтрока(Наименование) Тогда
		Представление = Наименование;
		
	ИначеЕсли НЕ ПустаяСтрока(СинонимМетаданных) Тогда
		Представление = СинонимМетаданных;
	Иначе
		Представление = ИмяМетаданных;
	КонецЕсли;
	
	Если Действие = "Изменить" Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (Регламентное задание)'"), Представление);
	Иначе
		Заголовок = НСтр("ru = 'Регламентное задание (создание)'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Наименование = Наименование + "_" + Организация;
	НаименованиеПриИзменении(Элемент);
	
КонецПроцедуры

#КонецОбласти
