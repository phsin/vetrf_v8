﻿&НаСервере
Процедура ВыполнитьНаСервере( ВыбПлощадка )
	
	Организация = кб99_ВСД_Общий.ПолучитьОрганизациюПоУмолчанию();	
	ПараметрыОрганизации = кб99_ВСД.ЗагрузитьПараметры( Организация );
	
	кб99_ВСД_Запросы.Продукция_Элемент_ПолучитьСписокПоПлощадке( ПараметрыОрганизации, ВыбПлощадка );
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПоказатьОповещениеПользователя("Выполняем запрос",,"Ожидайте...",БиблиотекаКартинок.Информация32);
	
	ВыполнитьНаСервере( ПараметрКоманды );
	
	ПоказатьОповещениеПользователя("Операция завершена");
КонецПроцедуры
