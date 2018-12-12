﻿Перем мНеОткрыватьФормуДокумента Экспорт;  //Запрешает открывать форму при вводе на основании, если уже введен ВСД Транзакция

Процедура ОбработкаЗаполнения(ВходДанные, СтандартнаяОбработка)
	ОтПоставщика = Ложь;
	Если ТипЗнч(ВходДанные)=Тип("Структура") Тогда
//		Если ВходДанные.Структура("ОтПоставщика")  и ВходДанные.СТруктура("Основание") Тогда
		Попытка
        	ОтПоставщика =  ВходДанные.ОтПоставщика;
			ДанныеЗаполнения = ВходДанные.Основание;
		Исключение
//		Иначе
			ДанныеЗаполнения = Неопределено;
		КонецПопытки;
//		КонецЕсли		
	Иначе
		ДанныеЗаполнения = ВходДанные;
	КонецЕсли;
	
	Если (ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваровУслуг")) или
		(ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПеремещениеТоваров")) Тогда
		// Заполнение шапки
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		
		ПараметрыОрганизации = ВСД.ЗагрузитьПараметры( ДанныеЗаполнения.Организация );
		ЭтоПеремещениеОтПоставщика = ОтПоставщика;
		
//		Если Не ОтПоставщика Тогда
		//Найдем уже созданный
		Если НЕ ЗначениеЗаполнено(ПараметрыОрганизации.Получить("ПарамРазрешитьВводНаОснованииБолееОдногоВСД")) Тогда
			Сообщить("Проверьте и пересохраните параметры для Организации "+ДанныеЗаполнения.Организация);
			Возврат;
		КонецЕсли;
			Если НЕ ПараметрыОрганизации.Получить("ПарамРазрешитьВводНаОснованииБолееОдногоВСД") Тогда
				ДокВСД = ВСД.НайтиВСД(ДанныеЗаполнения.Ссылка,ОтПоставщика);
				Если ЗначениеЗаполнено(ДокВСД) Тогда
					мНеОткрыватьФормуДокумента = Истина;
					Возврат;
				КонецЕсли;
			КонецЕсли;
//		КонецЕсли;	
		
		Организация = ДанныеЗаполнения.Организация;
		Обработка = ВСД.ИнициализацияОбработки(Организация,Ложь);   // воспользуемся ф-цией ЗаполнитьТЧВСД() или РассчитатьКоличествоДляВСД()
		Если типЗнч(Обработка) = Тип("Строка") тогда
			Сообщить("Не удалось инициализировать обработку Интеграция - документ не будет автоматически заполнен!!!");
			Возврат;
		КонецЕсли;
		Попытка
			Если ОтПоставщика Тогда
				СписокПараметров = Обработка.ПолучитьДанныеДляСозданияВСДПеремещения(ДанныеЗаполнения.Ссылка);
				Комментарий = "Перемещение от поставщика на основании "+ДанныеЗаполнения;
			Иначе
				СписокПараметров = Обработка.ПолучитьДанныеДляСозданияВСДТранзакции(ДанныеЗаполнения.Ссылка);
			КонецЕсли;
//			ПараметрыОрганизации = ВСД.ЗагрузитьПараметры( СписокПараметров.Организация );
			Обработка.ЗаполнитьШапку_ВСД2_Транзакция(ЭтотОбъект, СписокПараметров, ПараметрыОрганизации);
			Обработка.ЗаполнитьТЧВСД(СписокПараметров.ДокОснование, ЭтотОбъект,,,,СписокПараметров.СтрокиВСД);
		Исключение
			Сообщить("Не удалось заполнить документ");
			Сообщить(ОписаниеОшибки(),СтатусСообщения.Важное);
		КонецПопытки;
		//ЖД Контроль
//		Если Товары.Количество() = 0 Тогда
//			Сообщить("Нет данных (пустая таб часть) для создания ВСД2_Транзакция ",СтатусСообщения.Внимание);
	Иначе
//		Сообщить("Не переданы данные для автомаьтического заполнения");
	КонецЕсли;
КонецПроцедуры

мНеОткрыватьФормуДокумента = ложь;
