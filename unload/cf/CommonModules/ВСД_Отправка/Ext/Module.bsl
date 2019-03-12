﻿

Функция ПолучитьBase64ЗаголовокАвторизации(ИмяПользователя, Пароль)

    КодировкаФайла = КодировкаТекста.UTF8;
    ВременныйФайл = ПолучитьИмяВременногоФайла();
    Запись = Новый ЗаписьТекста(ВременныйФайл, КодировкаФайла);
    Запись.Записать(ИмяПользователя+":"+Пароль);
    Запись.Закрыть();

    ДвДанные = Новый ДвоичныеДанные(ВременныйФайл);
    Результат = Base64Строка(ДвДанные);
    УдалитьФайлы(ВременныйФайл);

    Результат = Сред(Результат,5);

    Возврат Результат;

КонецФункции

Процедура ОтправитьСтатистику( ПараметрыОтправки )
	
	//Сервер = "public.services.dellin.ru";
	//Ресурс = "/tracker/XML/";
	//HTTP =  Новый HTTPСоединение(Сервер);
	//ФайлЗапроса = ПолучитьИмяВременногоФайла();
	//ТекстовыйФайл = Новый ТекстовыйДокумент;
	//ТекстовыйФайл.УстановитьТекст("&rwID=" + СокрЛП(НомерНакладной));
	//ТекстовыйФайл.Записать(ФайлЗапроса, КодировкаТекста.UTF8);
	//ФайлРезультата = ПолучитьИмяВременногоФайла();
	//
	//ЗаголовокHTTP = Новый Соответствие();
	//ЗаголовокHTTP.Вставить("Content-Type", "application/x-www-form-urlencoded");
	//ЗаголовокHTTP.Вставить("Accept-Language", "ru");
	//ЗаголовокHTTP.Вставить("Accept-Charset", "utf-8");
	//ЗаголовокHTTP.Вставить("Content-Language", "ru");
	//ЗаголовокHTTP.Вставить("Content-Charset", "utf-8");
	//HTTP.ОтправитьДляОбработки(ФайлЗапроса, Ресурс, ФайлРезультата, ЗаголовокHTTP);
	//
	//Ответ = Новый ТекстовыйДокумент();
	//Ответ.Прочитать(ФайлРезультата, КодировкаТекста.UTF8);
	//ТекстОтвета = Ответ.ПолучитьТекст();
	//УдалитьФайлы(ФайлЗапроса);
	//УдалитьФайлы(ФайлРезультата);
	
   Попытка
        WinHttp = Новый COMОбъект("WinHttp.WinHttpRequest.5.1");
        WinHttp.Option(2,"utf-8");
        WinHttp.Open("POST","http://www.google-analytics.com/collect",0);
        WinHttp.SetRequestHeader("Accept-Language", "ru");
        WinHttp.SetRequestHeader("Accept-Charset","utf-8");
        WinHttp.setRequestHeader("Content-Language", "ru");
        WinHttp.setRequestHeader("Content-Charset", "utf-8");
        WinHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
		_UUID = ПараметрыСеанса.ТекущийПользователь.УникальныйИдентификатор();
        ПараметрыПОСТ = "v=1&tid=UA-135686245-1&cid=" + _UUID +"&uid="+ПараметрыОтправки["param_username"]+"&t=event&ec="+ПараметрыОтправки["param_username"]+"&ea="+ПараметрыОтправки["Action"];
        WinHttp.Send(ПараметрыПОСТ);
        ТекстОтвета = WinHttp.ResponseText();
    Исключение
        Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

