﻿// ********* Команды и события Формы
#Область НемодальныеОкна
&НаКлиенте
Процедура ПредупреждениеПользователю(ТекстПредупреждения) Экспорт
    Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияПредупреждение", ЭтаФорма);	
    ПоказатьПредупреждение( Оповещение,   ТекстПредупреждения,   0,   "Предупреждение" );
КонецПроцедуры
 
&НаКлиенте
Процедура ПослеЗакрытияПредупреждение(Параметры) Экспорт	
КонецПроцедуры

#КонецОбласти


&НаКлиенте
Процедура кнПрочитать(Команда)
	СзНоменклатура.Очистить();
	Рез = ВСД.ПолучитьНоменклатуруПоПродукцияЭлемент(ВыбВСДЭлемент);
	СзНоменклатура.ЗагрузитьЗначения(Рез);
КонецПроцедуры

&НаКлиенте
Процедура СзНоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если СзНоменклатура.НайтиПоЗначению(ВыбранноеЗначение) = Неопределено Тогда
		СзНоменклатура.Добавить(ВыбранноеЗначение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура кнДобавитьНоменклатуру(Команда)
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, РежимВыбора", Ложь, Истина);	
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", ПараметрыПодбора, Элементы.СзНоменклатура);
КонецПроцедуры

&НаКлиенте
Процедура кнЗаписатьСоответсвия(Команда)
	Если ВыбВСДЭлемент.Пустая() тогда
		ПредупреждениеПользователю("Укажите Номенклатуру Меркупий");
		Возврат;
	КонецЕсли;
	//Для начала очистим соответствия
	МассивНоменклатуры = ВСД.ПолучитьНоменклатуруПоПродукцияЭлемент(ВыбВСДЭлемент);
	СписокНоменклатуры = Новый СписокЗначений;
	СписокНоменклатуры.ЗагрузитьЗначения(МассивНоменклатуры);
	ВСД.УдалитьСоответствиеСписку_ВСД_Продукция_Элемент(СписокНоменклатуры,ВыбВСДЭлемент);
	
	ВСД.УстановитьСоответствиеСписку_ВСД_Продукция_Элемент(СзНоменклатура,ВыбВСДЭлемент);
	ПредупреждениеПользователю("-> Соответсвия для "+ВыбВСДЭлемент+" Установлены");

КонецПроцедуры

&НаКлиенте
Процедура кнУбратьСоответствияОтвет(Ответ,Парам) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВСД.УдалитьСоответствиеСписку_ВСД_Продукция_Элемент(Парам.СзНоменклатура,Парам.ВыбВСДЭлемент);
		кнПрочитать("");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура кнУбратьСоответствия(Команда)
	Если ВыбВСДЭлемент.Пустая() тогда
		ПредупреждениеПользователю("Укажите Номенклатуру Меркупий");
		Возврат;
	КонецЕсли;
	Парам = Новый Структура("СзНоменклатура,ВыбВСДЭлемент",СзНоменклатура,ВыбВСДЭлемент);
   	Оповещение = Новый ОписаниеОповещения("кнУбратьСоответствияОтвет",ЭтаФорма,Парам);	
   	ПоказатьВопрос(Оповещение, "Удалить соответствие выбранной номенклатуры 1С Элементу Меркурий?", РежимДиалогаВопрос.ДаНет,  0, КодВозвратаДиалога.Да, ""   );
КонецПроцедуры



