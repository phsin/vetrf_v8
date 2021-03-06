﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	// Оформляем ВСД2
	//Можно задать вопрос - 1 или 2 форму создавать
	
	ДокСсылка = ПараметрКоманды;
    ДокВСД = ""; // НайтиВСДПеремещения
	Если ЗначениеЗаполнено(ДокВСД) Тогда
		Если типЗнч(ДокВСД) = Тип("ДокументСсылка.ВСД2_транзакция") Тогда
			ИмяФормыДокумента = "Документ.ВСД2_транзакция.ФормаОбъекта";	
		ИначеЕсли типЗнч(ДокВСД) = Тип("ДокументСсылка.ВСД_транзакция") Тогда
			ИмяФормыДокумента = "Документ.ВСД_транзакция.ФормаОбъекта";
		Иначе
			Сообщить("Неверный документ нашли");
			Возврат;
		КонецЕсли;
		ОткрытьФорму(ИмяФормыДокумента, Новый Структура("Ключ", ДокВСД));
	Иначе
		ДанныеЗаполнения = Новый Структура("ОтПоставщика,Основание",Истина,ДокСсылка);
		ОткрытьФорму("Документ.ВСД2_транзакция.ФормаОбъекта", Новый Структура("Основание",ДанныеЗаполнения));
	КонецЕсли;
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("ОбщаяФорма.", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
