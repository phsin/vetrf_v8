﻿// ЖД - Перенести функционал Соответствий в общий модуль
// т.к. дублируется в Управляемой Форме


Процедура ПриОткрытии()
	ФлНеЗагружать = True;
	Возврат;
	
	
	Если Организация.Пустая() Тогда
		Организация   = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
	КонецЕсли;	
	
	Инициализация();	
	Попытка
		Версия = КомпонентанаСервере.Версия;	
	Исключение
		Версия = "Не зарегистрирована";
	КонецПопытки;
	ФлНеЗагружать = True;
КонецПроцедуры

Процедура КнопкаВыбораПериодаНажатие(Элемент)	
	НП =  Новый НастройкаПериода;	
	Если НП.Редактировать() Тогда
		ВыбначалоПериода = НП.ПолучитьДатуНачала();
		ВыбОкончаниеПериода = НП.ПолучитьДатуОкончания();
	КонецЕсли;
	
КонецПроцедуры


Процедура кнПолучитьНажатие(Элемент)
	Проходов = 20;
	Пока (ПолучитьСписокВСД( Отправитель_Площадка, "INCOMING","CONFIRMED", 0,ВыбначалоПериода,ВыбОкончаниеПериода,ВыбрХозСубъект,ВыбрПлощадка)="REJECTED") и (Проходов > 0) Цикл
		Проходов = Проходов - 1;
		Сообщить("Попыток запроса осталось "+Проходов);
	КонецЦикла;
//	ПолучитьСписокВСД( Отправитель_Площадка, "INCOMING","CONFIRMED", 0);
КонецПроцедуры

Процедура КнЗагрузитьизФайлаНажатие(Элемент)
	ЗагрузитьXML_ВСД2(СтрИмяФайла,ВСДВходящие);
	Для каждого стрВход из ВСДВходящие Цикл
		стрВход.ДокВСД = НайтиВСД_ВходящийпоUUID(стрВход.uuid);
		Если значениеЗаполнено(стрВход.ДокВСД) Тогда
			стрВход.КоличествоПринять = стрВход.ДокВСД.КоличествоПринять;
			стрВход.КоличествоВозврат = стрВход.ДокВСД.КоличествоВозврат;
//			стрВход.УдалитьДокВозврат = ВСД.НайтиВСД_ИсходящийНаВозврат(стрВход.ДокВСД);	
		КонецЕсли;
	КонецЦикла;	
	//ОбработатьПолученныеДанные();
КонецПроцедуры

Процедура кнПогаситьНажатие(Элемент)
	ОтправкаЗапросовНаГашение();
КонецПроцедуры

Процедура ОрганизацияПриИзменении(Элемент)
	Инициализация();	
	Попытка
		Версия = КомпонентанаСервере.Версия;	
	Исключение
		Версия = "Не зарегистрирована";
	КонецПопытки;
КонецПроцедуры

Процедура кнПолучитьХСпоGUIDНажатие(Элемент)
	ЗагрузитьХСПоGUID(СокрЛП(ВыбХС.GUID));
КонецПроцедуры

Процедура КнЗагрузитьизФайлаПартииНажатие(Элемент)
	ЗагрузитьXML_Партии2(СтрИмяФайла)
КонецПроцедуры

Процедура Отправитель_ПлощадкаНачалоВыбора(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
   	ФормаВыбора =  Справочники.ВСД_Площадка.ПолучитьФормуВыбора(, Элемент);
	ГУИДХСдляОтбора = ЭтотОбъект.Отправитель_ХозСубъект.GUID;
	ГУИДХСдляОтбора = ?(ЗначениеЗаполнено(ГУИДХСдляОтбора),ГУИДХСдляОтбора,"****");
	Если ТипЗнч(ФормаВыбора) = Тип("УправляемаяФорма") Тогда
		ЗначениеОтбора = Новый Структура("GuidХозСубъекта", ГУИДХСдляОтбора);
		ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина,ЗначениеОтбора);	
		ОткрытьФорму("Справочник.ВСД_Площадка.ФормаВыбора", ПараметрыПодбора, Элемент);	
	Иначе
	    ФормаВыбора.РежимВыбора = Истина;
    	ФормаВыбора.Отбор.GuidХозСубъекта.Установить(ГУИДХСдляОтбора, Истина);
	    ФормаВыбора.Открыть();
	КонецЕсли;	
КонецПроцедуры

