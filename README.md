# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

### Грибанов Антон. FOPS-31

### Цели задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src).


### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav). 
Этот функционал понадобится к следующей лекции.

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
------

### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.
Убедитесь что ваша версия **Terraform** ~>1.8.4

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net).
4. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**.
5. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_001.png)

#### Ошибки:

   * Строка platform_id = "standart-v4" -> неверно написано слово standard
   * Версия v4 неверная. Согласно документации Yandex.Cloud (https://cloud.yandex.ru/docs/compute/concepts/vm-platforms) платформы могут быть только v1, v2 и v3.
   * В строке cores = 1 указано неправильное количество ядер процессора. Согласно документации Yandex.Cloud (https://cloud.yandex.ru/docs/compute/concepts/performance-levels) минимальное количество виртуальных ядер - 2.

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_002.png)

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_003.png)

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_004.png)

6. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.
Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_005.png)

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_006.png)

7. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.

   * Параметр preemptible = true применяется для того, чтобы сделать виртуальную машину прерываемой, то есть возможность остановки ВМ в любой момент.
   * Параметр core_fraction=5 указывает базовую производительность ядра в процентах. Указывается для экономии ресурсов.

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
- ответы на вопросы.


### Задание 2

1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.

#### Изменения в main.tf
```bash
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
```

2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf.

#### Изменения в variables.tf
```bash
variable "vm_web_family" {
  type = string
  default = "ubuntu-2004-lts"
  description = "ubuntu ver"
}

variable "vm_web_name" {
  type = string
  default = "netology-develop-plarform-web"
  description = "instance name"
}

variable "vm_web_platform_id" {
  type = string
  default = "standard-v1"
  description = "Platform ID"
}

variable "vm_web_cores" {
  type = string
  default = "2"
  description = "vCPU"
}

variable "vm_web_memory" {
  type = string
  default = "1"
  description = "VM memory"
}

variable "vm_web_core_fraction" {
  type = string
  default = "5"
  description = "core fraction"
}
```

3. Проверьте terraform plan. Изменений быть не должно. 

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_007.png)

### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
   
```bash
variable "vm_db_family" {
  type = string
  default = "ubuntu-2004-lts"
  description = "ubuntu ver"
}

variable "vm_db_name" {
  type = string
  default = "netology-develop-platform-db"
  description = "instance name"
}

variable "vm_db_platform_id" {
  type = string
  default = "standard-v1"
  description = "Platform ID"
}

variable "vm_db_cores" {
  type = string
  default = "2"
  description = "vCPU"
}

variable "vm_db_memory" {
  type = string
  default = "2"
  description = "VM memory"
}

variable "vm_db_core_fraction" {
  type = string
  default = "20"
  description = "core fraction"
}

variable "default_zone2" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}


variable "vpc_name2" {
  type        = string
  default     = "develop2"
  description = "VPC network & subnet name"
}

variable "default_cidr2" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}
```

2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"
3. Примените изменения.

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_008.png)


### Задание 4

1. Объявите в файле outputs.tf **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
2. Примените изменения.

```bash
output "VMs" {
  value = {
    instance_name1 = yandex_compute_instance.platform.name
    external_ip1 = yandex_compute_instance.platform.network_interface.0.nat_ip_address
    instance_name2 = yandex_compute_instance.platform2.name
    external_ip2 = yandex_compute_instance.platform2.network_interface.0.nat_ip_address
  }
}
```

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_009.png)

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.


### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.

```bash
locals {
  project = "netology-develop-platform"
  env_web = "web"
  env_db = "db"
  vm_web_instance_name = "${local.project}-${local.env_web}"
  vm_db_instance_name = "${local.project}-${local.env_db}"

}
```

2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_010.png)

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_011.png)

3. Примените изменения.

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_012.png)


### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map(object).  
   ```
   пример из terraform.tfvars:
   vms_resources = {
     web={
       cores=2
       memory=2
       core_fraction=5
       hdd_size=10
       hdd_type="network-hdd"
       ...
     },
     db= {
       cores=2
       memory=4
       core_fraction=20
       hdd_size=10
       hdd_type="network-ssd"
       ...
     }
   }
   ```

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_013.png)

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_014.png)

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_015.png)
   
2. Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.
   ```
   пример из terraform.tfvars:
   metadata = {
     serial-port-enable = 1
     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
   }
   ```  

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_016.png)
  
3. Найдите и закоментируйте все, более не используемые переменные проекта.
4. Проверьте terraform plan. Изменений быть не должно.

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_017.png)

------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   
Они помогут глубже разобраться в материале. Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 


------
### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list.

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_018.png)

2. Найдите длину списка test_list с помощью функции length(<имя переменной>).

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_019.png)
  
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_020.png)

4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

```bash

output "admin_server_info" {
  value =  "${local.test_map.admin} is admin for ${local.test_list[length(local.test_list)-1]} server based on OS ${local.servers[local.test_list[length(local.test_list)-1]]["image"]} with ${local.servers[local.test_list[length(local.test_list)-1]]["cpu"]} vcpu, ${local.servers[local.test_list[length(local.test_list)-1]]["ram"]} ram, and ${local.servers.production["disks"][0]}, ${local.servers.production["disks"][1]}, ${local.servers.production["disks"][2]}, ${local.servers.production["disks"][3]} virtual disks."
}
```

![hw_02](https://github.com/Qshar1408/hw_02/blob/main/img/hw_02_021.png)

**Примечание**: если не догадаетесь как вычленить слово "admin", погуглите: "terraform get keys of map"

В качестве решения предоставьте необходимые команды и их вывод.

------

### Задание 8*
1. Напишите и проверьте переменную test и полное описание ее type в соответствии со значением из terraform.tfvars:
```
test = [
  {
    "dev1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
      "10.0.1.7",
    ]
  },
  {
    "dev2" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
      "10.0.2.29",
    ]
  },
  {
    "prod1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
      "10.0.1.30",
    ]
  },
]
```
2. Напишите выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117" из этой переменной.
------

------

### Задание 9*

Используя инструкцию https://cloud.yandex.ru/ru/docs/vpc/operations/create-nat-gateway#tf_1, настройте для ваших ВМ nat_gateway. Для проверки уберите внешний IP адрес (nat=false) у ваших ВМ и проверьте доступ в интернет с ВМ, подключившись к ней через serial console. Для подключения предварительно через ssh измените пароль пользователя: ```sudo passwd ubuntu```

### Правила приёма работыДля подключения предварительно через ssh измените пароль пользователя: sudo passwd ubuntu
В качестве результата прикрепите ссылку на MD файл с описанием выполненой работы в вашем репозитории. Так же в репозитории должен присутсвовать ваш финальный код проекта.

**Важно. Удалите все созданные ресурсы**.


### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 