Функция ИнициализироватьСоединение( ПараметрыОтправки );
	
    Попытка
        xmlHttp = New COMОбъект("MSXML2.xmlHttp");
        //Адрес = "https://api2.vetrf.ru:8002/";
		//ИмяПользователя = СписокКонстант.param_username;
		//Пароль = СписокКонстант.param_password;
    	//Service = "platform/services/ProductService";
    	//Action = "GetSubProductByProductList";		
		//Хост = "https://api2.vetrf.ru:8002/";
        xmlHttp.OPEN("POST", ПараметрыОтправки["Адрес"] + ПараметрыОтправки["Service"], False);
        xmlHttp.setRequestHeader ("Host", ПараметрыОтправки["Адрес"]);
        xmlHttp.setRequestHeader ("Content-type", "text/xml; charset=utf-8");
		xmlHttp.setRequestHeader("Authorization", "Basic "+ПолучитьBase64ЗаголовокАвторизации(ПараметрыОтправки["param_username"], ПараметрыОтправки["param_password"]));
    Исключение
        ВызватьИсключение("Не удалось создать объект ""MSXML2.xmlHttp"":"+ ОписаниеОшибки());		
        Возврат Неопределено;
    КонецПопытки;

	ОтправитьСтатистику( ПараметрыОтправки );
	
    Возврат xmlHttp;
КонецФункции

Процедура ЗаписатьВФайл(Соединение, Параметры )
	UUID = Строка(Новый УникальныйИдентификатор);
	Если ЗначениеЗаполнено(Параметры["КаталогЛогов"]) Тогда 
		ИмяФайла = ""+Параметры["КаталогЛогов"]+Параметры["Action"]+"_"+UUID+"_request.xml";
	Иначе
		ИмяФайла = КаталогВременныхФайлов()+Параметры["Action"]+"_"+UUID+"_request.xml";
	КонецЕсли;
	Файл = Новый ЗаписьТекста(ИмяФайла);	
	Попытка
		Файл.ЗаписатьСтроку(Параметры["ЗапросXML"]);
		Файл.Закрыть();
		ВСД.СообщитьИнфо("Запрос записан в "+ИмяФайла);
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Не удалось записать запрос в файл "+ИмяФайла+"'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	Если ЗначениеЗаполнено(Параметры["КаталогЛогов"]) Тогда 
		ИмяФайла = ""+Параметры["КаталогЛогов"]+Параметры["Action"]+"_"+UUID+"_response.xml";
	Иначе
		ИмяФайла = КаталогВременныхФайлов()+Параметры["Action"]+"_"+UUID+"_response.xml";
	КонецЕсли;
	Файл = Новый ЗаписьТекста(ИмяФайла);
	Попытка
		Файл.ЗаписатьСтроку(Соединение.responseText);
		Файл.Закрыть();	
		ВСД.СообщитьИнфо("Ответ записан в "+ИмяФайла);
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Не удалось записать запрос в файл "+ИмяФайла+"'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
КонецПроцедуры

Функция ОтправитьSOAP_xmlHttp( ПараметрыОтправки ) 
	//СтруктураПараметров = ЗагрузитьГлПеременныеИзВременногоХранилища( АдресХранилища );	
	Соединение = ИнициализироватьСоединение( ПараметрыОтправки);
	
	ВСД.СообщитьИнфо("Отправляем запрос");
	//Если Соединение = Неопределено Тогда
	//    Сообщить("Не установлено соединение");
	//    Возврат Неопределено;		
	//КонецЕсли;

    DOC = New COMОбъект("MSXML2.DOMDocument");
    DOC.loadXML( ПараметрыОтправки["ЗапросXML"] );
	
    Соединение.setRequestHeader("SOAPAction", ПараметрыОтправки["Action"] );
 
    Попытка
        Соединение.SEND(DOC);
    Исключение
        Сообщить("Ошибка при отправке запроса данных:" + ОписаниеОшибки());
        Возврат Неопределено;
    КонецПопытки;
    Результат = Соединение.statusText;
    Если Результат <> "OK" Тогда
        ВСД.СообщитьИнфо("Ошибка запроса данных:" + Строка(Результат));
		ЗаписатьВФайл(Соединение, ПараметрыОтправки);
        Возврат Неопределено;
	ИначеЕсли ПараметрыОтправки["ОтладкаЗапросовXML"] Тогда
		ЗаписатьВФайл(Соединение, ПараметрыОтправки);
    КонецЕсли;
    DOCToSave = New COMОбъект("MSXML2.DOMDocument");
    DOCToSave.loadXML(Соединение.responseText);
    Если DOCToSave.parseError.errorCode <> 0 Тогда 
        ВСД.СообщитьИнфо("Ошибка разбора XML результата: " + DOC.parseError.reason);
        Возврат "";
    КонецЕсли;
  
    //Возврат Строка(DOCToSave.xml);
	// обработка ответа 	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(DOCToSave.xml);
	xdto = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	возврат xdto;
