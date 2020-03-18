﻿&НаКлиенте
Процедура ОбработкаОтвета(Ответ, Парам) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПоказатьОповещениеПользователя("Выполняем Аннулирование ВСД",,"Ожидайте...",БиблиотекаКартинок.Информация32);
		Если Найти(Парам.ПараметрыВыполненияКоманды.Источник.ИмяФормы,"Списка") = 0 Тогда
			Парам.ПараметрыВыполненияКоманды.Источник.этаФорма.Закрыть();
		КонецЕсли;		
		
    	кб99_ВСД.АннулироватьВСД(Парам.ПараметрКоманды);
		
		ПоказатьОповещениеПользователя("Выполнено");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Парам = Новый Структура("ПараметрКоманды,ПараметрыВыполненияКоманды",ПараметрКоманды,ПараметрыВыполненияКоманды);
    Оповещение = Новый ОписаниеОповещения("ОбработкаОтвета",ЭтотОбъект,Парам);	
    ПоказатьВопрос(Оповещение, "Аннулировать ВСД ?", РежимДиалогаВопрос.ДаНет,  0, КодВозвратаДиалога.Да, ""   );
	
КонецПроцедуры
