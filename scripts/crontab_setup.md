## Passo 1: Editar o Crontab

1. Abra o terminal do Ubuntu.
2. Execute o seguinte comando para editar o crontab:
   ```bash
   crontab -e
   ```
3. Se for a primeira vez que você usa o crontab, ele pedirá para escolher um editor de texto. Escolha o editor de sua preferência (por exemplo, `nano`).

---

## Passo 2: Adicionar a Tarefa ao Cron

1. No arquivo do crontab, adicione a seguinte linha para executar o script a cada 5 minutos:
   ```bash
   */5 * * * * /caminho/para/wsl-nginx-watchdog/scripts/script_monitoring.sh
   ```
   - Substitua **`/caminho/para/wsl-nginx-watchdog`** pelo caminho absoluto da pasta do projeto no seu sistema.

2. Salve e feche o arquivo.

---

## Passo 3: Verificar se a Tarefa Está Funcionando

1. Aguarde alguns minutos e verifique os logs em **`logs/status_online.log`** e **`logs/status_offline.log`** para confirmar que o script está sendo executado.
