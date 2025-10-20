# CuidaDeMim

Sistema Rails para a adoção responsável de cachorros.
A plataforma busca facilitar o processo de adoção conectando pessoas interessadas em adotar com animais que precisam de um lar. 

## 📋 Pré-requisitos

- Docker e Docker Compose

## 🚀 Como executar o projeto

### Use o Docker

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/UnBArqDsw2025-2-Turma01/2025.2-T01-G4_CuidaDeMim_Entrega_03.git
   cd 2025.2-T01-G4_CuidaDeMim_Entrega_03
   ```

2. **Execute os containers:**
   ```bash
   sudo docker compose up -d
   ```

3. **Acesse a aplicação:**
   - Aplicação: http://localhost:3000
 
4. **Comandos úteis:**
   ```bash
   # Ver logs da aplicação
   sudo docker compose logs web
   
   # Executar comandos Rails
   sudo docker compose exec web rails console
   sudo docker compose exec web rails generate model NomeDoModelo
   sudo docker compose exec web rails db:migrate
   
   # Parar os containers
   sudo docker compose down
   
   # Rebuildar a imagem
   sudo docker compose build --no-cache
   ```

## 📚 Documentação

A documentação do projeto está disponível usando Docsify.

### Como executar a documentação:

1. **Instale o Docsify globalmente:**
   ```bash
   npm install -g docsify-cli
   ```

2. **Execute o servidor de documentação:**
   ```bash
   docsify serve ./docs
   ```

3. **Acesse a documentação:**
   - http://localhost:3000 (ou porta indicada no terminal)

### Estrutura da documentação:

- `docs/` - Pasta principal da documentação
- `docs/Projeto/` - Documentação do projeto
- `docs/PadroesDeProjeto/` - Padrões de projeto utilizados
- `docs/index.html` - Página inicial da documentação

## 🛠️ Tecnologias Utilizadas

- **Backend:** Ruby on Rails 7.2.2
- **Frontend:** HTML, CSS (Tailwind), JavaScript (Stimulus)
- **Banco de dados:** PostgreSQL
- **Containerização:** Docker & Docker Compose
- **Documentação:** Docsify

## 📁 Estrutura do Projeto

```
├── app/                    # Código da aplicação Rails
│   ├── controllers/        # Controladores
│   ├── models/            # Modelos
│   ├── views/             # Views
│   └── assets/            # Assets estáticos
├── config/                # Configurações
├── db/                    # Migrações e seeds
├── docs/                  # Documentação
├── test/                  # Testes
├── Dockerfile             # Configuração Docker
├── docker-compose.yml     # Orquestração dos containers
└── Gemfile               # Dependências Ruby
```

## 🔧 Comandos Úteis

### Docker
```bash
# Rebuildar sem cache
sudo docker compose build --no-cache

# Ver logs em tempo real
sudo docker compose logs -f web

# Executar comando em container específico
sudo docker compose exec web bash
```

## 👥 Equipe

- **Grupo:** T01-G4
- **Disciplina:** Arquitetura e Desenho de Software
- **Período:** 2025.2