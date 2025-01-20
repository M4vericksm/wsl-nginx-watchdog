---

# WSL NGINX Watchdog

Este projeto é um sistema de monitoramento para o servidor **NGINX** no ambiente **WSL (Windows Subsystem for Linux)**. Ele verifica se o NGINX está ativo, registra o status em logs e exibe o status em uma interface web simples.

---

## 📚 Sumário
1. [📄 Arquivos e Funcionalidades](#-arquivos-e-funcionalidades)
2. [🚀 Como Usar](#-como-usar)
    - [Instalação](#instalação)
    - [Executar o Monitoramento](#executar-o-monitoramento)
    - [Automatizar o Monitoramento](#automatizar-o-monitoramento)
    - [Acessar a Interface Web](#acessar-a-interface-web)
3. [⚠️ Possíveis Problemas e Soluções](#-possíveis-problemas-e-soluções)
    - [CORS](#cors-cross-origin-resource-sharing)
    - [Cache do Navegador](#cache-do-navegador)
    - [Permissões de Arquivo](#permissões-de-arquivo)
    - [Configuração do NGINX](#configuração-do-nginx)
4. [📝 Exemplos de Saída](#-exemplos-de-saída)

---

## 📄 Arquivos e Funcionalidades
### **📂 docs**
- **`install_wsl_ubuntu.md`**: Guia passo a passo para instalar o WSL e o Ubuntu no Windows, além da configuração do NGINX.
- **`crontab_setup.md`**: Instruções para configurar o cron (agendador de tarefas do Linux) para executar o script de monitoramento periodicamente.

### **📂 scripts**
- **`script_monitoring.sh`**: Script principal que verifica se o NGINX está ativo e registra o status nos logs e no arquivo `status.json`.
  - Exemplo de saída no log:
    ```plaintext
    2025-01-13 18:20:01 - nginx - ONLINE
    ```
  - Se o NGINX estiver offline, a saída será:
    ```plaintext
    2025-01-13 18:20:01 - nginx - OFFLINE
    ```
- **`start_nginx.sh`**: Script para iniciar o NGINX automaticamente caso ele esteja offline.

### **📂 logs**
- **`status_online.log`**: Arquivo de log que registra quando o NGINX está online. Cada entrada segue o formato:
  ```
  ANO-MÊS-DIA HORA:MINUTO:SEGUNDO - nginx - ONLINE
  ```
- **`status_offline.log`**: Arquivo de log que registra quando o NGINX está offline. Cada entrada segue o formato:
  ```
  ANO-MÊS-DIA HORA:MINUTO:SEGUNDO - nginx - OFFLINE
  ```

### **Outros Arquivos**
- **`.gitignore`**: Lista de arquivos e pastas que devem ser ignorados pelo Git (ex.: logs e `status.json`).
- **`setup.sh`** *(opcional)*: Script para configurar o ambiente e instalar dependências necessárias.

---

## 🚀 Como Usar

### Instalação
1. Siga o guia em `docs/install_wsl_ubuntu.md` para configurar o WSL, Ubuntu e NGINX.
2. Clone este repositório:
   ```bash
   git clone https://github.com/M4vericksm/wsl-nginx-watchdog.git
   ```
3. Navegue até a pasta do projeto:
   ```bash
   cd wsl-nginx-watchdog
   ```

### Executar o Monitoramento
Execute o script de monitoramento manualmente:
```bash
bash scripts/script_monitoring.sh
```
Verifique os logs em:
- **`logs/status_online.log`**
- **`logs/status_offline.log`**

### Automatizar o Monitoramento
Configure o cron para executar o script periodicamente. Siga as instruções em **`docs/crontab_setup.md`**.

### Acessar a Interface Web

#### Configurar o NGINX para servir a pasta do projeto
1. Abra o arquivo de configuração do NGINX:
   ```bash
   sudo nano /etc/nginx/sites-available/default
   ```
2. Localize a seção `server` e modifique o `root` para apontar para a pasta `web` do projeto. Exemplo:
   ```nginx
   server {
       listen 80 default_server;
       listen [::]:80 default_server;

       root /caminho/para/wsl-nginx-watchdog/web;
       index index.html;

       server_name _;

       location / {
           try_files $uri $uri/ =404;
       }
   }
   ```
   Substitua **`/caminho/para/wsl-nginx-watchdog/web`** pelo caminho absoluto da pasta `web` no seu sistema.

3. Reinicie o NGINX para aplicar as mudanças:
   ```bash
   sudo systemctl restart nginx
   ```

4. Acesse a interface web:
   Abra o navegador e acesse:
   ```
   http://localhost/index.html
   ```

---

## ⚠️ Possíveis Problemas e Soluções

### CORS (Cross-Origin Resource Sharing)
Se o navegador bloquear o carregamento do `status.json` devido a políticas de CORS:
1. Certifique-se de que o arquivo `status.json` está no mesmo domínio que a interface web.
2. Configure o servidor para permitir o acesso ao arquivo `status.json`, se necessário.

### Cache do Navegador
Se a interface web não estiver atualizando o status:
- Adicione um parâmetro único à URL do `status.json` no JavaScript:
  ```javascript
  const response = await fetch(`status.json?${new Date().getTime()}`);
  ```
- Limpe o cache do navegador ou abra a página em uma guia anônima.

### Permissões de Arquivo
Se o script não conseguir escrever nos logs ou no `status.json`:
1. Verifique as permissões:
   ```bash
   ls -l logs/status_online.log
   ls -l web/status.json
   ```
2. Corrija as permissões, se necessário:
   ```bash
   chmod 644 logs/status_online.log
   chmod 644 web/status.json
   ```

### Configuração do NGINX
Se o NGINX não estiver funcionando corretamente, verifique os seguintes pontos:

#### NGINX não inicia ou falha ao reiniciar
Verifique os logs do NGINX para identificar o erro:
```bash
sudo journalctl -u nginx
sudo tail -n 50 /var/log/nginx/error.log
```
Corrija quaisquer erros apontados, como problemas de sintaxe ou permissões inadequadas.

#### Erro 403 (Forbidden) ao acessar a interface web
Verifique se o diretório raiz definido no `root` da configuração do NGINX está correto:
```nginx
root /caminho/para/wsl-nginx-watchdog/web;
```
Ajuste as permissões do diretório e dos arquivos:
```bash
sudo chmod -R 755 /caminho/para/wsl-nginx-watchdog/web
sudo chown -R www-data:www-data /caminho/para/wsl-nginx-watchdog/web
```

#### Erro 404 (Not Found) ao acessar index.html
Certifique-se de que o arquivo `index.html` está no diretório especificado no `root`:
```bash
ls /caminho/para/wsl-nginx-watchdog/web/index.html
```
Corrija o caminho no arquivo de configuração do NGINX, se necessário.

#### Testar a configuração do NGINX
Antes de reiniciar o NGINX, teste se a configuração está correta:
```bash
sudo nginx -t
```
Se houver erros, corrija-os conforme indicado no terminal.

#### Porta 80 já em uso
Verifique qual processo está usando a porta 80:
```bash
sudo lsof -i :80
```
Finalize o processo em conflito ou mude a porta do NGINX:
```nginx
server {
    listen 8080;
    ...
}
```

---

## 📝 Exemplos de Saída

### Logs
Exemplo de entrada no `status_online.log`:
```plaintext
2025-01-19 18:20:01 - nginx - ONLINE
```
Exemplo de entrada no `status_offline.log`:
```plaintext
2025-01-19 18:20:01 - nginx - OFFLINE
```

### `status.json`
Exemplo de conteúdo:
```json
{
  "status": "online",
  "timestamp": "2025-01-19 18:20:01"
}
```

---
