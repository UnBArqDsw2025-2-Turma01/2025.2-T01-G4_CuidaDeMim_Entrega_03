# Padrão Decorator - Cadastro de Pets

## 📋 Visão Geral

Este documento descreve a implementação do **padrão de projeto estrutural Decorator (GoF)** aplicado ao cadastro de pets na plataforma **CuidaDeMim**.

O padrão Decorator permite adicionar responsabilidades adicionais a um objeto dinamicamente, de forma flexível e encadeável, sem modificar a estrutura original da classe.

---

## 🎯 Objetivo

Permitir que o cadastro de pets seja estendido com diferentes comportamentos (validação, autenticação, notificação) de forma:

- **Flexível**: Decoradores podem ser combinados em qualquer ordem
- **Reutilizável**: Cada decorador tem uma responsabilidade única
- **Extensível**: Novos decoradores podem ser adicionados sem alterar código existente
- **Manutenível**: Respeita o princípio Open/Closed (aberto para extensão, fechado para modificação)

---

## 🏗️ Arquitetura

### Estrutura de Classes

```
CadastroPet (Interface)
    │
    ├── CadastroPetSimples (ConcreteComponent)
    │
    └── CadastroPetDecorator (Decorator Base)
            │
            ├── ValidadorDecorator
            ├── AutenticadorDecorator
            └── NotificadorDecorator
```

### Diagrama UML

```
┌─────────────────────┐
│   <<interface>>     │
│    CadastroPet      │
├─────────────────────┤
│ + cadastrar(pet)    │
└─────────────────────┘
          △
          │ implements
          │
    ┌─────┴──────────────────────────┐
    │                                │
┌───┴──────────────────┐  ┌─────────┴────────────────┐
│ CadastroPetSimples   │  │ CadastroPetDecorator     │
├──────────────────────┤  ├──────────────────────────┤
│ + cadastrar(pet)     │  │ - componente             │
└──────────────────────┘  │ + cadastrar(pet)         │
                          └──────────────────────────┘
                                     △
                                     │ extends
                ┌────────────────────┼────────────────────┐
                │                    │                    │
    ┌───────────┴─────────┐  ┌──────┴──────────┐  ┌─────┴──────────┐
    │ ValidadorDecorator  │  │ AutenticadorDec │  │ NotificadorDec │
    ├─────────────────────┤  ├─────────────────┤  ├────────────────┤
    │ + cadastrar(pet)    │  │ - autenticado   │  │ - canal        │
    └─────────────────────┘  │ + cadastrar(pet)│  │ + cadastrar()  │
                             └─────────────────┘  └────────────────┘
```

---

## 📁 Estrutura de Arquivos

```
app/
├── services/
│   ├── cadastro_pet.rb              # Interface base
│   └── cadastro_pet_simples.rb      # Componente concreto
├── decorators/
│   ├── cadastro_pet_decorator.rb    # Decorador base
│   ├── validador_decorator.rb       # Decorador de validação
│   ├── autenticador_decorator.rb    # Decorador de autenticação
│   └── notificador_decorator.rb     # Decorador de notificação
└── controllers/
    └── pets_controller.rb           # Usa a cadeia de decoradores

lib/
└── exemplos_decorator.rb            # Exemplos de uso

test/
└── models/
    └── cadastro_pet_decorator_test.rb # Testes unitários
```

---

## 🔧 Componentes

### 1. Interface Base: `CadastroPet`

**Arquivo**: `app/services/cadastro_pet.rb`

Define o contrato que todos os componentes devem seguir.

```ruby
module CadastroPet
  def cadastrar(pet)
    raise NotImplementedError
  end
end
```

### 2. Componente Concreto: `CadastroPetSimples`

**Arquivo**: `app/services/cadastro_pet_simples.rb`

Implementação básica do cadastro, apenas salva o pet no banco de dados.

**Responsabilidade**: Cadastro simples sem lógica adicional.

```ruby
class CadastroPetSimples
  include CadastroPet

  def cadastrar(pet)
    if pet.save
      { success: true, message: "Pet cadastrado com sucesso!", pet: pet }
    else
      { success: false, message: "Erro ao cadastrar", pet: pet }
    end
  end
end
```

