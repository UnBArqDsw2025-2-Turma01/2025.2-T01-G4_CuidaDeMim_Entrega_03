# Fluxo de Execução do Padrão Decorator - CuidaDeMim

## 🔄 Diagrama de Sequência

```
Cliente                AutenticadorDecorator     ValidadorDecorator      CadastroPetSimples      NotificadorDecorator
   |                            |                        |                       |                         |
   |---- cadastrar(pet) ------->|                        |                       |                         |
   |                            |                        |                       |                         |
   |                    [Verifica autenticação]          |                       |                         |
   |                            |                        |                       |                         |
   |                            |---- cadastrar(pet) --->|                       |                         |
   |                            |                        |                       |                         |
   |                            |                [Valida dados do pet]           |                         |
   |                            |                        |                       |                         |
   |                            |                        |--- cadastrar(pet) --->|                         |
   |                            |                        |                       |                         |
   |                            |                        |                [Salva no banco]                  |
   |                            |                        |                       |                         |
   |                            |                        |                       |--- cadastrar(pet) ----->|
   |                            |                        |                       |                         |
   |                            |                        |                       |                  [Envia notificação]
   |                            |                        |                       |                         |
   |                            |                        |                       |<----- resultado --------|
   |                            |                        |<----- resultado ------|                         |
   |                            |<------ resultado ------|                       |                         |
   |<----- resultado -----------|                        |                       |                         |
   |                            |                        |                       |                         |
```

## 📊 Estrutura da Cadeia de Decoradores

```
┌─────────────────────────────────────────────────────────────┐
│                    Fluxo de Execução                        │
└─────────────────────────────────────────────────────────────┘

    PetsController
          │
          │ 1. Cria Pet via Factory
          │
          ▼
    ┌──────────────────────┐
    │ cadastrar_com_       │
    │ decorators(pet)      │
    └──────────────────────┘
          │
          │ 2. Constrói a cadeia
          │
          ▼
    ╔══════════════════════╗
    ║ AutenticadorDecorator║  ◄─── Camada Externa (executa primeiro)
    ╠══════════════════════╣
    ║ @autenticado = true  ║
    ║ @parceiro = "..."    ║
    ╚══════════════════════╝
          │ wraps
          ▼
    ┌──────────────────────┐
    │ ValidadorDecorator   │  ◄─── Camada Intermediária
    ├──────────────────────┤
    │ valida_pet(pet)      │
    └──────────────────────┘
          │ wraps
          ▼
    ┌──────────────────────┐
    │ NotificadorDecorator │  ◄─── Camada Intermediária
    ├──────────────────────┤
    │ @canal = 'email'     │
    └──────────────────────┘
          │ wraps
          ▼
    ╔══════════════════════╗
    ║ CadastroPetSimples   ║  ◄─── Componente Base (núcleo)
    ╠══════════════════════╣
    ║ pet.save             ║
    ╚══════════════════════╝
```

## 🎯 Ordem de Execução (Ida)

```
1️⃣  AutenticadorDecorator.cadastrar(pet)
    ├─ Verifica se @autenticado == true
    ├─ ✅ Se false: retorna { success: false, message: "Acesso negado" }
    └─ ✅ Se true: chama super(pet) → próximo decorador
        │
        ▼
2️⃣  ValidadorDecorator.cadastrar(pet)
    ├─ Valida nome, idade, espécie
    ├─ ✅ Se inválido: retorna { success: false, message: "Validação falhou" }
    └─ ✅ Se válido: chama super(pet) → próximo decorador
        │
        ▼
3️⃣  NotificadorDecorator.cadastrar(pet)
    └─ Chama super(pet) → componente base
        │
        ▼
4️⃣  CadastroPetSimples.cadastrar(pet)
    ├─ Executa pet.save
    └─ Retorna { success: true/false, message: "...", pet: pet }
```

## 🔙 Ordem de Retorno (Volta)

```
4️⃣  CadastroPetSimples
    └─ retorna { success: true, message: "Pet cadastrado", pet: pet }
        │
        ▼
3️⃣  NotificadorDecorator
    ├─ Recebe o resultado
    ├─ Se success == true → envia notificação
    ├─ Adiciona resultado[:notificacao] = { enviada: true, canal: 'email' }
    └─ retorna resultado atualizado
        │
        ▼
2️⃣  ValidadorDecorator
    └─ Apenas retorna o resultado recebido (validação já ocorreu na ida)
        │
        ▼
1️⃣  AutenticadorDecorator
    └─ Apenas retorna o resultado recebido (autenticação já ocorreu na ida)
        │
        ▼
    PetsController
    └─ Recebe resultado final e decide o que fazer (redirect ou render)
```

## 💡 Exemplo Prático - Cenário de Sucesso

```ruby
# Controller cria a cadeia
pet = Pet.new(name: "Rex", species: "Dog", age: 3)

cadastro = CadastroPetSimples.new
cadastro = NotificadorDecorator.new(cadastro, canal: 'email')
cadastro = ValidadorDecorator.new(cadastro)
cadastro = AutenticadorDecorator.new(cadastro, autenticado: true, parceiro: "ONG ABC")

resultado = cadastro.cadastrar(pet)
```