КонецФункции

//Параметры = Соответствие()
//Функция ОтправитьSOAPНаСервере(Знач Параметры, АдресХранилища) Экспорт 
Функция ОтправитьSOAPНаСервере(Знач ПараметрыОтправки) Экспорт 
	
    Возврат ОтправитьSOAP_xmlHttp( ПараметрыОтправки);
	//Возврат ОтправитьЗапрос_DLL( ТекстЗапроса, Service, Action, АдресХранилища);
	
КонецФункции

//Параметры = Соответствие()
Функция ОтправитьЗапрос_DLL( Параметры , АдресХранилища) Экспорт
	
	ВСД.СообщитьИнфо("Отправляем запрос");
	
	метод = Параметры.КомпонентаНаСервере.GetMethod();
	//метод.Service = "platform/services/ApplicationManagementService";
	//метод.Action = "receiveApplicationResult";
	метод.Service = Параметры.Service;
	метод.Action = Параметры.Action;
			
	appID = Новый УникальныйИдентификатор;
	ВСД.СообщитьИнфо( "Отправляем запрос "+appID );
	результат = Параметры.КомпонентаНаСервере.SendRequestSoap(метод, Параметры.ЗапросXML, appID);
	//appID = Получить_ApplicationID( СтруктураПараметров.КомпонентаНаСервере.LogFilename ); // = результат
	ВСД.СообщитьИнфо("Загрузка XML-файла: " + Параметры.КомпонентаНаСервере.LogFilename); 
	
	//Текст = Новый ЧтениеТекста(СтруктураПараметров.КомпонентаНаСервере.LogFilename, КодировкаТекста.ANSI);
	//Стр = Текст.ПрочитатьСтроку();
	//Пока Стр <> Неопределено Цикл // строки читаются до символа перевода строки    
	//    Стр = Стр + "
	//	|"+ Текст.ПрочитатьСтроку();
	//КонецЦикла;
	ЧтениеXML = новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл( Параметры.КомпонентаНаСервере.LogFilename);
	xdto = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		
	//ИмяФайлаОтвет =  КомпонентаНаКлиенте.LogFilename;   //
	Возврат xdto;
КонецФункции


Функция ПолучитьРезультатСервер(Параметры, appID) Экспорт
	//appID = СокрЛП( Параметры["appID"] );
	Если НЕ ЗначениеЗаполнено(appID) Тогда 
		ВызватьИсключение("Пустой appID")
	КонецЕсли;
	
	//ЗапросXML ="<SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'><SOAP-ENV:Header/><SOAP-ENV:Body>
	//|<receiveApplicationResultRequest xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'>
	//  |<apiKey xmlns='http://api.vetrf.ru/schema/cdm/application/ws-definitions'>"+ Параметры["param_api_key"] +"</apiKey>
	//  |<issuerId xmlns='http://api.vetrf.ru/schema/cdm/application/ws-definitions'>"+ Параметры["param_issuer_id"] +"</issuerId>
	//  |<applicationId xmlns='http://api.vetrf.ru/schema/cdm/application/ws-definitions'>"+ (appID) +"</applicationId>
	//|</receiveApplicationResultRequest>
	//|</SOAP-ENV:Body></SOAP-ENV:Envelope>
	//|";

	ЗапросXML = "
	|<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:ws='http://api.vetrf.ru/schema/cdm/application/ws-definitions'>
	|   <soapenv:Header/>
	|   <soapenv:Body>
	|      <ws:receiveApplicationResultRequest>
	|         <ws:apiKey>"+ Параметры["param_api_key"] +"</ws:apiKey>
	|         <ws:issuerId>"+ Параметры["param_issuer_id"] +"</ws:issuerId>
	|         <ws:applicationId>"+ (appID) +"</ws:applicationId>
	|      </ws:receiveApplicationResultRequest>
	|   </soapenv:Body>
	|</soapenv:Envelope>
	|";

    Service = "platform/services/ApplicationManagementService";
    Action = "receiveApplicationResult";

	ВСД.СообщитьИнфо("Получаем ответ на запрос "+appID);
	ПараметрыОтправки = ВСД_Отправка.ПараметрыОтправкиИнициализация( Параметры );
	ПараметрыОтправки.ЗапросXML = ЗапросXML;
    ПараметрыОтправки.Service = Service;
    ПараметрыОтправки.Action = Action;
	xdto = ВСД_Отправка.ОтправитьSOAPНаСервере( ПараметрыОтправки );

	//Результат = КомпонентаНаСервере.SendRequestSoap( метод, запрос, appID );

	//appID = Получить_ApplicationID(Компонента.LogFilename);
	//Возврат appID;

	//Возврат Результат;
	возврат xdto;
