@chcp 65001

if exist "build/ib" rmdir /s /q "build/ib"
echo D | xcopy /E /I /Y "D:\DevOps\Demo\Vetis\" "build/ib"
if %ERRORLEVEL% neq 0 (
    echo ОШИБКА: Не удалось скопировать шаблон базы из D:\DevOps\Demo\Vetis\
    echo Проверьте существование каталога источника
    exit /b 1
)


@rem Сборка основной разработческой ИБ. по умолчанию в каталоге build/ib
@rem call vrunner init-dev --src unload/cf --ibconnection "/F./build/ib" --settings tools/vrunner.json

@rem обновление конфигурации основной разработческой ИБ из хранилища. для включения раскомментируйте код ниже
@rem call vrunner loadrepo %*
@rem call vrunner updatedb %*

@rem собрать внешние обработчики и отчеты в каталоге build
@rem call vrunner compileepf src/epf/МояВнешняяОбработка build %*
@rem call vrunner compileepf src/erf/МойВнешнийОтчет build %*

@rem собрать расширения конфигурации внутри ИБ
@rem call vrunner compileext src/cfe/МоеРасширение МоеРасширение %*

@rem Обновление в режиме Предприятия
@rem call vrunner run --command "ЗапуститьОбновлениеИнформационнойБазы;ЗавершитьРаботуСистемы;" --execute $runnerRoot\epf\ЗакрытьПредприятие.epf %*
