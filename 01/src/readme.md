# Домашнее задание к занятию «Введение в Terraform» Колб Дмитрий

# скриншоты были удалены из-за глупости, код не изменился, вроде =)



### Цели задания

1. Установить и настроить Terrafrom.
2. Научиться использовать готовый код.

------

### Чек-лист готовности к домашнему заданию

1. Скачайте и установите **Terraform** версии >=1.8.4 . Приложите скриншот вывода команды ```terraform --version```.
2. Скачайте на свой ПК этот git-репозиторий. Исходный код для выполнения задания расположен в директории **01/src**.
3. Убедитесь, что в вашей ОС установлен docker.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Репозиторий с ссылкой на зеркало для установки и настройки Terraform: [ссылка](https://github.com/netology-code/devops-materials).
2. Установка docker: [ссылка](https://docs.docker.com/engine/install/ubuntu/). 
------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
------

### Задание 1

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте. 
2. Изучите файл **.gitignore**. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?(логины,пароли,ключи,токены итд)
3. Выполните код проекта. Найдите  в state-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.
4. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла **main.tf**.
Выполните команду ```terraform validate```. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.
5. Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды ```docker ps```.
6. Замените имя docker-контейнера в блоке кода на ```hello_world```. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду ```terraform apply -auto-approve```.
Объясните своими словами, в чём может быть опасность применения ключа  ```-auto-approve```. Догадайтесь или нагуглите зачем может пригодиться данный ключ? В качестве ответа дополнительно приложите вывод команды ```docker ps```.
8. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**. 
9. Объясните, почему при этом не был удалён docker-образ **nginx:latest**. Ответ **ОБЯЗАТЕЛЬНО НАЙДИТЕ В ПРЕДОСТАВЛЕННОМ КОДЕ**, а затем **ОБЯЗАТЕЛЬНО ПОДКРЕПИТЕ** строчкой из документации [**terraform провайдера docker**](https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs).  (ищите в классификаторе resource docker_image )


------


## Решение 1

* 1.2 В файле **.gitignore** указано, что личную информацию можно сохранять в файлах с расширением **.tfvars**. ![СИКРЕТФАЙЛ](https://github.com/Chika1703/123/blob/main/images/1%20(2).jpg)

* 1.3 Выполнив код проекта ![КОД](https://github.com/Chika1703/123/blob/main/images/1%20(5).jpg) секретное содержимое созданного ресурса **random_password**: был найден в файле **terraform.tfstate** или же с помощью команды ```terraform show -json | jq -r '.values.root_module.resources[] | select(.address == "random_password.random_string") | .values.result'```. Сам пароль: **94YS3hGKTuSIi9gL** ![ПАРОЛПАРОЛ](https://github.com/Chika1703/123/blob/main/images/1%20(4).jpg) 

* 1.4 Забыл сделать скриншот с командой ```terraform validate```, но думаю это не станет проблемой. Ответ на вопрос "Объясните, в чём заключаются намеренно допущенные ошибки": изначально в закоментированных строках не указан обязательный параметр name для ресурса docker_image. А так же неправильный синтаксис в определении ресурса

* 1.5 Исправленный код
```
resource "docker_image" "nginx" {  #Добавлено имя ресурса "nginx"
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {  #Исправлено имя (удалена цифра "1")
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"  #Исправлена ссылка на random_password

  ports {
    internal = 80
    external = 9090
  }
}
```
![ИСПРАВЛЕННЫЙ КОД + ПС](https://github.com/Chika1703/123/blob/main/images/1%20(3).jpg)


* 1.6 Меняем имя контейнера на ```hello_world```:
  Было ```name  = "example_${random_password.random_string_FAKE.resulT"```
  Стало ```name  = "hello_world"```
  Применяем команду ```terraform apply -auto-approve```

Минусы : команда применяет изменения без подтверждения пользователя, что может привести к нежелательным изменениям в инфраструктуре.

Плюсы: команда может использоваться в CI/CD пайплайнах для автоматического применения изменений.

выполняем ```docker ps```

![УДАЛНИЕ](https://github.com/Chika1703/123/blob/main/images/1%20(6).jpg)


* 1.8 Применяем команду ```terraform destroy``` и проверяем файл **terraform.tfstate**
![УДАЛНИЕ](https://github.com/Chika1703/123/blob/main/images/1%20(1).jpg)

* 1.9 В коде для ресурса docker_image указан параметр ```keep_locally = true```, который предотвращает удаление образа при уничтожении ресурсов.
Подтверждение из документации:
"If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the Docker local storage on destroy operation."

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 

### Задание 2*

1. Создайте в облаке ВМ. Сделайте это через web-консоль, чтобы не слить по незнанию токен от облака в github(это тема следующей лекции). Если хотите - попробуйте сделать это через terraform, прочитав документацию yandex cloud. Используйте файл ```personal.auto.tfvars``` и гитигнор или иной, безопасный способ передачи токена!
2. Подключитесь к ВМ по ssh и установите стек docker.
3. Найдите в документации docker provider способ настроить подключение terraform на вашей рабочей станции к remote docker context вашей ВМ через ssh.
4. Используя terraform и  remote docker context, скачайте и запустите на вашей ВМ контейнер ```mysql:8``` на порту ```127.0.0.1:3306```, передайте ENV-переменные. Сгенерируйте разные пароли через random_password и передайте их в контейнер, используя интерполяцию из примера с nginx.(```name  = "example_${random_password.random_string.result}"```  , двойные кавычки и фигурные скобки обязательны!) 
```
    environment:
      - "MYSQL_ROOT_PASSWORD=${...}"
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - "MYSQL_PASSWORD=${...}"
      - MYSQL_ROOT_HOST="%"
```

6. Зайдите на вашу ВМ , подключитесь к контейнеру и проверьте наличие секретных env-переменных с помощью команды ```env```. Запишите ваш финальный код в репозиторий.

### Задание 3*
1. Установите [opentofu](https://opentofu.org/)(fork terraform с лицензией Mozilla Public License, version 2.0) любой версии
2. Попробуйте выполнить тот же код с помощью ```tofu apply```, а не terraform apply.
------

### Правила приёма работы

Домашняя работа оформляется в отдельном GitHub-репозитории в файле README.md.   
Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 

