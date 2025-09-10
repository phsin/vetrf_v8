pipeline {
    agent any
    
    options {
        timeout(time: 2, unit: 'HOURS')
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }
    
    environment {
        V8_VERSION = "8.3.25.1374"
        IB_PATH = "./build/ib"
    }
    
    stages {

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
                // Публикация отчетов Allure
                if (fileExists('build/out/allure')) {
                    allure([
                        includeProperties: false,
                        jdk: '',
                        properties: [],
                        reportBuildPolicy: 'ALWAYS',
                        results: [[path: 'build/out/allure']]
                    ])
                }

                // Публикация синтаксических отчетов (JUnit)
                if (fileExists('build/reports/syntax-check/junit')) {
                    junit testResults: 'build/reports/syntax-check/junit/*.xml', allowEmptyResults: true
                }
                
/*                 // Публикация синтаксических отчетов (Allure)
                if (fileExists('build/reports/syntax-check/allure')) {
                    allure([
                        includeProperties: false,
                        jdk: '',
                        properties: [],
                        reportBuildPolicy: 'ALWAYS',
                        results: [[path: 'build/reports/syntax-check/allure']]
                    ])
                } */
                
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