﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Параметры.Ключ.Пустая() Тогда
		Объект.Статус = "";
		Объект.applicationID = "";
		Если Не ЗначениеЗаполнено(Объект.Организация) тогда
       		Объект.Организация   =  ВСД.ПолучитьОрганизациюПоУмолчанию();
		Иначе
//			СписокПараметров = ВСД.ЗагрузитьПараметры( Объект.Организация );
		КонецЕсли;
	Иначе
//		СписокПараметров = ВСД.ЗагрузитьПараметры( Объект.Организация );
	КонецЕсли;

	ЭтаФорма.Элементы.СвязанныеДокументыТипДокумента.СписокВыбора.Добавить(1,"ТТН");
	ЭтаФорма.Элементы.СвязанныеДокументыТипДокумента.СписокВыбора.Добавить(5,"ТрН");
	ЭтаФорма.Элементы.СвязанныеДокументыТипДокумента.СписокВыбора.Добавить(6,"Торг12");
	ЭтаФорма.Элементы.СвязанныеДокументыТипДокумента.СписокВыбора.Добавить(16,"Заказ");
	ЭтаФорма.Элементы.СвязанныеДокументыТипДокумента.СписокВыбора.Добавить(23,"УПД");
	ЭтаФорма.Элементы.СвязанныеДокументыТипДокумента.РежимВыбораИзСписка = Истина;
	Если СокрЛП(Объект.Статус) = "COMPLETED" Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	СписокПараметров = ВСД.ЗагрузитьПараметры( Объект.Организация );
	Объект.Получатель_ХозСубъект = СписокПараметров.Получить("Отправитель_ХозСубъект");
	Объект.Получатель_Площадка = СписокПараметров.Получить("Отправитель_Площадка");
	Объект.РезультатыИсследований = СписокПараметров.Получить("ВСД_РезультатыИсследований");
	Объект.Местность = СписокПараметров.Получить("ВСД_Местность");
	Объект.ОсобыеОтметки = СписокПараметров.Получить("ВСД_ОсобыеОтметки");
	//Объект.ТермическоеСостояние = СписокПараметров.Получить("ТермУсловияПеревозки");
	Объект.ТермическиеУсловияПеревозки = СписокПараметров.Получить("ТермическиеУсловияПеревозки");
    Объект.cargoInspected = true;
КонецПроцедуры


