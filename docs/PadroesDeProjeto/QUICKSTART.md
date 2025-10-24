# 🚀 Guia de Início Rápido - Padrão Decorator no CuidaDeMim

## ⚡ Setup Rápido

### 1. Instalar Dependências

```bash
# Instalar gems do projeto
bundle install

# Criar banco de dados
rails db:create db:migrate
```

### 2. Testar a Implementação

```bash
# Executar todos os testes
rails test

# Apenas testes do Decorator
rails test test/models/cadastro_pet_decorator_test.rb
```

### 3. Ver o Decorator em Ação

```bash
# Demo interativa
ruby script/demo_decorator.rb

# Ou no console Rails
rails console
```

---

## 💻 Exemplos de Uso no Console

### Abra o console Rails:

```bash
rails console
```

### Exemplo 1: Cadastro Simples

```ruby
# Criar um pet
pet = Pet.new(name: "Rex", species: "Dog", age: 3)

# Cadastro simples (sem decoradores)
cadastro = CadastroPetSimples.new
resultado = cadastro.cadastrar(pet)

puts resultado[:message]
# => "Pet 'Rex' cadastrado com sucesso!"
```

### Exemplo 2: Com Validação

```ruby
# Pet com dados inválidos
pet = Pet.new(name: "", age: -1, species: "Dog")

# Adiciona validação
cadastro = ValidadorDecorator.new(CadastroPetSimples.new)
resultado = cadastro.cadastrar(pet)

puts resultado[:message]
# => "Validação falhou: Nome do pet não pode estar vazio, ..."
```

### Exemplo 3: Cadeia Completa

```ruby
# Criar pet válido
pet = Pet.new(
  name: "Luna",
  species: "Cat",
  age: 2,
  description: "Gata carinhosa"
)

# Construir cadeia de decoradores
cadastro = CadastroPetSimples.new
cadastro = NotificadorDecorator.new(cadastro, canal: 'email')
cadastro = ValidadorDecorator.new(cadastro)
cadastro = AutenticadorDecorator.new(cadastro, autenticado: true, parceiro: "Minha ONG")

# Executar
resultado = cadastro.cadastrar(pet)

# Ver resultado
puts resultado[:message]
puts resultado[:notificacao][:mensagem] if resultado[:notificacao]
```

---

## 🌐 Testando via Interface Web

### 1. Iniciar o servidor

```bash
# Com Docker (recomendado)
docker-compose up

# Ou localmente
./bin/dev
# ou
rails server
```

### 2. Acessar no navegador

```
http://localhost:3000/pets
```

### 3. Criar um novo pet

1. Clique em "New Pet"
2. Preencha os campos:
   - **Name**: Nome do pet (ex: "Rex")
   - **Species**: Espécie (ex: "Dog")
   - **Age**: Idade (ex: 3)
   - **Description**: Descrição opcional
3. Clique em "Create Pet"

### 4. Observar os logs

No terminal onde o servidor está rodando, você verá:

```
Parceiro autenticado (Parceiro Exemplo ONG) procedendo com o cadastro...
Validação bem-sucedida para pet 'Rex'
========================================
📧 NOTIFICAÇÃO DE CADASTRO (via EMAIL)
========================================
Pet: Rex
Espécie: Dog
Idade: 3 ano(s)
...
```

---

## 🧪 Executar Exemplos Completos

### Opção 1: Script de Demonstração

```bash
ruby script/demo_decorator.rb
```

Mostra 6 cenários diferentes de uso do Decorator com saída colorida e formatada.

### Opção 2: Exemplos Detalhados

```bash
rails runner lib/exemplos_decorator.rb
```

Executa 7 exemplos práticos mostrando diferentes combinações de decoradores.

---

## 📊 Estrutura de Resposta

Todos os métodos `cadastrar(pet)` retornam um Hash com:

```ruby
{
  success: true/false,           # Se o cadastro foi bem-sucedido
  message: "...",                # Mensagem descritiva
  pet: #<Pet>,                   # Objeto pet
  notificacao: {                 # Presente apenas se NotificadorDecorator foi usado
    enviada: true,
    canal: 'email',
    mensagem: "..."
  }
}
```

---

## 🔧 Customização

### Adicionar Novo Decorador

1. Crie um novo arquivo em `app/decorators/`:

```ruby
# app/decorators/logger_decorator.rb
class LoggerDecorator < CadastroPetDecorator
  def cadastrar(pet)
    Rails.logger.info("=== Iniciando cadastro de #{pet.name} ===")
    resultado = super(pet)
    Rails.logger.info("=== Cadastro finalizado: #{resultado[:success]} ===")
    resultado
  end
end
```

