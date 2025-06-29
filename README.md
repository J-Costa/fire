Para maiores informações cheque a [Wiki](https://github.com/J-Costa/fire/wiki)

For more info check the [Wiki](https://github.com/J-Costa/fire/wiki)

***

### Configurando e rodando o projeto com devcontainer
#### Preparação e ferramentas necessárias
- [Instalar Docker](https://docs.docker.com/engine/install/)
- [Instale o Vs Code](https://code.visualstudio.com/download)
- Para ambos siga os passos de seu SO
#### Utilizando o devcontainer
- Após clonar o projeto e abri-lo com o Vs Code, você deverá receber um prompt para abrir no [devcontainer](https://containers.dev/).
- Após abrir pelo devcontainer, clicando em "Reopen in Container", aguarde o build e o carregamento
- Para rodar o servidor, use o comando: `bin/dev` no terminal.
- A aplicação estará acessível pelo endereço: `http://localhost:3000`
   - O devcontainer também irá configurar o banco de dados com um curso e um usuário de Admin

### Rodando localmente apenas com o banco de dados no container
- Você precisará do ruby instalado via algum gerenciador ou localmente
  - Estou utilizando o [mise](https://mise.jdx.dev/), um gerenciador de versões e linguagens estilo 'asdf'.
- Também precisará do [Docker](https://docs.docker.com/engine/install/)
- Suba o container do banco de dados com o comando `docker compose up` no terminal
- Após subir o container, rode o comando `bundle install` para instalar as dependências do projeto
- Para configurar o banco de dados rode o comando `rails db:setup`
  - Assim, serão criadas as tabelas e o seed com um curso e um usuário de Admin
- Em outro terminal rode o comando `bin/dev` para subir o servidor
- A aplicação estará acessível pelo endereço: `http://localhost:3000`