Процедура УстановитьПометки()
	Для Каждого стр Из ВСДВходящие Цикл
		Если стр.Статус = "COMPLETED" Тогда
			Продолжить;	
		КонецЕсли;
		Если НЕ(стр.Отметка) Тогда 
			стр.Отметка = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура СнятьПометки()
	Для Каждого стр Из ВСДВходящие Цикл
		Если (стр.Отметка) Тогда 
			стр.Отметка = Ложь;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ТЗВСДПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	//Раскраска
//	Если ПустаяСтрока(ДанныеСтроки.ХозСубъект.GUID)Тогда
//		ОформлениеСтроки.ЦветФона = Новый Цвет(255,120,90);   //красный
//	ИначеЕсли ДанныеСтроки.Площадка = Справочники.ВСД_Площадка.ПустаяСсылка() Тогда
//		ОформлениеСтроки.ЦветФона = Новый Цвет(255,255,127);   //желтый
	Если ДанныеСтроки.Статус = "COMPLETED" Тогда
		ОформлениеСтроки.ЦветФона = Новый Цвет(0, 150, 26);  
	ИначеЕсли ДанныеСтроки.Статус = "CONFIRMED" Тогда
		//не красим
	ИначеЕсли ЗначениеЗаполнено(ДанныеСтроки.Комментарий) Тогда
		//нехороший статус
		ОформлениеСтроки.ЦветФона = Новый Цвет(255,120,90);   //красный
	КонецЕсли;
	
КонецПроцедуры

Процедура Отправитель_ПлощадкаПриИзменении(Элемент)
	ВСДВходящие.Очистить();
КонецПроцедуры

//******************************** Соответствия

Процедура ОчиститьСоответствие(ВыбНоменклатура,ВСДЭлемент)
	// Вынести в ГМ
	Набор = РегистрыСведений.ВСД_Соответсвия.СоздатьНаборЗаписей();
	Набор.Отбор.Номенклатура.Установить(ВыбНоменклатура);
	Набор.Отбор.Номенклатура.Использование = Истина;
	Набор.Прочитать();
	Набор.Очистить();
	Набор.Записать(true);
КонецПроцедуры

Функция ПолучитьНоменклатуруПоПродукцияЭлемент(ПродукцияЭлемент, Только1элемент = 0)
	// Возврашает массив со ссылками на Номенклатуру или первый элемент Номенклатура
	// Вынести в ГМ
	Запрос = Новый Запрос;
	Запрос.Текст = "Выбрать ВСД_Соответсвия.Номенклатура из РегистрСведений.ВСД_Соответсвия как ВСД_Соответсвия где ВСД_Соответсвия.ПродукцияЭлемент = &Ресурс1";
	Запрос.УстановитьПараметр("Ресурс1", ПродукцияЭлемент);	
	Если Не Только1Элемент Тогда
		ТзВрем = Запрос.Выполнить().Выгрузить();
		ТзВрем.ВыгрузитьКолонку("Номенклатура");
		Возврат ТзВрем.ВыгрузитьКолонку("Номенклатура");		
	Иначе
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Возврат Выборка.Номенклатура;
		Иначе
			Возврат "";
		КонецЕсли;
	КонецЕсли;
КонецФункции

Функция НайтиНоменклатуруПоРеквизиту(ВыбРеквизит,ЗначениеРеквизита)
	Рез = "";
	Запрос = Новый Запрос;
	ТекстЗапроса = "
	|Выбрать Номенклатура.Ссылка из Справочник.Номенклатура как Номенклатура 
	|где Номенклатура.@ИмяРекв = &ЗначРеквизита";
	текстЗапроса = СтрЗаменить(ТекстЗапроса,"@ИмяРекв",ВыбРеквизит);
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ЗначРеквизита", ЗначениеРеквизита);
	Попытка
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Рез = Выборка.Ссылка;	
		КонецЕсли;
	Исключение
		Сообщить("Что-то пошло не так",СтатусСообщения.Внимание);
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	Возврат Рез;
	
КонецФункции

