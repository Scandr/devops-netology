# devops-netology
repository for Netologia DevOps course 07.2022
first change

При добавлении файла ./.terraform/.gitignore будут проигнорированы 
директория .terraform и файлы в ней, вне зависимости от того, где она находится на локальной машине
все файлы, заканчивающиеся на .tfstate или содержащие в середине .tfstate. или начинающиеся на .tfstate. 
все файлы, заканчивающиеся на .log и начинающиеся на crash., в том числе файл crash.log
все файлы, заканчивающиеся на .tfvars или на .tfvars.json
файлы override.tf и override.tf.json
все файлы, заканчивающиеся на _override.tf или на _override.tf.json
файлы .terraformrc и terraform.rc