### 3. Decorador Base: `CadastroPetDecorator`

**Arquivo**: `app/decorators/cadastro_pet_decorator.rb`

Classe abstrata que mantém referência ao componente decorado e delega chamadas.

```ruby
class CadastroPetDecorator
  include CadastroPet

  def initialize(componente)
    @componente = componente
  end

  def cadastrar(pet)
    @componente.cadastrar(pet)
  end
end
```

### 4. Decorador Concreto: `ValidadorDecorator`

**Arquivo**: `app/decorators/validador_decorator.rb`

**Responsabilidade**: Validar dados do pet antes do cadastro.

**Validações**:
- Nome não pode estar vazio
- Idade deve ser informada e positiva
- Idade não pode ser maior que 30 anos
- Espécie deve ser informada

```ruby
class ValidadorDecorator < CadastroPetDecorator
  def cadastrar(pet)
    # Valida antes de delegar
    resultado_validacao = validar_pet(pet)
    
    return { success: false, message: "Validação falhou..." } unless resultado_validacao[:valido]
    
    super(pet) # Delega para o próximo componente
  end
end
```

### 5. Decorador Concreto: `AutenticadorDecorator`

**Arquivo**: `app/decorators/autenticador_decorator.rb`

**Responsabilidade**: Verificar se o parceiro está autenticado.

**Parâmetros**:
- `autenticado` (Boolean): Status de autenticação
- `parceiro` (String, opcional): Nome do parceiro

```ruby
class AutenticadorDecorator < CadastroPetDecorator
  def initialize(componente, autenticado:, parceiro: nil)
    super(componente)
    @autenticado = autenticado
    @parceiro = parceiro
  end

  def cadastrar(pet)
    return { success: false, message: "Acesso negado!" } unless @autenticado
    
    super(pet)
  end
end
```

### 6. Decorador Concreto: `NotificadorDecorator`

**Arquivo**: `app/decorators/notificador_decorator.rb`

**Responsabilidade**: Enviar notificação após cadastro bem-sucedido.

**Parâmetros**:
- `canal` (String): Canal de notificação (email, sms, push)

```ruby
class NotificadorDecorator < CadastroPetDecorator
  def initialize(componente, canal: 'email')
    super(componente)
    @canal = canal
  end

  def cadastrar(pet)
    resultado = super(pet) # Primeiro cadastra
    
    if resultado[:success]
      notificar(pet) # Depois notifica
      resultado[:notificacao] = { enviada: true, canal: @canal }
    end
    
    resultado
  end
end
```

---

## 💡 Exemplos de Uso

### Exemplo 1: Cadastro Simples

```ruby
pet = Pet.new(name: "Rex", species: "Dog", age: 3)
cadastro = CadastroPetSimples.new
resultado = cadastro.cadastrar(pet)
```

### Exemplo 2: Cadastro com Validação

```ruby
pet = Pet.new(name: "Luna", species: "Cat", age: 2)
cadastro = CadastroPetSimples.new
cadastro = ValidadorDecorator.new(cadastro)
resultado = cadastro.cadastrar(pet)
```

### Exemplo 3: Cadeia Completa de Decoradores

```ruby
pet = Pet.new(name: "Thor", species: "Dog", age: 5)

# Constrói a cadeia (de dentro para fora)
cadastro = CadastroPetSimples.new
cadastro = NotificadorDecorator.new(cadastro, canal: 'email')
cadastro = ValidadorDecorator.new(cadastro)
cadastro = AutenticadorDecorator.new(cadastro, autenticado: true, parceiro: "ONG XYZ")

# Executa a cadeia
resultado = cadastro.cadastrar(pet)
```

**Fluxo de execução**:
1. ✅ **Autenticador**: Verifica se está autenticado
2. ✅ **Validador**: Valida os dados do pet
3. ✅ **Cadastro**: Salva o pet no banco
4. ✅ **Notificador**: Envia notificação de sucesso

### Exemplo 4: Diferentes Combinações

```ruby
# Apenas validação + notificação
cadastro = NotificadorDecorator.new(
  ValidadorDecorator.new(
    CadastroPetSimples.new
  )
)

# Apenas autenticação
cadastro = AutenticadorDecorator.new(
  CadastroPetSimples.new,
  autenticado: true
)
```

