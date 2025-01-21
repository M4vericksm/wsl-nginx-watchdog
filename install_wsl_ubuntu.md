## 1. Habilitar o WSL (Windows Subsystem for Linux)
1. **Abra o PowerShell como Administrador**.
2. Execute o seguinte comando para habilitar o WSL:
   ```powershell
   wsl --install
   ```
   Esse comando habilita o WSL, instala o kernel do Linux e, por padrão, instala a distribuição Ubuntu.

3. **Reinicie o computador** após a instalação para que as alterações entrem em vigor.

### 2. Instalar o Ubuntu
1. Após reiniciar, o Ubuntu será instalado automaticamente. Se não for, você pode instalá-lo manualmente:
   - Abra a Microsoft Store.
   - Pesquise por "Ubuntu".
   - Escolha a versão desejada (por exemplo, "Ubuntu 20.04 LTS").
   - Clique em "Instalar".

2. **Inicie o Ubuntu**:
   - Após a instalação, abra o Ubuntu no menu Iniciar.
   - Na primeira execução, você será solicitado a criar um nome de usuário e senha para o Ubuntu.

### 3. Instalar o NGINX
1. **Atualize os pacotes do Ubuntu**:
   No terminal do Ubuntu, execute:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. **Instale o NGINX**:
   Execute o seguinte comando para instalar o NGINX:
   ```bash
   sudo apt install nginx -y
   ```

3. **Inicie o NGINX**:
   Após a instalação, inicie o serviço do NGINX:
   ```bash
   sudo systemctl start nginx
   ```

4. **Habilite o NGINX para iniciar automaticamente**:
   Para garantir que o NGINX inicie automaticamente com o sistema, execute:
   ```bash
   sudo systemctl enable nginx
   ```

5. **Verifique o status do NGINX**:
   Para confirmar que o NGINX está em execução, execute:
   ```bash
   sudo systemctl status nginx
   ```

6. **Teste o NGINX**:
   - Abra um navegador no Windows.
   - Acesse `http://localhost`.
   - Se o NGINX estiver funcionando corretamente, você verá a página de boas-vindas do NGINX.