2. Use na cadeia:

```ruby
cadastro = CadastroPetSimples.new
cadastro = LoggerDecorator.new(cadastro)
cadastro = ValidadorDecorator.new(cadastro)
resultado = cadastro.cadastrar(pet)
```

### Alterar Canal de Notificação

```ruby
# Email
NotificadorDecorator.new(cadastro, canal: 'email')

# SMS
NotificadorDecorator.new(cadastro, canal: 'sms')

# Push notification
NotificadorDecorator.new(cadastro, canal: 'push')
```

### Mudar Ordem dos Decoradores

```ruby
# Ordem 1: Autentica → Valida → Cadastra → Notifica
cadastro = NotificadorDecorator.new(
  ValidadorDecorator.new(
    AutenticadorDecorator.new(
      CadastroPetSimples.new,
      autenticado: true
    )
  )
)

# Ordem 2: Valida → Autentica → Cadastra → Notifica
cadastro = NotificadorDecorator.new(
  AutenticadorDecorator.new(
    ValidadorDecorator.new(
      CadastroPetSimples.new
    ),
    autenticado: true
  )
)
```

---

## 🐛 Debugging

### Ver Logs Detalhados

```bash
# Em desenvolvimento, os logs aparecem automaticamente
# Para ver apenas logs do Decorator:
tail -f log/development.log | grep -E "(Validação|Autenticação|Notificação)"
```

### Testar Cenário Específico

```ruby
# No console Rails
pet = Pet.new(name: "Test", species: "Dog", age: 3)

# Testar apenas validação
cadastro = ValidadorDecorator.new(CadastroPetSimples.new)
resultado = cadastro.cadastrar(pet)
puts resultado.inspect

# Testar sem autenticação
cadastro = AutenticadorDecorator.new(
  CadastroPetSimples.new,
  autenticado: false
)
resultado = cadastro.cadastrar(pet)
puts resultado.inspect
```

---

## 📚 Recursos Adicionais

### Documentação Completa

- **Padrão Decorator**: `docs/PadroesDeProjeto/DECORATOR_PATTERN.md`
- **Fluxo de Execução**: `docs/PadroesDeProjeto/DECORATOR_FLUXO.md`

### Arquivos de Código

- **Interface**: `app/services/cadastro_pet.rb`
- **Componente Base**: `app/services/cadastro_pet_simples.rb`
- **Decoradores**: `app/decorators/*_decorator.rb`
- **Controller**: `app/controllers/pets_controller.rb`

### Exemplos e Testes

- **Exemplos**: `lib/exemplos_decorator.rb`
- **Demo**: `script/demo_decorator.rb`
- **Testes**: `test/models/cadastro_pet_decorator_test.rb`

---

## ❓ FAQ

### Como desabilitar um decorador?

Simplesmente não o adicione à cadeia:

```ruby
# Sem validação
cadastro = NotificadorDecorator.new(
  AutenticadorDecorator.new(
    CadastroPetSimples.new,
    autenticado: true
  )
)
```

### Como usar apenas um decorador?

```ruby
# Apenas validação
cadastro = ValidadorDecorator.new(CadastroPetSimples.new)
```

### Como testar se a notificação foi enviada?

```ruby
resultado = cadastro.cadastrar(pet)

if resultado[:notificacao]
  puts "Notificação enviada via #{resultado[:notificacao][:canal]}"
else
  puts "Notificação não foi enviada"
end
```

### Como integrar com sistema de autenticação real?

No controller, substitua:

```ruby
# De:
autenticado = true
parceiro = "Parceiro Exemplo"

# Para (com Devise, por exemplo):
autenticado = user_signed_in?
parceiro = current_user.name
```

---

## 🎯 Próximos Passos

1. ✅ Execute os testes: `rails test`
2. ✅ Execute a demo: `ruby script/demo_decorator.rb`
3. ✅ Teste via web: acesse `http://localhost:3000/pets`
4. ✅ Leia a documentação completa em `docs/PadroesDeProjeto/`
5. ✅ Experimente criar seus próprios decoradores!

---

## 🆘 Ajuda

Se encontrar problemas:

1. Verifique se todas as gems estão instaladas: `bundle install`
2. Verifique se o banco está criado: `rails db:create db:migrate`
3. Execute os testes para verificar: `rails test`
4. Consulte os logs: `tail -f log/development.log`

---

**🎉 Divirta-se explorando o padrão Decorator!**