КонецФункции

Функция Получить_ApplicationID( xdto ) Экспорт
	applicationId="";
	Попытка

		//ЧтениеXML = новый ЧтениеXML;
		//ЧтениеXML.ОткрытьФайл(LogFilename);	
		//xdto = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		applicationId = xdto.Body.submitApplicationResponse.application.applicationId;
		st = xdto.Body.submitApplicationResponse.application.status;

		ВСД.СообщитьИнфо("Ответ: ["+applicationId+"] ["+st+"]");
	Исключение
		ВСД.СообщитьИнфо("Не удалось получить applicationId");
		
	КонецПопытки;

	возврат applicationId;
КонецФункции


//Процедура ПоместитьГлПеременныеВоВременноеХранилище(АдресХранилища) Экспорт
//	СтруктураПараметров = Новый Структура();
//	//"Компонента", Компонента);
//	СтруктураПараметров.Вставить("Константы", СписокКонстант);
//	//СтруктураПараметров.Вставить("ТермическиеУсловияПеревозки", ТермическиеУсловияПеревозки);
//	//СтруктураПараметров.Вставить("ТермическиеУсловияПеревозки2", ТермическиеУсловияПеревозки2);
//	
//	//АдресСпискаКонстантнаСервере	= ПоместитьВоВременноеХранилище(Структура,Новый УникальныйИдентификатор);
//	ПараметрыНаСервере		= ПоместитьВоВременноеХранилище(Структура, UUID);
//КонецПроцедуры

//Функция ЗагрузитьГлПеременныеИзВременногоХранилища( АдресХранилища ) Экспорт
//	СтруктураПараметров = ПолучитьИзВременногоХранилища(АдресХранилища);
//	//КомпонентаНаСервере = Неопределено;
//	//СтруктураПараметров.Свойство( "Компонента", КомпонентаНаСервере );
//	//СписокКонстант		= СтруктураПараметров.Константы;
//	//ТермическиеУсловияПеревозки	= ПолучитьИзВременногоХранилища(АдресСпискаКонстантнаСервере).ТермическиеУсловияПеревозки;
//	//ТермическиеУсловияПеревозки2= ПолучитьИзВременногоХранилища(АдресСпискаКонстантнаСервере).ТермическиеУсловияПеревозки2;
//	
//	//Если СтруктураПараметров.КомпонентаНаСервере = Неопределено Тогда
//	//	ИнициализацияКомпоненты( СтруктураПараметров );		
//	//	//ПоместитьВоВременноеХранилище(СтруктураПараметров, АдресХранилища);
//	//КонецЕсли;
//	возврат СтруктураПараметров;
//КонецФункции

