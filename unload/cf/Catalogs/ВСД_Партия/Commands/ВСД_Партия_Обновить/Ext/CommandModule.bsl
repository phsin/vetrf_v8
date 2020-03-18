﻿&НаСервере
Процедура ВыполнитьНаСервере( СписокПартий )
	
	Организация = кб99_ВСД_Общий.ПолучитьОрганизациюПоУмолчанию();	
	ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Организация );	
	
	Для Каждого ВыбПартия Из СписокПартий Цикл
		
		ПараметрыОрганизации["Отправитель_Площадка"] = ВыбПартия.Получатель_Площадка;
		кб99_ВСД_Запросы.Партии_ПолучитьПоGUID( ПараметрыОрганизации, ВыбПартия );
		
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПоказатьОповещениеПользователя("Выполняем запрос",,"Ожидайте...",БиблиотекаКартинок.Информация32);
	
	ВыполнитьНаСервере( ПараметрКоманды );
	
	ПоказатьОповещениеПользователя("Операция завершена");
КонецПроцедуры