---

## 🚀 Como Usar no Projeto

### No Controller

O `PetsController` já está configurado para usar a cadeia de decoradores:

```ruby
# app/controllers/pets_controller.rb
def create
  @pet = PetFactory.create(pet_params)
  resultado = cadastrar_com_decorators(@pet)
  
  if resultado[:success]
    redirect_to pet_url(@pet), notice: resultado[:message]
  else
    render :new, alert: resultado[:message]
  end
end

private

def cadastrar_com_decorators(pet)
  cadastro = CadastroPetSimples.new
  cadastro = NotificadorDecorator.new(cadastro, canal: 'email')
  cadastro = ValidadorDecorator.new(cadastro)
  cadastro = AutenticadorDecorator.new(cadastro, autenticado: true, parceiro: "Parceiro XYZ")
  
  cadastro.cadastrar(pet)
end
```

### Executando Exemplos

```bash
# Console Rails
rails console
load 'lib/exemplos_decorator.rb'

# Ou via runner
rails runner lib/exemplos_decorator.rb
```

### Executando Testes

```bash
# Todos os testes
rails test

# Apenas testes do Decorator
rails test test/models/cadastro_pet_decorator_test.rb
```

---

## ✅ Vantagens do Padrão Decorator

1. **Flexibilidade**: Comportamentos podem ser adicionados/removidos dinamicamente
2. **Single Responsibility**: Cada decorador tem uma responsabilidade única
3. **Open/Closed Principle**: Extensível sem modificar código existente
4. **Composição sobre Herança**: Evita hierarquias complexas de classes
5. **Reutilização**: Decoradores podem ser reutilizados em diferentes contextos

---

## 🎓 Conceitos para Iniciantes (Ruby/Rails)

### O que é um Módulo (Module)?

Em Ruby, um módulo é como uma "interface" em outras linguagens. Define métodos que classes podem incluir.

```ruby
module CadastroPet
  def cadastrar(pet)
    # Define o contrato
  end
end

class MinhaClasse
  include CadastroPet # "Implementa" a interface
end
```

### O que é `super`?

`super` chama o método da classe pai (ou do componente decorado):

```ruby
class Decorador < Base
  def cadastrar(pet)
    puts "Antes"
    super(pet)     # Chama Base.cadastrar(pet)
    puts "Depois"
  end
end
```

### O que é `@componente`?

É uma variável de instância que armazena o objeto decorado:

```ruby
def initialize(componente)
  @componente = componente  # Guarda referência
end

def cadastrar(pet)
  @componente.cadastrar(pet)  # Usa a referência
end
```

---

## 🔍 Diferenças entre Decorator e outros padrões

### Decorator vs Strategy

- **Decorator**: Adiciona comportamentos encadeáveis
- **Strategy**: Alterna entre algoritmos diferentes

### Decorator vs Proxy

- **Decorator**: Adiciona funcionalidades
- **Proxy**: Controla acesso ao objeto original

### Decorator vs Composite

- **Decorator**: Adiciona responsabilidades
- **Composite**: Trata objetos individuais e composições uniformemente

---

## 📚 Referências

- **Design Patterns: Elements of Reusable Object-Oriented Software** (GoF)
- [Refactoring.Guru - Decorator Pattern](https://refactoring.guru/design-patterns/decorator)
- [Ruby Design Patterns](https://github.com/nslocum/design-patterns-in-ruby)

---

## 🤝 Contribuindo

Para adicionar novos decoradores:

1. Crie uma nova classe que herda de `CadastroPetDecorator`
2. Sobrescreva o método `cadastrar(pet)`
3. Use `super(pet)` para delegar ao próximo componente
4. Adicione testes em `test/models/cadastro_pet_decorator_test.rb`

**Exemplo de novo decorador**:

```ruby
class LoggerDecorator < CadastroPetDecorator
  def cadastrar(pet)
    Rails.logger.info("Iniciando cadastro de #{pet.name}")
    resultado = super(pet)
    Rails.logger.info("Cadastro finalizado: #{resultado[:success]}")
    resultado
  end
end
```

---

## 📞 Suporte

Para dúvidas ou sugestões sobre a implementação do Decorator, abra uma issue no repositório.
