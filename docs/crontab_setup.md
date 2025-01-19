# Configuração do Cron para Monitoramento do NGINX

O cron é um agendador de tarefas no Linux que permite executar scripts ou comandos em intervalos regulares. Aqui está como configurar o cron para executar o script `script_monitoring.sh` a cada 5 minutos.

## Passo 1: Editar o Crontab

1. Abra o terminal do Ubuntu.
2. Execute o seguinte comando para editar o crontab:
   ```bash
   crontab -e