Процедура ЗаполнитьТЗСоответствий(сзПродукцияЭлементы)
	//Вынести в модуль объекта
	// Заполнение Продукция_элементом  + сразу поиск установленных соответствий
	// сзПродукцияЭлементы - Список Значений
	Соответствия.Очистить();
	тз = Соответствия.Выгрузить(); //Взяли структуру
	для каждого стрТз из сзПродукцияЭлементы Цикл
		стрСоотв = тз.Добавить();
		стрСоотв.Продукция_Элемент = стрТз.Значение;//Продукция_Элемент;
		стрСоотв.Производитель = стрСоотв.Продукция_Элемент.Площадка;
		стрСоотв.Артикул = стрСоотв.Продукция_Элемент.Артикул;
		стрСоотв.GTIN = стрСоотв.Продукция_Элемент.GTIN;
		стрСоотв.Номенклатура = ПолучитьНоменклатуруПоПродукцияЭлемент(стрСоотв.Продукция_Элемент, 1);
		Если ЗначениеЗаполнено(стрСоотв.Номенклатура) Тогда
			стрСоотв.Записано = true;	
		КонецЕсли;
	КонецЦикла;
	//Свернем, т.к. могут повторяться
	тз.Свернуть("Продукция_Элемент,Номенклатура,Артикул,GTIN,Производитель,Записано","");
	Соответствия.Загрузить(тз);
КонецПроцедуры

Процедура ЗаполнитьСПоискомПоРеквизиту(ВыбРеквизит,ИмяРекв = "Артикул")
	тз = Соответствия.Выгрузить();
	для каждого строкаТз из тз Цикл
		Если (строкаТз.Записано) или (ЗначениеЗаполнено(строкаТз.Номенклатура)) Тогда
			Продолжить;
		КонецЕсли;
		Если ИмяРекв = "Артикул" Тогда
		    ВыбЗначение = СокрЛП(строкаТз.Артикул);
		Иначе
		    ВыбЗначение = СокрЛП(строкаТз.GTIN);
		КонецЕсли;
		Если НЕ(ЗначениеЗаполнено(ВыбЗначение)) тогда
			Продолжить;	
		КонецЕсли;		
		
		строкаТз.Номенклатура = НайтиНоменклатуруПоРеквизиту(ВыбРеквизит,ВыбЗначение);
	КонецЦикла;
	Соответствия.Загрузить(Тз);
КонецПроцедуры

//** кнопки
Процедура кнЗаполнитьТзСоответствийНажатие(Элемент)
	// Заполнение Продукция_элементом из ВходящихВСД, + сразу поиск установленных соответствий
	сзЭлементы = Новый СписокЗначений;
	сзЭлементы.ЗагрузитьЗначения(ВсдВходящие.ВыгрузитьКолонку("Продукция_Элемент"));
	ЗаполнитьТЗСоответствий(сзЭлементы);	
КонецПроцедуры

Процедура кнЗаполнитьИзСправочникаНажатие(Элемент)
	// Заполним из Справочника ВСД_Продукция_Элемент
	Запрос = Новый Запрос;
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ВСД_Продукция_Элемент.Ссылка
	               |ИЗ
	               |	Справочник.ВСД_Продукция_Элемент КАК ВСД_Продукция_Элемент
	               |ГДЕ
	               |	ВСД_Продукция_Элемент.ПометкаУдаления = ЛОЖЬ
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ВСД_Продукция_Элемент.Наименование";
	Запрос.Текст = ТекстЗапроса;
	ТзВрем = Запрос.Выполнить().Выгрузить();
	сзЭлементы = Новый СписокЗначений;
	сзЭлементы.ЗагрузитьЗначения(ТзВрем.ВыгрузитьКолонку("Ссылка"));
	ЗаполнитьТЗСоответствий(сзЭлементы);
	
КонецПроцедуры

Процедура кнНайтиПоАртикулуНажатие(Элемент)
	ЗаполнитьСПоискомПоРеквизиту(ИмяРеквизитаАртикул,"Артикул")
КонецПроцедуры

Процедура кнНайтиПоШКНажатие(Элемент)
	ЗаполнитьСПоискомПоРеквизиту(ИмяРеквизитаШК,"ШК")
КонецПроцедуры

Процедура кнУбратьЗаполненныеНажатие(Элемент)
	тз = Соответствия.Выгрузить();
	Найдено = тз.Найти(True,"Записано"); 
	Пока НЕ(Найдено = Неопределено) Цикл
		тз.Удалить(Найдено);
		Найдено = тз.Найти(True,"Записано");
	КонецЦикла;
	Соответствия.Загрузить(Тз);
КонецПроцедуры

Процедура кнЗаписатьСоответствияНажатие(Элемент)
	тз = Соответствия.Выгрузить();
	для каждого строкаТз из тз Цикл
		Если (строкаТз.Записано) или НЕ(ЗначениеЗаполнено(строкаТз.Номенклатура)) Тогда
			Продолжить;
		КонецЕсли;
		ВСД.Установить_Соответствие_ВСД_Продукция_Элемент(СтрокаТЗ.Номенклатура,СтрокаТЗ.Продукция_Элемент);
		строкаТЗ.Записано = True;
	КонецЦикла;
	Соответствия.Загрузить(Тз);
