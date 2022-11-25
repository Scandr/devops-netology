1. Установите Bitwarden плагин для браузера. Зарегистрируйтесь и сохраните несколько паролей.
![Alt text](images/1.JPG?raw=true "Title")
![Alt text](images/1.JPG?raw=true "Title")
2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.
Не могу выполнить из-за устаревшей версии ОС телефона
3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.
Ставим веб сервер
```
sudo apt install apache
```
Разрешаем модуль SSL:
```
$ sudo a2enmod ssl
$ sudo systemctl restart apache2
```
Создаем сертификат:
```
$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
```
Вывод:
```
Generating a RSA private key
........................................+++++
....................+++++
writing new private key to '/etc/ssl/private/apache-selfsigned.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ru
State or Province Name (full name) [Some-State]:msk
Locality Name (eg, city) []:msk
Organization Name (eg, company) [Internet Widgits Pty Ltd]:test
Organizational Unit Name (eg, section) []:tet
Common Name (e.g. server FQDN or YOUR name) []:localhost
Email Address []:
```
Делаем конфиг для apache2
```
$ cd /etc/apache2/sites-available/
$ sudo vi test.conf
```
В конфиге:
```
<VirtualHost *:443>
   ServerName localhost
   DocumentRoot /var/www/html

   SSLEngine on
   SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
   SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
</VirtualHost>
```
Подгружаем конфиг серверу:
```
$ sudo a2ensite ./test.conf
$ sudo apache2ctl configtest
Syntax OK
$ sudo systemctl reload apache2
```
Делаем тестовый файл:
```
$ sudo vi /var/www/html/index2.html
$ cat /var/www/html/index2.html
<h1>it is a secured connection</h1>
```
Проверяем:
```
$ curl -k https://localhost:443/index2.html
<h1>it is a secured connection</h1>
```
Где -k для принятия сертификата