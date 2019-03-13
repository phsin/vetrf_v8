&НаСервере
Функция Площадка_Создать_Запрос( ПараметрыОрганизации, ВыбПлощадка ) 
	_guid = Новый УникальныйИдентификатор;

	ЗапросXML = "
	|<SOAP-ENV:Envelope 
	|xmlns:dt='http://api.vetrf.ru/schema/cdm/dictionary/v2'
	|xmlns:bs='http://api.vetrf.ru/schema/cdm/base'
	|xmlns:merc='http://api.vetrf.ru/schema/cdm/mercury/g2b/applications/v2'
	|xmlns:apldef='http://api.vetrf.ru/schema/cdm/application/ws-definitions'
	|xmlns:apl='http://api.vetrf.ru/schema/cdm/application'
	|xmlns:vd='http://api.vetrf.ru/schema/cdm/mercury/vet-document/v2'
	|xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'>
	|  <SOAP-ENV:Header/>
	|  <SOAP-ENV:Body>
	|    <apldef:submitApplicationRequest>
	|      <apldef:apiKey>"+ ( ПараметрыОрганизации["param_api_key"] )+"</apldef:apiKey>
	|      <apl:application>
	|        <apl:serviceId>mercury-g2b.service:2.0</apl:serviceId>
	|        <apl:issuerId>"+ ( ПараметрыОрганизации["param_issuer_id"] )+"</apl:issuerId>
	|        <apl:issueDate>" + ВСД_Запросы.ДатаXML(Текущаядата(), "T00:00:00") + "</apl:issueDate>
	|        <apl:data>
	|          <merc:modifyEnterpriseRequest>
	|            <merc:localTransactionId>"+_guid+"</merc:localTransactionId>
	|            <merc:initiator>
	|              <vd:login>"+( ПараметрыОрганизации["param_intiator_login"] )+"</vd:login>
	|            </merc:initiator>
	|            <merc:modificationOperation>
	|              <vd:type>CREATE</vd:type>
	|              <vd:resultingList>
	|                <dt:enterprise>
	|                  <dt:name>"+ ВыбПлощадка.Наименование+"</dt:name>
	|                  <dt:type>1</dt:type>
	|                  <dt:address>
	|                    <dt:country>
	|                      <bs:guid>"+ ВыбПлощадка.Страна.GUID+"</bs:guid>
	|                    </dt:country>
	|                    <dt:region>
	|                      <bs:guid>"+ ВыбПлощадка.Регион.GUID+"</bs:guid>
	|                    </dt:region>
	|                    <dt:locality>
	|                      <bs:guid>"+ ВыбПлощадка.Город.GUID+"</bs:guid>
	|                    </dt:locality>
	|                    <dt:addressView>"+ ВыбПлощадка.Адрес+"</dt:addressView>
	|                  </dt:address>
	|                  <dt:activityList>
	|                    <dt:activity>
	|                      <dt:name>Приготовление полуфабрикатов</dt:name>
	|                    </dt:activity>
	|                    <dt:activity>
	|                      <dt:name>Реализация пищевых продуктов</dt:name>
	|                    </dt:activity>
	|                    <dt:activity>
	|                      <dt:name>Реализация непищевых продуктов</dt:name>
	|                    </dt:activity>
	|                  </dt:activityList>
	|                  <dt:owner>
	|                    <bs:guid>"+ ВыбПлощадка.ХозСубъект.GUID+"</bs:guid>
	|                  </dt:owner>
	|                </dt:enterprise>
	|              </vd:resultingList>
	|              <vd:reason>Добавление предприятия в реестр.</vd:reason>
	|            </merc:modificationOperation>
	|          </merc:modifyEnterpriseRequest>
	|        </apl:data>
	|      </apl:application>
	|    </apldef:submitApplicationRequest>
	|  </SOAP-ENV:Body>
	|</SOAP-ENV:Envelope>";

	Возврат ЗапросXML;
КонецФункции

