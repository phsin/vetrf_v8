@chcp 65001

echo Запуск синтаксического контроля
call vrunner syntax-check --ibconnection /F./build/ib --settings tools/vrunner.json
