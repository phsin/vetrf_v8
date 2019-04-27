﻿Функция ЗапросПоТранзакции() 
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВСД2_транзакция.Ссылка КАК Ссылка1,
	|	ВСД2.Ссылка КАК ВСД2,
	|	ВСД2.Статус,
	|	ВСД2.Отправитель_Площадка.Наименование,
	|	ВСД2.Отправитель_Площадка.Адрес,
	|	ВСД2.ТтнНомер,
	|	ВСД2_транзакция.Организация.Наименование,
	|	ВСД2.UUID,
	|	ВСД2_транзакция.Организация.ИНН,
	|	ВСД2.Дата,
	|	ВСД2.Получатель_ХозСубъект.Контрагент.НаименованиеПолное КАК ПолучательХозСубъектНаименование,
	|	ВСД2.Получатель_ХозСубъект.Контрагент.ИНН КАК ПолучательХозСубъектИНН,
	|	ВСД2.НаименованиеПродукции,
	|	ВСД2.Количество,
	|	ВСД2.ДатаИзготовления,
	|	ВСД2.ДатаИзготовления1,
	|	ВСД2.ДатаИзготовления2,
	|	ВСД2.ДатаСрокГодности,
	|	ВСД2.ДатаСрокГодности1,
	|	ВСД2.ДатаСрокГодности2
	|ИЗ
	|	Документ.ВСД2 КАК ВСД2
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВСД2_транзакция КАК ВСД2_транзакция
	|		ПО ВСД2.ДокументОснование = ВСД2_транзакция.Ссылка
	|ГДЕ
	|	ВСД2_транзакция.Ссылка = &Ссылка
	|	И ВСД2.ПометкаУдаления = ЛОЖЬ
	|	И ПОДСТРОКА(ВСД2.Статус, 1, 12) = ""CONFIRMED""";
	
	Возврат ТекстЗапроса;
КонецФункции

Процедура Печать( ТабДокумент, МассивСсылок) Экспорт
	
	ДокСсылка = МассивСсылок[0];
	ТекстЗапроса = ЗапросПоТранзакции();		

	ДанныеQRКода = УправлениеПечатью.ДанныеQRКода("Проверка", 1, 190);
	ИспользоватьВнешнююКомпоненту=Ложь;
	Макет = Документы.ВСД2_транзакция.ПолучитьМакет("Макет");
	
	ТабДокумент = Новый ТабличныйДокумент;
	Макет = ПолучитьМакет("Макет");
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	
	ОбластьМакета.Параметры.НомерДок = ДокСсылка.Номер;//ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДокСсылка.Номер, Истина, Ложь);
	ОбластьМакета.Параметры.ДатаДок = Формат(ДокСсылка.Дата,"ДЛФ=Д");
	
	ТабДокумент.Вывести(ОбластьМакета);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", ДокСсылка); 
	ОбластьМакета = Макет.ПолучитьОбласть("ОбластьШтрихкод");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() цикл
		ПечНомерТТН = Выборка.ттнНомер;		
		тВСД = "Ветеринарное свидетельство (оформлен) Код: "+ Выборка.UUID;
		тОтправитель = "Фирма-отправитель: "+ Выборка.ОрганизацияНаименование +", ИНН:"+ Выборка.ОрганизацияИНН+", ТТН: № "+Выборка.ттнНомер+" от "+Выборка.Дата;
		тПолучатель = "Фирма-получатель: "+ Выборка.ПолучательХозСубъектНаименование +", ИНН: "+ Выборка.ПолучательХозСубъектИНН;
		тПлощадка = "Предприятие-получатель: " + Выборка.Отправитель_ПлощадкаНаименование+", Адрес: " +Выборка.Отправитель_ПлощадкаАдрес;;
		тПродукция = "Продукция: "+Выборка.НаименованиеПродукции +", "+Выборка.Количество+" кг";
		
		Если ЗначениеЗаполнено(Выборка.ДатаИзготовления1) Тогда
			тВыработано = "Выработана: "+Формат(Выборка.ДатаИзготовления1,"ДФ=dd.MM.yyyy; ДЛФ=D; ДП=-")+"-"+Формат(Выборка.ДатаИзготовления2,"ДФ=dd.MM.yyyy; ДЛФ=D; ДП=-");					
		Иначе
			тВыработано = "Выработана: " + Сокрлп(Выборка.ДатаИзготовления);
		КонецЕсли;
		Если ЗначениеЗаполнено(Выборка.ДатаСрокГодности1) Тогда
			тВыработано = тВыработано + 
			" срок годности: "+ Формат(Выборка.ДатаСрокГодности1,"ДФ=dd.MM.yyyy; ДЛФ=D; ДП=-")+"-"+Формат(Выборка.ДатаСрокГодности2,"ДФ=dd.MM.yyyy; ДЛФ=D; ДП=-");
		Иначе
			тВыработано = тВыработано + " срок годности: "+ СокрЛП(Выборка.ДатаСрокГодности);
		КонецЕсли;
		
		тКод = "Код: "+Выборка.UUID;  
		тСгенерировано = "Сгенерировано '1С' http://kb99.pro "+ТекущаяДата()+" "+ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя;
	   			 			
		ШтрихКод = "http://mercury.vetrf.ru/pub/operatorui?_language=ru&_action=showVetDocumentFormByUuid&uuid= "+Выборка.UUID;
		
		ДанныеQRКода = УправлениеПечатью.ДанныеQRКода( ШтрихКод, 1, 190);
		Если ДанныеQRКода = Неопределено Тогда
			КартинкаQRКода = Новый Картинка();
		Иначе
			КартинкаQRКода = Новый Картинка(ДанныеQRКода);
		КонецЕсли;
		ОбластьМакета.Рисунки.Штрихкод.Картинка = КартинкаQRКода;

		ОбластьМакета.Параметры.тВСД = тВСД;
		ОбластьМакета.Параметры.тОтправитель = тОтправитель;
		ОбластьМакета.Параметры.тПолучатель = тПолучатель;
		ОбластьМакета.Параметры.тПлощадка = тПлощадка;
		ОбластьМакета.Параметры.тПродукция = тПродукция;
		ОбластьМакета.Параметры.тВыработано = тВыработано;
		ОбластьМакета.Параметры.тКод = тКод;
		ОбластьМакета.Параметры.тСгенерировано = тСгенерировано;
		
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	
	ТабДокумент.АвтоМасштаб = Истина;
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабДокумент.ИмяПараметровПечати = "Удостоверение качества";
	
КонецПроцедуры