&НаСервере
Процедура Площадка_Создать( ВыбПлощадка ) Экспорт
	
	Организация = ВСД_Общий.ПолучитьОрганизациюПоУмолчанию();	
	ПараметрыОрганизации = ВСД.ЗагрузитьПараметры( Организация );
	
	Если ПустаяСтрока(ВыбПлощадка.ХозСубъект.GUID) Тогда
		ВСД.СообщитьИнфо("Не указан Guid ХозСубъекта");
		Возврат;
	КонецЕсли;
	Если ПустаяСтрока(ВыбПлощадка.Адрес) Тогда
		ВСД.СообщитьИнфо("Не указан Адрес");
		Возврат;
	КонецЕсли;

	Если ПустаяСтрока(ВыбПлощадка.Страна.GUID) Тогда
		ВСД.СообщитьИнфо("Не указан Страна.GUID");
		Возврат;
	КонецЕсли;

	Если ПустаяСтрока(ВыбПлощадка.Регион.GUID) Тогда
		ВСД.СообщитьИнфо("Не указан Регион.GUID");
		Возврат;
	КонецЕсли;

	Если ПустаяСтрока(ВыбПлощадка.Город.GUID) Тогда
		ВСД.СообщитьИнфо("Не указан Город.GUID");
		Возврат;
	КонецЕсли;
	
	//Если КомпонентаНаСервере = Неопределено тогда
	//	ЗагрузитьГлПеременныеИзВременногоХранилища();
	//КонецЕсли;
	
	ВСД.СообщитьИнфо(" Запрос CreateEnterprise [ "+СокрЛП(ВыбПлощадка)+" ]");		
	//Результат = КомпонентаНаСервере.CreateEnterprise(
	ЗапросXML = Площадка_Создать_Запрос(	ПараметрыОрганизации, ВыбПлощадка );	
	Service = "platform/services/ApplicationManagementService";//"platform/cerberus/services/EnterpriseService";
	Action = "modifyEnterprise";
	
	ПараметрыОтправки = ВСД_Отправка.ПараметрыОтправкиИнициализация( ПараметрыОрганизации );
	ПараметрыОтправки.ЗапросXML = ЗапросXML;
    ПараметрыОтправки.Service = Service;
    ПараметрыОтправки.Action = Action;
	xdto = ВСД_Отправка.ОтправитьSOAPНаСервере( ПараметрыОтправки );
	
	Статус = ВСД_Запросы.СтатусЗапроса(xdto);
	Если ВСД_Запросы.НайтиОшибки( xdto ) Тогда
		Возврат ;
	КонецЕсли;
	
	appID = ВСД_Отправка.Получить_ApplicationID( xdto );
	
	Если ЗначениеЗаполнено(appID) Тогда
		Площадка_ПолучитьОтвет( ПараметрыОрганизации, appID, ВыбПлощадка );
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура Площадка_ПолучитьОтвет( ПараметрыОрганизации, appID, ВыбПлощадка) Экспорт
	
	Если ПустаяСтрока(appID)=1 Тогда
		ВСД.СообщитьИнфо("Не указано applicationID");
		Возврат;
	КонецЕсли;
	
	ВСД_Запросы.Пауза( ПараметрыОрганизации["ПаузаСек"] );	
	
	ВСД.СообщитьИнфо(" Запрос CreateEnterpriseResult [ "+СокрЛП(appID)+" ]");		
	
	xdto = ВСД_Отправка.ПолучитьРезультатСервер( ПараметрыОрганизации, appID );
	
	Статус = ВСД_Запросы.СтатусЗапроса(xdto);
	Если ВСД_Запросы.НайтиОшибки(xdto) Тогда
		Возврат ;
	КонецЕсли;
		
	Если Статус = "COMPLETED" Тогда
	    Попытка
			enterprise = xdto.Body.receiveApplicationResultResponse.application.result.modifyEnterpriseResponse.enterprise;
			guid = enterprise.guid;
			_uuid = enterprise.uuid;
			active = enterprise.active;
			Попытка name = enterprise.name; Исключение	name = enterprise.fio;	КонецПопытки;
			
			ОбъектПлощадка = ВыбПлощадка.ПолучитьОбъект();
			ОбъектПлощадка.guid = guid;
			ОбъектПлощадка.uuid = _uuid;
			ОбъектПлощадка.Записать();
			ВСД.СообщитьИнфо("Успешно записан ВСД_Площадка ["+ВыбПлощадка+"] GUID = "+GUID);
		      			
			Площадка_СвязатьСХозСубъектом( ПараметрыОрганизации, ВыбПлощадка);
		Исключение
			ВСД.СообщитьИнфо("Ошибка "+ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция Площадка_СвязатьСХозСубъектом_Запрос( ПараметрыОрганизации, ВыбПлощадка ) 
	_guid = Новый УникальныйИдентификатор;
	ЗапросXML = "
	|<SOAP-ENV:Envelope 
	|xmlns:bs='http://api.vetrf.ru/schema/cdm/base'
	|xmlns:merc='http://api.vetrf.ru/schema/cdm/mercury/g2b/applications/v2'
	|xmlns:apldef='http://api.vetrf.ru/schema/cdm/application/ws-definitions'
	|xmlns:apl='http://api.vetrf.ru/schema/cdm/application'
	|xmlns:vd='http://api.vetrf.ru/schema/cdm/mercury/vet-document/v2'
	|xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'>
	|  <SOAP-ENV:Header/>
	|  <SOAP-ENV:Body>
	|    <apldef:submitApplicationRequest>
	|      <apldef:apiKey>"+СокрЛП( ПараметрыОрганизации["param_api_key"] )+"</apldef:apiKey>
	|      <apl:application>
	|        <apl:serviceId>mercury-g2b.service:2.0</apl:serviceId>
	|        <apl:issuerId>"+СокрЛП( ПараметрыОрганизации["param_issuer_id"] )+"</apl:issuerId>
	|        <apl:issueDate>" + ВСд_Запросы.ДатаXML(Текущаядата(), "T00:00:00") + "</apl:issueDate>
	|        <apl:data>
	|          <merc:modifyActivityLocationsRequest>
	|            <merc:localTransactionId>"+_guid+"</merc:localTransactionId>
	|            <merc:initiator>
	|              <vd:login>"+СокрЛП( ПараметрыОрганизации["param_intiator_login"] )+"</vd:login>
	|            </merc:initiator>
	|            <merc:modificationOperation>
	|              <vd:type>CREATE</vd:type>
	|              <vd:businessEntity>
	|                <bs:guid>"+ВыбПлощадка.ХозСубъект.GUID+"</bs:guid>
	|              </vd:businessEntity>
	|              <vd:activityLocation>
//	|                <vd:globalID>7574894948562</vd:globalID>
//	|                <vd:globalID>5412345123453</vd:globalID>
	|                <vd:enterprise>
	|                  <bs:guid>"+ВыбПлощадка.GUID+"</bs:guid>
	|                </vd:enterprise>
	|              </vd:activityLocation>
	|            </merc:modificationOperation>
	|          </merc:modifyActivityLocationsRequest>
	|        </apl:data>
	|      </apl:application>
	|    </apldef:submitApplicationRequest>
	|  </SOAP-ENV:Body>
	|</SOAP-ENV:Envelope>";	
	
	Возврат ЗапросXML;
КонецФункции

&НаСервере
Процедура Площадка_СвязатьСХозСубъектом( ПараметрыОрганизации, ВыбПлощадка) Экспорт
	Если ПустаяСтрока(ВыбПлощадка.ХозСубъект.GUID) Тогда 
		ВСД.СообщитьИнфо("не указан GUID ХозСубъекта");
		Возврат;
	КонецЕсли;
		
	Если ПустаяСтрока(ВыбПлощадка.GUID) Тогда 
		ВСД.СообщитьИнфо("площадке не указан GUID");
		Возврат;
	КонецЕсли;
	
	ВСД_Запросы.Пауза( ПараметрыОрганизации["ПаузаСек"] );	
	
	ВСД.СообщитьИнфо(" Запрос CreateActivityLocationsOperation [ "+СокрЛП(ВыбПлощадка)+" ]");		
	ЗапросXML = Площадка_СвязатьСХозСубъектом_Запрос( ПараметрыОрганизации, ВыбПлощадка );	
	Service = "platform/services/ApplicationManagementService";
	Action = "modifyActivityLocations";
	
	ПараметрыОтправки = ВСД_Отправка.ПараметрыОтправкиИнициализация( ПараметрыОрганизации );
	ПараметрыОтправки.ЗапросXML = ЗапросXML;
    ПараметрыОтправки.Service = Service;
    ПараметрыОтправки.Action = Action;
	xdto = ВСД_Отправка.ОтправитьSOAPНаСервере( ПараметрыОтправки );
	
	Статус = ВСД_Запросы.СтатусЗапроса(xdto);
	Если ВСД_Запросы.НайтиОшибки( xdto ) Тогда
		Возврат ;
	КонецЕсли;
	
	appID = ВСД_Отправка.Получить_ApplicationID( xdto );
	
	Если ЗначениеЗаполнено(appID) Тогда
		Площадка_СвязатьСХозСубъектом_Ответ( ПараметрыОрганизации, appID );
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура Площадка_СвязатьСХозСубъектом_Ответ( ПараметрыОрганизации, appID )
	
	Если ПустаяСтрока(appID) Тогда
		ВСД.СообщитьИнфо("Не указано applicationID");
		Возврат;
	КонецЕсли;
	
	ВСД.СообщитьИнфо(" Запрос CreateActivityLocationsOperationResult [ "+СокрЛП(appID)+" ]");		
	
	ВСД_Запросы.Пауза( ПараметрыОрганизации["ПаузаСек"] );	
	
	ВСД.СообщитьИнфо(" Запрос CreateEnterpriseResult [ "+СокрЛП(appID)+" ]");		
	
	xdto = ВСД_Отправка.ПолучитьРезультатСервер( ПараметрыОрганизации, appID );
	
	Статус = ВСД_Запросы.СтатусЗапроса(xdto);
	Если ВСД_Запросы.НайтиОшибки(xdto) Тогда
		Возврат ;
	КонецЕсли;
		
	Если Статус = "COMPLETED" Тогда
		ВСД.СообщитьИнфо("Успешно установлена связь ВСД_Площадка ");
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПоказатьОповещениеПользователя("Выполняем запрос",,"Ожидайте...",БиблиотекаКартинок.Информация32);
	
	Площадка_Создать(ПараметрКоманды);
	
	ПоказатьОповещениеПользователя("Операция завершена");
КонецПроцедуры
