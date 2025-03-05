# Quadro de Vagas

![Rails](https://img.shields.io/badge/rails-%23CC0000.svg?style=flat-square&logo=ruby-on-rails&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=flat-square&logo=docker&logoColor=white)
![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=flat-square&logo=postgresql&logoColor=white)
![TailwindCSS](https://img.shields.io/badge/tailwindcss-%2338B2AC.svg?style=flat-square&logo=tailwind-css&logoColor=white)
![Stimulus](https://img.shields.io/badge/stimulus-%23772299.svg?style=flat-square&logo=stimulus&logoColor=white)
![RSpec](https://img.shields.io/badge/rspec-%23c21325.svg?style=flat-square&logo=ruby&logoColor=white)
![Rubocop](https://img.shields.io/badge/rubocop-%23000000.svg?style=flat-square&logo=rubocop&logoColor=white)
![CI/CD](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=flat-square&logo=githubactions&logoColor=white)

Plataforma moderna para gerenciamento e publicação de vagas de emprego, desenvolvida com Ruby on Rails 8 e StimulusJS.

## 📋 Conteúdo

- [Requisitos](#requisitos)
- [Configuração e Execução](#configuração-e-execução)
- [Executando Testes](#executando-testes)
- [Stack do Projeto](#stack-do-projeto)
- [Desenvolvimento](#desenvolvimento)
- [Contribuição](#contribuição)
- [Licença](#licença)

## 🛠️ Requisitos

- [Docker](https://www.docker.com/products/docker-desktop/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Extensão Dev Containers para VS Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## 🚀 Configuração e Execução

### Utilizando Dev Containers

1. Clone o repositório:
   ```bash
   git clone https://github.com/rubinostrilhos/quadro-vagas-rb
   cd quadro-de-vagas
   ```

2. Abra o projeto no VS Code:
   ```bash
   code .
   ```

3. Quando o VS Code detectar o arquivo `.devcontainer`, clique em "Reopen in Container" na notificação.

   Alternativamente:
   - Pressione `F1`
   - Digite "Dev Containers: Open Folder in Container"
   - Selecione o diretório do projeto

4. Após o container ser construído, execute:
   ```bash
   bin/dev
   ```

5. Acesse a aplicação em `http://localhost:3000`

## 🧪 Executando Testes

```bash
# No terminal dentro do Dev Container
rspec                              # Executa todos os testes
rspec ./spec/system                # Executa apenas testes de sistema/integração
```

Para executar o linter:

```bash
bin/rubocop                        # Verifica todos os arquivos
bin/rubocop -a                     # Corrige automaticamente problemas simples
```

## 💻 Stack do Projeto

| Tecnologia | Versão | Propósito |
|------------|--------|-----------|
| Ruby | 3.4.2 | Linguagem de programação |
| Rails | 8.0.1 | Framework web |
| PostgreSQL | 16 | Banco de dados |
| StimulusJS | 1.3.4 | Interatividade front-end |
| Tailwind CSS | 3.x | Framework CSS |
| RSpec-rails | 7.x | Framework de testes |
| Capybara | 3.x | Testes de interface |
| Cuprite | 0.15 | Driver para testes JS |
| Rubocop | 1.x | Linter e formatador |

## 🔧 Desenvolvimento

### Principais diretórios

```
.
├── app/                    # Código principal da aplicação
│   ├── controllers/        # Controladores
│   ├── javascript/         # Assets JS e controladores Stimulus
│   │   └── controllers/    # Controladores Stimulus
│   ├── models/             # Modelos
│   └── views/              # Views
├── config/                 # Configurações Rails
├── db/                     # Migrações e seeds
├── spec/                   # Testes
│   ├── system/             # Testes de integração
│   └── models/             # Testes de modelos
└── .devcontainer/          # Configurações do Dev Container
```

### Trabalhando com StimulusJS

Os controladores Stimulus estão localizados em `app/javascript/controllers/`. Para criar um novo controlador:

1. Crie um arquivo `nome_controller.js` seguindo esta estrutura:

```javascript
// app/javascript/controllers/exemplo_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output"]

  connect() {
    console.log("Controlador Stimulus conectado!")
  }

  executar() {
    this.outputTarget.textContent = "Ação executada!"
  }
}
```

2. Use-o em um template:

```html
<div data-controller="exemplo">
  <div data-exemplo-target="output"></div>
  <button data-action="click->exemplo#executar">Executar</button>
</div>
```

### Comandos úteis

```bash
bin/rails g controller Nome  # Gerar novo controlador
bin/rails g model Nome       # Gerar novo modelo
bin/rails routes             # Listar rotas disponíveis
bin/rails db:migrate         # Executar migrações pendentes
bin/rails c                  # Abrir console Rails
```

## 👥 Contribuição

1. Faça um fork do projeto
2. Crie e acesse uma branch para sua feature (`git switch -c feat/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feat/nova-funcionalidade`)
5. Crie um novo Pull Request

### Convenções de código

- Utilize [Rubocop](https://github.com/rubocop/rubocop) para verificar o estilo de código
- Todos os testes devem passar antes de submeter um PR
- Siga as convenções do Rails para nomes de arquivos e classes

## 📄 Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.