КонецПроцедуры

// *** Работа с Формой Соответствия
Процедура тзСоответствияПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	//Раскраска
	Если НЕ ЗначениеЗаполнено(ДанныеСтроки.Номенклатура) Тогда
		ОформлениеСтроки.ЦветФона = Новый Цвет(255,120,90);   //красный
	ИначеЕсли НЕ ДанныеСтроки.Записано Тогда
		ОформлениеСтроки.ЦветФона = Новый Цвет(255,255,127);   //желтый
	Иначе
		ОформлениеСтроки.ЦветФона = Новый Цвет(0, 150, 26);   //		
	КонецЕсли;
КонецПроцедуры

Процедура тзСоответствияНоменклатураНачалоВыбора(Элемент, СтандартнаяОбработка)
	// вызывается также при Очистке Номенклатуры на форме
	// Проверяется, установлено ли соответствие с УЖЕ выбранным элементом
	Если ЭлементыФормы.тзСоответствия.ТекущиеДанные.Записано Тогда
		ТекстВопроса = "Установлена связь с 
		|"+ЭлементыФормы.тзСоответствия.ТекущиеДанные.Продукция_Элемент+"
		|Отвязываем ?";
		Ответ = Вопрос(ТекстВопроса,РежимДиалогаВопрос.ДаНет,0);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ОчиститьСоответствие(ЭлементыФормы.тзСоответствия.ТекущиеДанные.Номенклатура,ЭлементыФормы.тзСоответствия.ТекущиеДанные.Продукция_Элемент);		
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура тзСоответствияНоменклатураПриИзменении(Элемент)
	// Проверить установлено ли уже соответствие выбранной Номенклатуры с Продукция_Элемент
	ВремПЭлемент = ВСД.Получить_ВСД_Продукция_Элемент(ЭлементыФормы.тзСоответствия.ТекущиеДанные.Номенклатура);
	Если НЕ ЗначениеЗаполнено(ВремПЭлемент) Тогда
		ЭлементыФормы.тзСоответствия.ТекущиеДанные.Записано = False;
	ИначеЕсли НЕ(ВремПЭлемент = ЭлементыФормы.тзСоответствия.ТекущиеДанные.Продукция_Элемент) Тогда
		ТекстВопроса = "Уже установлена связь с 
		|"+ВремПЭлемент+"
		|Отвязываем ?";
		Ответ = Вопрос(ТекстВопроса,РежимДиалогаВопрос.ДаНет,0);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
    		ЭлементыФормы.тзСоответствия.ТекущиеДанные.Номенклатура = "";
		Иначе
			ОчиститьСоответствие(ЭлементыФормы.тзСоответствия.ТекущиеДанные.Номенклатура,ВремПЭлемент);		
		КонецЕсли;
		ЭлементыФормы.тзСоответствия.ТекущиеДанные.Записано = False;
	Иначе
		ЭлементыФормы.тзСоответствия.ТекущиеДанные.Записано = True;
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗакрытии()
	ВСДВходящие.Очистить();
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура кнОформитьВозвратНажатие(Элемент)
	СоздатьВСД_ВходящиеПоТЗВходящих();
	//СоздатьВСД_ИсходящиеНаВозврат();
КонецПроцедуры

Процедура ПолеВвода3ПриИзменении(Элемент)
	ВыбрПлощадка = "";
КонецПроцедуры

Процедура ПолеВвода4НачалоВыбора(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
   	ФормаВыбора =  Справочники.ВСД_Площадка.ПолучитьФормуВыбора(, Элемент);
	ГУИДХСдляОтбора = ВыбрХозСубъект.GUID;
	ГУИДХСдляОтбора = ?(ЗначениеЗаполнено(ГУИДХСдляОтбора),ГУИДХСдляОтбора,"****");
	Если ТипЗнч(ФормаВыбора) = Тип("УправляемаяФорма") Тогда
		ЗначениеОтбора = Новый Структура("GuidХозСубъекта", ГУИДХСдляОтбора);
		ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора,Отбор", Истина, Истина,ЗначениеОтбора);	
		ОткрытьФорму("Справочник.ВСД_Площадка.ФормаВыбора", ПараметрыПодбора, Элемент);	
	Иначе
	    ФормаВыбора.РежимВыбора = Истина;
    	ФормаВыбора.Отбор.GuidХозСубъекта.Установить(ГУИДХСдляОтбора, Истина);
	    ФормаВыбора.Открыть();
	КонецЕсли;	
КонецПроцедуры