### Passo a Passo:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. AutenticadorDecorator                                    │
│    ✅ Verifica: @autenticado == true                        │
│    📝 Log: "Parceiro autenticado (ONG ABC)"                 │
│    ➡️  Continua para o próximo decorador                    │
└─────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. ValidadorDecorator                                       │
│    ✅ Valida: nome = "Rex" (OK)                             │
│    ✅ Valida: age = 3 (OK)                                  │
│    ✅ Valida: species = "Dog" (OK)                          │
│    📝 Log: "Validação bem-sucedida"                         │
│    ➡️  Continua para o próximo decorador                    │
└─────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. NotificadorDecorator                                     │
│    ➡️  Passa para o componente base                         │
└─────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. CadastroPetSimples                                       │
│    💾 Executa: pet.save                                     │
│    ✅ Sucesso: Pet salvo no banco de dados                  │
│    ↩️  Retorna: { success: true, message: "...", pet: pet } │
└─────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. NotificadorDecorator (volta)                             │
│    ✅ Verifica: resultado[:success] == true                 │
│    📧 Envia notificação via email                           │
│    📝 Log: "NOTIFICAÇÃO enviada"                            │
│    ➕ Adiciona: resultado[:notificacao] = {...}             │
│    ↩️  Retorna resultado atualizado                         │
└─────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. ValidadorDecorator (volta)                               │
│    ↩️  Retorna resultado sem alterações                     │
└─────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│ 1. AutenticadorDecorator (volta)                            │
│    ↩️  Retorna resultado sem alterações                     │
└─────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│ Resultado Final:                                            │
│ {                                                           │
│   success: true,                                            │
│   message: "Pet 'Rex' cadastrado com sucesso!",            │
│   pet: #<Pet id:1, name:"Rex", ...>,                       │
│   notificacao: {                                            │
│     enviada: true,                                          │
│     canal: 'email',                                         │
│     mensagem: "Notificação enviada..."                     │
│   }                                                         │
│ }                                                           │
└─────────────────────────────────────────────────────────────┘
```

## ⚠️ Exemplo Prático - Cenário de Falha (Não Autenticado)

```ruby
cadastro = AutenticadorDecorator.new(
  ValidadorDecorator.new(
    CadastroPetSimples.new
  ),
  autenticado: false  # ❌ NÃO AUTENTICADO
)

resultado = cadastro.cadastrar(pet)
```

### Passo a Passo:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. AutenticadorDecorator                                    │
│    ❌ Verifica: @autenticado == false                       │
│    🚫 Bloqueia o cadastro                                   │
│    📝 Log: "Acesso negado! Parceiro não autenticado"        │
│    ↩️  Retorna imediatamente:                               │
│       { success: false, message: "Acesso negado!", ... }   │
│                                                             │
│    🚫 NÃO EXECUTA os decoradores seguintes                  │
│    🚫 NÃO CHAMA super(pet)                                  │
└─────────────────────────────────────────────────────────────┘
         │
         ▼ (Interrompido aqui!)
         
    ValidadorDecorator        ← Nunca executado
         │
    CadastroPetSimples        ← Nunca executado
         │
    (Pet não é salvo)
```

## 📈 Comparação: Com vs Sem Decorator

### ❌ Sem Decorator (Código Acoplado)

```ruby
def create
  @pet = Pet.new(pet_params)
  
  # Tudo em um único método - difícil de manter!
  unless autenticado?
    return render :new, alert: "Acesso negado"
  end
  
  if @pet.name.blank? || @pet.age.nil?
    return render :new, alert: "Dados inválidos"
  end
  
  if @pet.save
    enviar_notificacao(@pet)  # Acoplado
    redirect_to @pet, notice: "Sucesso"
  else
    render :new
  end
end
```

**Problemas**:
- ❌ Código acoplado e difícil de testar
- ❌ Difícil adicionar/remover comportamentos
- ❌ Violação do Single Responsibility Principle
- ❌ Difícil de reutilizar em outros contextos

### ✅ Com Decorator (Código Desacoplado)

```ruby
def create
  @pet = Pet.new(pet_params)
  resultado = cadastrar_com_decorators(@pet)
  
  if resultado[:success]
    redirect_to @pet, notice: resultado[:message]
  else
    render :new, alert: resultado[:message]
  end
end

def cadastrar_com_decorators(pet)
  cadastro = CadastroPetSimples.new
  cadastro = NotificadorDecorator.new(cadastro)
  cadastro = ValidadorDecorator.new(cadastro)
  cadastro = AutenticadorDecorator.new(cadastro, autenticado: true)
  cadastro.cadastrar(pet)
end
```

**Vantagens**:
- ✅ Cada decorador tem uma responsabilidade única
- ✅ Fácil testar cada componente isoladamente
- ✅ Fácil adicionar/remover comportamentos
- ✅ Decoradores podem ser reutilizados em outros contextos
- ✅ Ordem pode ser facilmente alterada

## 🎓 Conceitos-Chave para Iniciantes

### 1. Wrapping (Encapsulamento)

Cada decorador "envolve" o componente anterior:

```
AutenticadorDecorator(
  ValidadorDecorator(
    NotificadorDecorator(
      CadastroPetSimples()
    )
  )
)
```

### 2. Delegação via `super`

```ruby
class MeuDecorator < CadastroPetDecorator
  def cadastrar(pet)
    puts "Antes"
    resultado = super(pet)  # Chama o próximo na cadeia
    puts "Depois"
    resultado
  end
end
```

### 3. Interrupção da Cadeia

Se um decorador retorna sem chamar `super`, a cadeia é interrompida:

```ruby
def cadastrar(pet)
  return { success: false, message: "Bloqueado!" } unless valido?
  super(pet)  # Só chama se válido
end
```

---

## 🔗 Integração com o Projeto Rails

```
HTTP Request
     ↓
routes.rb → define rota POST /pets
     ↓
PetsController#create
     ↓
PetFactory.create(params) → Padrão Factory (criacional)
     ↓
cadastrar_com_decorators(pet) → Padrão Decorator (estrutural)
     ↓
Cadeia de Decoradores
     ↓
Resultado → redirect ou render
```

---

**📌 Dica**: Para entender melhor, execute os exemplos em `lib/exemplos_decorator.rb` e observe os logs!
