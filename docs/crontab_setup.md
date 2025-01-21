

### **Configuração do Cron para Monitoramento do NGINX**

1. **Abra o terminal do Ubuntu**.
2. **Execute o seguinte comando para editar o crontab**:
   ```bash
   crontab -e
   ```

3. **Se for a primeira vez que você usa o crontab**, ele pedirá para escolher um editor de texto. Escolha o editor de sua preferência (por exemplo, `nano`).

4. **Adicione a seguinte linha ao arquivo do crontab**:
   ```bash
   */5 * * * * /bin/bash /caminho/para/wsl-nginx-watchdog/scripts/script_monitoring.sh
   ```

5. **Salve e feche o arquivo**:
   - Se estiver usando o editor `nano`, pressione `Ctrl + O` para salvar e `Ctrl + X` para sair.

6. **Verifique se a tarefa foi adicionada corretamente**:
   Execute o comando abaixo para listar as tarefas agendadas no crontab:
   ```bash
   crontab -l
   ```

   A saída deve mostrar a linha que você adicionou:
   ```
   */5 * * * * /bin/bash /caminho/para/wsl-nginx-watchdog/scripts/script_monitoring.sh
   ```

7. **Aguarde alguns minutos** e verifique os logs para confirmar que o script está sendo executado:
   - **Logs de status online**: `logs/status_online.log`
   - **Logs de status offline**: `logs/status_offline.log`

   Exemplo de entrada no log:
   ```
   2025-01-19 18:20:01 - nginx - ONLINE
   ```

