pipeline {
    agent any
    
    options {
        timeout(time: 2, unit: 'HOURS')
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }
    
    environment {
//        V8_VERSION = "8.3.25.1374"
//        IB_PATH = "./build/ib"
    }
    
    stages {

      /*   stage('Check Allure on agent') {
            steps {
                script {
                    try {
                        def allureHome = tool name: 'allure2'   // имя из Global Tool Configuration
                        withEnv(["PATH+ALLURE=${allureHome}/bin"]) {
                            bat(label: 'Allure version (Windows)', script: 'allure --version || exit /b 0')
                        }
                        echo "Allure tool найден и настроен"
                    } catch (Exception e) {
                        echo "Allure tool не настроен в Jenkins: ${e.getMessage()}"
                        echo "Проверьте Global Tool Configuration -> Allure Commandline"
                        echo "Или настройте переменную окружения ALLURE_HOME"
                    }
                }
            }
        } */

      /*   stage('Diag session') {
            steps {
                bat '''
                @chcp 65001
                echo ===== CURRENT SESSION =====
                echo SESSIONNAME=%SESSIONNAME%
                query user
                echo ===== 1C PROCESSES =====
                tasklist /v /fi "imagename eq 1cv8.exe"
                wmic process where "name='1cv8.exe'" get processid,sessionid,commandline
                echo ===== JAVA/AGENT SESSION =====
                wmic process where "name='java.exe'" get processid,sessionid,commandline
                '''
            }
        } */


        /* stage('Подготовка') {
            steps {
                echo "Подготовка рабочего пространства"
                 bat '''
                    rem Создание основных каталогов
                    if not exist build mkdir build
                    if not exist build\\out mkdir build\\out
                    if not exist build\\out\\allure mkdir build\\out\\allure
                    
                    rem Создание каталогов для логов
                    if not exist build\\logs mkdir build\\logs
                    if not exist build\\logs\\errors mkdir build\\logs\\errors
                    if not exist build\\logs\\client mkdir build\\logs\\client
                    
                    rem Создание каталогов для отчетов
                    if not exist build\\reports mkdir build\\reports
                    if not exist build\\reports\\allure mkdir build\\reports\\allure
                    if not exist build\\reports\\ScreenShots mkdir build\\reports\\ScreenShots
                    if not exist build\\reports\\junit mkdir build\\reports\\junit
                    
                    echo Каталоги созданы
                ''' 
            }
        } */
        
        stage('Создание ИБ из шаблона') {
            steps {
                echo "Создание информационной базы из шаблона"
                script {
                        echo "Копирование шаблона базы данных"
                        bat """
                            chcp 65001 > nul
                            prepare.cmd
                        """
                }
            }
        }
        
        
        // stage('Обновление из хранилища') {
        //     steps {
        //         echo "Загрузка конфигурации из хранилища"
        //         bat """
        //             chcp 65001 > nul
        //             call build.cmd repo
        //         """
        //     }
        // }
        
        stage('Сборка и загрузка из репозитория') {
            steps {
                echo "Сборка и загрузка из репозитория"
                bat """
                    chcp 65001 > nul
                    call build.cmd 
                """
            }
        }
                
        stage('Start BDD Tests') {
            steps {
                echo "Запуск BDD тестов с подробным логированием"
                script {
                    try {
                        bat """
                            chcp 65001 > nul
                            call test.cmd 
                        """
                    } catch (Exception e) {
                        echo "BDD тесты завершились с ошибками: ${e.getMessage()}"
                        
                        // // Выводим содержимое основных логов
                        // if (fileExists('build/buildstatus.log')) {
                        //     echo "=== Содержимое buildstatus.log ==="
                        //     bat 'type build\\buildstatus.log'
                        // }
                        
                        // if (fileExists('build/logs/vanessa-execution.log')) {
                        //     echo "=== Содержимое vanessa-execution.log (последние 50 строк) ==="
                        //     bat 'powershell "Get-Content build\\logs\\vanessa-execution.log -Tail 50"'
                        // }
                        
                        // if (fileExists('build/logs/vanessa-console.log')) {
                        //     echo "=== Содержимое vanessa-console.log (последние 30 строк) ==="
                        //     bat 'powershell "Get-Content build\\logs\\vanessa-console.log -Tail 30"'
                        // }
                        
                        /* // Список файлов ошибок
                        bat '''
                            echo === Список файлов ошибок ===
                            if exist build\\logs\\errors\\*.* (
                                dir /b build\\logs\\errors\\*.*
                            ) else (
                                echo Файлов ошибок не найдено
                            )
                        ''' */
                        
                        // Продолжаем выполнение для публикации отчетов
                        currentBuild.result = 'UNSTABLE'
                    }
                }
            }
        }

        stage('Синтаксический контроль') {
            steps {
                echo "Выполнение синтаксического контроля"
                bat """
                    chcp 65001 > nul
                    call syntax-check.cmd
                """
            }
        }
    }
    
    post {
        always {
            echo "Публикация отчетов и сбор статистики"
            script {
                // Публикация отчетов Allure (Vanessa тесты)
                if (fileExists('out/smoke/allure')) {
                    allure([
                        includeProperties: false,
                        jdk: '',
                        properties: [],
                        reportBuildPolicy: 'ALWAYS',
                        results: [[path: 'out/smoke/allure']]
                    ])
                }
                
                // Публикация синтаксических отчетов (JUnit)
                if (fileExists('build/reports/syntax-check/junit')) {
                    junit testResults: 'build/reports/syntax-check/junit/*.xml', allowEmptyResults: true
                }
                
                // Публикация синтаксических отчетов (Allure)
                if (fileExists('build/reports/syntax-check/allure')) {
                    allure([
                        includeProperties: false,
                        jdk: '',
                        properties: [],
                        reportBuildPolicy: 'ALWAYS',
                        results: [[path: 'build/reports/syntax-check/allure']]
                    ])
                }
                
                // Публикация результатов тестов JUnit (Vanessa тесты)
                if (fileExists('out/smoke/junit')) {
                    echo "Найдены JUnit отчеты Vanessa тестов"
                    junit testResults: 'out/smoke/junit/*.xml', allowEmptyResults: true
                } else {
                    echo "JUnit файлы Vanessa тестов не найдены в out/smoke/junit/"
                }                
                // Публикация HTML отчета с логами
                if (fileExists('build/logs')) {
                    publishHTML([
                        allowMissing: true,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'build/logs',
                        reportFiles: '*.log',
                        reportName: 'Vanessa Test Logs',
                        reportTitles: 'Логи тестирования Vanessa'
                    ])
                }
                
                // Архивирование всех артефактов
                archiveArtifacts artifacts: 'build/**/*.log', allowEmptyArchive: true
                archiveArtifacts artifacts: 'build/logs/**/*', allowEmptyArchive: true
                archiveArtifacts artifacts: 'build/reports/**/*', allowEmptyArchive: true
                archiveArtifacts artifacts: 'out/smoke/**/*', allowEmptyArchive: true
            }
        }
        success {
            echo "Pipeline выполнен успешно"
        }
        failure {
            echo "Pipeline завершился с ошибкой"
            script {
                // Отправка email при ошибке
                if (env.CHANGE_ID == null) { // только для основной ветки
                    mail to: 'fa@kb99.pro',
                         subject: "Jenkins Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                         body: """Сборка завершилась с ошибкой.
                         
Проект: ${env.JOB_NAME}
Номер сборки: ${env.BUILD_NUMBER}
URL: ${env.BUILD_URL}

Проверьте логи для получения деталей."""
                }
            }            
        }
    }
}