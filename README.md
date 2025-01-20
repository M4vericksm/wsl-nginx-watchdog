
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
5. [🛠️ Tecnologias Utilizadas](#-tecnologias-utilizadas)
6. [⚠️ Aviso sobre Cuidados de Segurança](#-aviso-sobre-cuidados-de-segurança)

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
If the script cannot write to the logs or `status.json`:
1. Check permissions:
   ```bash
   ls -l logs/status_online.log
   ls -l web/status.json
   ```
2. Fix permissions if necessary:
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

## 🛠️ Tecnologias Utilizadas

O projeto **WSL NGINX Watchdog** utiliza as seguintes tecnologias e ferramentas:

### **Linguagens e Scripts**
- **Bash**: Para criação dos scripts de monitoramento e automação.
- **HTML/CSS/JavaScript**: Para a interface web que exibe o status do NGINX.

### **Ferramentas e Serviços**
- **NGINX**: Servidor web usado para servir a interface web e monitorar o status.
- **Systemd**: Para gerenciar o serviço do NGINX no Linux.
- **Cron**: Para agendar a execução automática do script de monitoramento.
- **WSL (Windows Subsystem for Linux)**: Ambiente de desenvolvimento no Windows para executar o Ubuntu e o NGINX.

### **Arquivos e Estrutura**
- **Logs**: Arquivos de texto (`status_online.log` e `status_offline.log`) para registrar o status do NGINX.
- **JSON**: Arquivo `status.json` usado para armazenar o status atual do NGINX e ser lido pela interface web.
- **Git**: Para versionamento e controle do código-fonte.

---

## ⚠️ Aviso sobre Cuidados de Segurança

Ao utilizar este projeto, é importante tomar alguns cuidados para garantir a segurança do sistema:

### **1. Permissões de Arquivos e Diretórios**
- Certifique-se de que os arquivos e diretórios do projeto tenham permissões adequadas. Evite permissões excessivamente permissivas (como `777`).
  ```bash
  sudo chmod -R 755 /caminho/para/wsl-nginx-watchdog
  sudo chown -R www-data:www-data /caminho/para/wsl-nginx-watchdog/web
  ```

### **2. Exposição do NGINX**
- O NGINX está configurado para rodar na porta **80** (HTTP). Se você estiver em um ambiente de produção, considere:
  - Usar HTTPS (SSL/TLS) para criptografar o tráfego.
  - Restringir o acesso ao servidor usando firewalls ou regras de segurança.

### **3. Dados Sensíveis**
- Evite armazenar dados sensíveis (como senhas ou chaves de API) em arquivos de configuração ou scripts. Use variáveis de ambiente ou ferramentas de gerenciamento de segredos.

### **4. Atualizações de Segurança**
- Mantenha o NGINX e o sistema operacional atualizados com as últimas correções de segurança.
  ```bash
  sudo apt update
  sudo apt upgrade -y
  ```

### **5. Monitoramento de Logs**
- Monitore os logs do NGINX e do sistema para identificar atividades suspeitas ou tentativas de acesso não autorizado.
  ```bash
  sudo tail -f /var/log/nginx/access.log
  sudo tail -f /var/log/nginx/error.log
  ```

### **6. Uso do Cron**
- Ao configurar o cron para executar o script de monitoramento, certifique-se de que o script não tenha permissões excessivas e que o crontab esteja protegido contra edições não autorizadas.
  ```bash
  crontab -e
  ```

---
