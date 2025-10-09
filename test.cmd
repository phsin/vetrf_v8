@chcp 65001
@echo off
echo ========================================
echo ЗАПУСК VANESSA AUTOMATION SINGLE
echo Время: %date% %time%
echo ========================================

@rem Проверяем существование файлов конфигурации
if not exist "tools\VAmin.json" (
    echo ОШИБКА: Не найден файл tools\VAmin.json
    exit /b 1
)

if not exist "tools\vrunner.json" (
    echo ОШИБКА: Не найден файл tools\vrunner.json
    exit /b 1
)

echo Конфигурационные файлы найдены
echo Запуск тестирования...
echo.

call vrunner vanessa --ibconnection "/F./build/ib" --settings tools/vrunner.json

set EXIT_CODE=%ERRORLEVEL%
echo.
echo ========================================
echo ЗАВЕРШЕНИЕ ТЕСТИРОВАНИЯ
echo Код возврата: %EXIT_CODE%
echo Время: %date% %time%
echo ========================================

exit /b %EXIT_CODE% 