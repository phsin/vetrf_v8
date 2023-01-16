﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		ПараметрыДокумента = ДанныеЗаполнения.ПараметрыДокумента;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыДокумента);
		ЭтотОбъект.Получатель_ХозСубъект = Получатель_Площадка.ХозСубъект;
		
		ДокВСД = ДанныеЗаполнения.ДокВсд;
		
		Если ДанныеЗаполнения.Свойство("ТочкиМаршрута") Тогда
			Для Каждого ТочкаМаршрута Из ДанныеЗаполнения.ТочкиМаршрута Цикл
				новаяТочка = ЭтотОбъект.ВСДВходящие.Добавить();
				новаяТочка.ДокВСД = ДокВСД;
				новаяТочка.Имя = ТочкаМаршрута.Название;
				ЗаполнитьЗначенияСвойств( новаяТочка, точкаМаршрута);
			КонецЦикла;
		Иначе
			тзМаршрутДоставки = ДокВСД.ТочкиМаршрута.Выгрузить();
			Для Каждого точкаМаршрута из тзМаршрутДоставки Цикл
				Если точкаМаршрута.Перегрузка И НЕ ЗначениеЗаполнено(точкаМаршрута.НомерАвто) Тогда
					новаяТочка = ЭтотОбъект.ВСДВходящие.Добавить();
					новаяТочка.ДокВСД = ДокВСД;
					ЗаполнитьЗначенияСвойств( новаяТочка, точкаМаршрута );
					ЗаполнитьЗначенияСвойств( новаяТочка, ДанныеЗаполнения.НомерАвто );
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		ВСДВходящие.Сортировать("НомерТочки");
	КонецЕсли;
	
КонецПроцедуры
