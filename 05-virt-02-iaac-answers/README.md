
# Домашнее задание к занятию "2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.

  - Простота масштабирования инфраструктуры за счет того,что для разворачивания одинаковых машин (с одинаковыми настройками) применяется один и тот же файл, а для разворачивания набора машин с другими параметрами требуется только скопировать и поменять настройки в файле
  - Снижение влияния человеческого фактора при разворачивании инфраструктуры, т.к. файл можно отладить до отсутствия (или минимального количества) ошибок при написании и тестировании и в проде использовать уже отлаженный файл. Таким образом, инженерам нужно будет только запустить файл через систему автоматизации (IaaC), а не проводить все натсройки ВМ пошагово (чем больше отдельных действий производиться человеком, тем выше вероятность ошибки)
  - Упрощение распространения паттернов, шаблонов, примеров для обмена опытом 

- Какой из принципов IaaC является основополагающим?

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?

  - Отсутствием агентов
  - простотой освоения и написания скриптов (используется распространенный язык yaml)
  - популярностью среди инженеров (большое комьюнити), что означает большое количество легко доступных (по запросу в Интернете) примеров имплементации, решений каких-либо задач и ошибок

- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

Скорее всего более простым в обеспечении безопасности соединения является метод push, т.к. для него потребуется только обеспечить шифрование передаваемых данных и применения метода аутентификации (чаще всего сертификаты), также при использовании push можно будет использовать безагентный метод передачи конфигурации, что снизит количество открытых портов машины. А для метода pull еще потребуется следить за дополнительным открытым портом, на котором слушает агент для получения новых конфигураций и проверки наличия обновлений. 

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

```
PS C:\Users\yaitk\Documents\courses\netologia\vagrant2> vagrant version
Installed Version: 2.3.0
Latest Version: 2.3.4

To upgrade to the latest version, visit the downloads page and
download and install the latest version of Vagrant from the URL
below:

  https://www.vagrantup.com/downloads.html

If you're curious what changed in the latest release, view the
CHANGELOG below:

  https://github.com/hashicorp/vagrant/blob/v2.3.4/CHANGELOG.md
```

![Alt text](images/virtual_box_ver.png?raw=true "Title")

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```

<details>
  <summary>Вывод консоли при выполенении команды vagrant up - создании ВМ </summary>
  <p>

PS C:\Users\yaitk\Documents\courses\netologia\git_repo_v2\devops-netology\05-virt-02-iaac-answers\src\vagrant> vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Importing base box 'bento/ubuntu-20.04'...
==> server1.netology: Matching MAC address for NAT networking...
==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202206.03.0' is up to date...
==> server1.netology: Setting the name of the VM: server1.netology
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology: Warning: Connection reset. Retrying...
    server1.netology: Warning: Connection aborted. Retrying...
    server1.netology:
    server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    server1.netology: this with a newly generated keypair for better security.
    server1.netology:
    server1.netology: Inserting generated public key within guest...
    server1.netology: Removing insecure key from the guest if it's present...
    server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
==> server1.netology: Setting hostname...
==> server1.netology: Configuring and enabling network interfaces...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => C:/Users/yaitk/Documents/courses/netologia/git_repo_v2/devops-netology/05-virt-02-iaac-answers/src/vagrant
==> server1.netology: Running provisioner: ansible_local...
    server1.netology: Installing Ansible...
    server1.netology: Running ansible-playbook...
[WARNING]: Ansible is being run in a world writable directory (/vagrant),
ignoring it as an ansible.cfg source. For more information see
https://docs.ansible.com/ansible/devel/reference_appendices/config.html#cfg-in-
world-writable-dir
[WARNING]: Found variable using reserved name: connection

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
ok: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: If you are using a module and expect the file to exist on the remote, see the remote_src option
fatal: [server1.netology]: FAILED! => {"changed": false, "msg": "Could not find or access '~/.ssh/id_rsa.pub' on the Ansible Controller.\nIf you are using a module and expect the file to exist on the remote, see the remote_src option"}
...ignoring

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=git)
ok: [server1.netology] => (item=curl)

TASK [Run script] **************************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=1

  </p>
</details>


<details>
  <summary>После подключения к ВМ с помощью vagrant ssh</summary>
  <p>
vagrant@server1:~$ docker ps  
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES  
vagrant@server1:~$ docker version  
Client: Docker Engine - Community  
 Version:           20.10.22  
 API version:       1.41  
 Go version:        go1.18.9
 Git commit:        3a2c30b
 Built:             Thu Dec 15 22:28:08 2022
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.22
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.18.9
  Git commit:       42c8b31
  Built:            Thu Dec 15 22:25:58 2022
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.15
  GitCommit:        5b842e528e99d4d4c1686467debf2bd4b88ecd86
 runc:
  Version:          1.1.4
  GitCommit:        v1.1.4-0-g5fd4c4d
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
  
  </p>
</details>