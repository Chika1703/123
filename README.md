# Домашнее задание к занятию «Репликация и масштабирование. Часть 1» Dmitry Kolb

## Задание 1

На лекции рассматривались режимы репликации master-slave, master-master, опишите их различия.
Ответить в свободной форме.

### решение 

#### Ключевые различия:
| Параметр | Master-Slave | Master-Master |
| ------------- | ------------- | ------------- |
| Количество Master серверов | 1 | 2 и более |
| Запись | Только на Master | На всех Master |
| Чтение | На всех Slave | На всех Master |
| Доступность | Master — точка отказа | Высокая (без точки отказа) |
| Конфликты | Нет | Возможны |
| Простота настройки | Проще | Сложнее |

Выбор режима зависит от задач:
* Master-Slave подходит для систем с большим числом операций чтения.
* Master-Master — для распределённых систем с интенсивной записью и высокой отказоустойчивостью.
    
## Задание 2

Выполните конфигурацию master-slave репликации, примером можно пользоваться из лекции.

Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.

### решение
Вся настройка докера находится в [папке](https://github.com/Chika1703/Replication-and-scaling-1/tree/main/mysql_repl_master_slave). материал был взят с лекции, docker-compose.yml переписал под себя. 

* работоспособность контейнеров: ![image 3](png/3.png)

* создание таблицы на master: ![image 1](png/1.png)

* проверка таблицы на slave: ![image 2](png/2.png)