Процедура ИнициализацияКомпоненты( СписокКонстант )
	
	////СписокКонстант		= СтруктураПараметров.Константы;
	
    Если СписокКонстант.ТестовыйРежим Тогда     
        ВСД.СообщитьИнфо("Тестовый режим");
		ИмяComОбъекта = "AddIn.soap_test2"; 
    Иначе
        ВСД.СообщитьИнфо("Боевой режим");
		ИмяComОбъекта = "AddIn.soap_work2";
	КонецЕсли;
	Если СписокКонстант.КомпонентаНаСервере = Неопределено Тогда 
		Попытка
	        СписокКонстант.КомпонентаНаСервере= Новый COMОбъект(ИмяComОбъекта);
	        ВСД.СообщитьИнфо("Компонента УСПЕШНО загружена на сервере " + СписокКонстант.КомпонентаНаСервере.Version);
		    //Возврат ИнициализироватьКомпоненту(Обработка);	
		Исключение
			СписокКонстант.КомпонентаНаСервере = Неопределено;
			ВСД.СообщитьИнфо("Библиотека не зарегистрирована = "+ ОписаниеОшибки());			
			Возврат ;
		КонецПопытки;
	КонецЕсли;
	
	Попытка
		Опции = СписокКонстант.КомпонентаНаСервере.GetOptions();
	Исключение
		ВызватьИсключение("Компонента не ЗАВЕЛАСЬ = "+ОписаниеОшибки());
		Возврат ;
	КонецПопытки;
	
	Опции.USERNAME 			= СписокКонстант.param_username;
    Опции.PASSWORD 			= СписокКонстант.param_password;
    Опции.ISSUER_ID 		= СписокКонстант.param_issuer_id;
    Опции.SERVICE_ID 		= СписокКонстант.param_service_id;
    Опции.API_KEY 			= СписокКонстант.param_api_key;
    Опции.INITIATOR_LOGIN 	= СписокКонстант.param_intiator_login;
    Опции.VETDOCTOR_LOGIN 	= СписокКонстант.param_vetdoctor_login;
	Опции.LogsDir 			= СписокКонстант.КаталогЛогов;
	Опции.VETDOCTOR_FIO 	= СписокКонстант.param_vetdoctor_fio;
	Опции.VETDOCTOR_POST 	= СписокКонстант.param_vetdoctor_post;
	Опции.DEBUG 			= СписокКонстант.ОтладкаЗапросовXML;
	
	СписокКонстант.КомпонентаНаСервере.Init( Опции );
	ВСД.СообщитьИнфо("Отладка - > Иницализация компоненты для "+СписокКонстант.Отправитель_Площадка);
	//возврат Обработка.КомпонентаНаСервере;

КонецПроцедуры

Функция ПараметрыОтправкиИнициализация( Параметры ) Экспорт 
	
	Если НЕ ЗначениеЗаполнено(Параметры["param_username"]) Тогда
		ВызватьИсключение("Не заполнен параметр [param_username]");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Параметры["param_password"]) Тогда
		ВызватьИсключение("Не заполнен параметр [param_password]");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Параметры["param_issuer_id"]) Тогда
		ВызватьИсключение("Не заполнен параметр [issuer_id]");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Параметры["param_api_key"]) Тогда
		ВызватьИсключение("Не заполнен параметр [param_api_key]");
	КонецЕсли;
	
	ПараметрыОтправки = новый Структура();
	ПараметрыОтправки.Вставить("ЗапросXML", "");
	ПараметрыОтправки.Вставить("Service", "");
	ПараметрыОтправки.Вставить("Action", "");		
	ПараметрыОтправки.Вставить("param_username", Параметры["param_username"]);		
	ПараметрыОтправки.Вставить("param_password", Параметры["param_password"]);		
	//ПараметрыОтправки.Вставить("param_api_key", Параметры["param_api_key"]);			
	//ПараметрыОтправки.Вставить("param_issuer_id", Параметры["param_issuer_id"]);	
	ПараметрыОтправки.Вставить("ОтладкаЗапросовXML", Параметры["ОтладкаЗапросовXML"]);			
	
	Если Параметры["ТестовыйРежим"] Тогда 
		ПараметрыОтправки.Вставить("Адрес", "https://api2.vetrf.ru:8002/");		
	Иначе
		ПараметрыОтправки.Вставить("Адрес", "https://api.vetrf.ru/");	
	КонецЕсли;
	ПараметрыОтправки.Вставить("КаталогЛогов", Параметры["КаталогЛогов"]);		
	
	Возврат ПараметрыОтправки;
КонецФункции