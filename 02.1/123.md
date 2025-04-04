# Отчёт по домашнему заданию «Основы Terraform. Timeweb Cloud»

**Студент:** *Колб Дмитрий*  
**Версия Terraform:** *>= 0.13 (согласно provider.tf)*
**облако** *timeweb.cloud*
---

## Содержание

- [Отчёт по домашнему заданию «Основы Terraform. Timeweb Cloud»](#отчёт-по-домашнему-заданию-основы-terraform-timeweb-cloud)
  - [Содержание](#содержание)
  - [Введение](#введение)
  - [Описание проекта](#описание-проекта)
  - [Структура репозитория и конфигурационные файлы](#структура-репозитория-и-конфигурационные-файлы)
    - [.gitignore](#gitignore)
    - [locals.tf](#localstf)
    - [main.tf](#maintf)
    - [outputs.tf](#outputstf)
    - [provider.tf](#providertf)
    - [terraform.tfvars](#terraformtfvars)
    - [variables.tf](#variablestf)
  - [Скриншоты](#скриншоты)
  - [Заключение](#заключение)

---

## Введение

В данном файле Readme.md представлено выполнение домашнего задания по курсу «Основы Terraform». Задание заключалось в создании инфраструктуры с использованием Terraform, где все конфигурации были параметризованы и структурированы. Для выполнения использовался провайдер Timeweb Cloud, из-за невозможности использования Yandex cloud и AWS.

Если загрузить текущую директорию, создать API-токен и SSH-ключ, вставив их в защищенный файл *tfvars и в сервисе, то всё будет работать. Проверял на двух ПК в разных сетях. 

---

## Описание проекта

В рамках работы были выполнены следующие задачи:

- Создание двух виртуальных машин (ВМ): веб-сервера и БД-сервера.  
- Использование переменных для параметризации конфигураций, включая параметры вычислительных ресурсов.  
- Определение локальных переменных для формирования имён ВМ с учетом рабочего окружения (workspace).  
- Организация вывода параметров (outputs) для получения информации об именах, внешних IP и идентификаторах созданных ресурсов.  
- Применение best practices по организации файлов: использование файла `.gitignore` для исключения временных файлов, состояний и конфигураций, содержащих чувствительные данные.

---

## Структура репозитория и конфигурационные файлы

### .gitignore

```gitignore
# Директория с установленными модулями Terraform 
.terraform/

# Файлы состояния Terraform
terraform.tfstate
terraform.tfstate.backup

# Логи работы
*.log
crash.log

# Файл с переменными, содержащими чувствительные данные (например, API токен)
terraform.tfvars

# Файлы переопределения (override files)
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Конфигурационные файлы CLI
.terraformrc
```

### locals.tf

```hcl
locals { 
  vm_web_full_name = "${var.vm_web_name}-${terraform.workspace}"
  vm_db_full_name  = "${var.vm_db_name}-${terraform.workspace}"
}
```

*Комментарий:* Здесь определены локальные переменные, объединяющие имя ВМ с именем рабочего окружения, что позволяет использовать единое наименование при развертывании.

### main.tf

```hcl
data "twc_configurator" "configurator" { 
  location    = "ru-1"
  preset_type = "premium"
}

data "twc_os" "os" {
  name    = "ubuntu"
  version = "22.04"
}

resource "twc_ssh_key" "default" {
  name = "netology-key"
  body = var.vm_ssh_public_key # Используем переменную
}

resource "twc_server" "web_server" {
  name         = local.vm_web_full_name # Используем local
  os_id        = data.twc_os.os.id
  ssh_keys_ids = [twc_ssh_key.default.id]

  configuration {
    configurator_id = data.twc_configurator.configurator.id
    disk            = 1024 * 15
    cpu             = var.vms_resources.web.cpu
    ram             = var.vms_resources.web.ram
  }
}

resource "twc_server" "db_server" {
  name         = local.vm_db_full_name # Используем local
  os_id        = data.twc_os.os.id
  ssh_keys_ids = [twc_ssh_key.default.id]

  configuration {
    configurator_id = data.twc_configurator.configurator.id
    disk            = 1024 * 15
    cpu             = var.vms_resources.db.cpu
    ram             = var.vms_resources.db.ram
  }
}
```

*Комментарий:* В файле `main.tf` создаются два ресурса серверов (веб и БД) с использованием данных о системе, SSH ключах и параметрах ресурсов из переменной `vms_resources`.

### outputs.tf

```hcl
output "web_server" {
  value = {
    name        = twc_server.web_server.name
    external_ip = twc_server.web_server.networks[0].ips[0].ip
    id          = twc_server.web_server.id
  }
}

output "db_server" {
  value = {
    name        = twc_server.db_server.name
    external_ip = twc_server.db_server.networks[0].ips[0].ip
    id          = twc_server.db_server.id
  }
}
```

*Комментарий:* Здесь настроены выходные данные для удобного получения информации о созданных серверах.

### provider.tf

```hcl
terraform {
  required_providers {
    twc = {
      source  = "tf.timeweb.cloud/timeweb-cloud/timeweb-cloud"
      version = ">= 0.13"
    }
  }
}

provider "twc" {
  token = var.twc_token 
}
```

*Комментарий:* В данном файле указан провайдер Timeweb Cloud и его конфигурация с использованием API-токена.

### terraform.tfvars

```hcl
twc_token = "тут апишка"
vm_ssh_public_key = "тут ssh ключ"
```

*Комментарий:* Файл содержит чувствительные данные, такие как API-токен и публичный SSH-ключ, и исключён из контроля версий через `.gitignore`.

### variables.tf

```hcl
variable "twc_token" { 
  type        = string
  sensitive   = true
  description = "API token for Timeweb Cloud"
}

variable "vm_ssh_public_key" {
  type        = string
  description = "SSH public key for VM access"
}

variable "vm_web_name" {
  type    = string
  default = "netology-develop-platform-web"
}

variable "vm_db_name" {
  type    = string
  default = "netology-develop-platform-db"
}

variable "vms_resources" {
  type = map(object({
    cpu = number
    ram = number
  }))
  default = {
    web = { cpu = 1, ram = 1024 }
    db  = { cpu = 2, ram = 2048 }
  }
}

# variable "vm_web_cpu" {
#  type    = number
#  default = 1
# }

# variable "vm_web_ram" {
#   type    = number
#   default = 1024
# }

# variable "vm_db_cpu" {
#   type    = number
#   default = 2
# }

# variable "vm_db_ram" {
#   type    = number
#   default = 2048
# }
```

*Комментарий:* Здесь определены все необходимые переменные, включая map-переменную `vms_resources`, которая объединяет параметры для двух серверов. Закомментированные переменные не используются после перехода на map-подход.

---

## Скриншоты

Ниже приведены скриншоты, подтверждающие успешное выполнение задания:

- **Скриншот панели управления Timeweb Cloud с созданными серверами:**  
  ![Панель управления](02.1/images/photo_3_2025-04-04_04-08-18.jpg)
  
- **Скриншот выполнения команды `terraform output` с информацией о серверах:**  
  ![Вывод terraform output](02.1/images/photo_2_2025-04-04_04-08-18.jpg)
  ![Консоль: исправленный IP](02.1/images/photo_1_2025-04-04_04-08-18.jpg)

- **скриншот команды `curl ifconfig.me`**
  ![консоль вм с ipv6](02.1/images/photo_2025-04-04_04-32-12.jpg)
---

## Заключение

В ходе выполнения задания были:

- Созданы конфигурационные файлы с использованием Terraform для развертывания двух серверов в Timeweb Cloud.  
- Реализовано параметризованное задание с использованием переменных, локальных значений и объединённых map-переменных.  
- Настроены выходные данные (outputs) для получения информации о созданных ресурсах.  
- Применены best practices (использование `.gitignore`, организация переменных, разделение конфигураций по файлам).

Все изменения успешно проверены командой `terraform plan`, а вывод `terraform apply` подтвердил корректное создание инфраструктуры.


Параметры `preemptible = true` и `core_fraction = 5` в настройках виртуальных машин (ВМ) могут быть особенно полезны по следующим причинам:

1. **`preemptible = true` (прерываемая ВМ):**
   - **Снижение затрат:** Прерываемые ВМ предоставляются по более низкой цене по сравнению с обычными, что позволяет существенно экономить бюджет при выполнении краткосрочных задач или обучающих проектов.
   - **Ограничения:** Такие ВМ могут быть автоматически остановлены через 24 часа после запуска или при нехватке ресурсов в зоне доступности. Поэтому их рекомендуется использовать для задач, не требующих высокой отказоустойчивости.

2. **`core_fraction = 5` (уровень производительности vCPU):**
   - **Гибкость в использовании ресурсов:** Значение `core_fraction = 5` означает, что ВМ получает 5% от производительности виртуального процессора. Это подходит для задач с низкой нагрузкой на CPU, таких как тестирование или обучение, где высокая вычислительная мощность не требуется.
   - **Экономия ресурсов:** Использование низкого значения `core_fraction` позволяет снизить стоимость аренды ВМ, что важно при ограниченном бюджете на обучение.

Таким образом, комбинация этих параметров позволяет эффективно и экономично использовать облачные ресурсы для образовательных целей, тестирования и разработки, где высокая производительность и отказоустойчивость не являются критичными.
Вся информация взяна из документации yandex cloud

---

*Примечание:*
* Дополнительные задания (со звёздочкой*) не выполнялись.
* Дата и информация о серверах может отличаться из-за доработки мной кода (вывод ipv4 не удастся подключить, т. к. его нет, но есть ipv6, что я и продемонстрировал).
* Надеюсь, не будет вопросов, почему я предоставил итоговый код. Я старался в короткие сроки найти рабочее облако, разобраться с его документацией и написать рабочий код, соответствующий заданию, что удалось не с первого раза. Еще раз надеюсь на взаимопонимание.
