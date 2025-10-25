#!/usr/bin/env ruby
# frozen_string_literal: true

# Script de demonstração rápida do padrão Decorator
# Execute: ruby script/demo_decorator.rb

require_relative '../config/environment'

puts "\n"
puts "╔═══════════════════════════════════════════════════════════════╗"
puts "║                                                               ║"
puts "║         🐾 CuidaDeMim - Demonstração do Decorator 🐾         ║"
puts "║                                                               ║"
puts "╚═══════════════════════════════════════════════════════════════╝"
puts "\n"

# Limpa banco para demonstração limpa
Pet.destroy_all

# ==============================================================================
# DEMONSTRAÇÃO 1: Componente Base Simples
# ==============================================================================

puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "🔹 Demo 1: Cadastro Simples (Sem Decoradores)"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

pet1 = Pet.new(name: "Rex", species: "Dog", age: 3, description: "Labrador amigável")
cadastro_simples = CadastroPetSimples.new

puts "\n📝 Criando pet: #{pet1.name} (#{pet1.species}, #{pet1.age} anos)"
resultado1 = cadastro_simples.cadastrar(pet1)

if resultado1[:success]
  puts "✅ #{resultado1[:message]}"
else
  puts "❌ #{resultado1[:message]}"
end

Pet.destroy_all
sleep 1

# ==============================================================================
# DEMONSTRAÇÃO 2: Com Validação
# ==============================================================================

puts "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "🔹 Demo 2: Cadastro com Validação"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Pet válido
pet2_valido = Pet.new(name: "Luna", species: "Cat", age: 2, description: "Gata siamesa")
cadastro = ValidadorDecorator.new(CadastroPetSimples.new)

puts "\n📝 Tentando cadastrar: #{pet2_valido.name} (válido)"
resultado2 = cadastro.cadastrar(pet2_valido)
puts "✅ #{resultado2[:message]}" if resultado2[:success]

Pet.destroy_all

# Pet inválido
pet2_invalido = Pet.new(name: "", species: "Cat", age: -1)
puts "\n📝 Tentando cadastrar: pet sem nome e idade negativa (inválido)"
resultado3 = cadastro.cadastrar(pet2_invalido)
puts "❌ #{resultado3[:message]}" unless resultado3[:success]

sleep 1

# ==============================================================================
# DEMONSTRAÇÃO 3: Com Autenticação
# ==============================================================================

puts "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "🔹 Demo 3: Cadastro com Autenticação"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

pet3 = Pet.new(name: "Thor", species: "Dog", age: 5, description: "Pastor alemão")

# Autenticado
cadastro_auth = AutenticadorDecorator.new(
  CadastroPetSimples.new,
  autenticado: true,
  parceiro: "ONG Patinhas Felizes"
)

puts "\n📝 Cadastrando como ONG Patinhas Felizes (autenticado)"
resultado4 = cadastro_auth.cadastrar(pet3)
puts "✅ #{resultado4[:message]}" if resultado4[:success]

Pet.destroy_all

# Não autenticado
cadastro_no_auth = AutenticadorDecorator.new(
  CadastroPetSimples.new,
  autenticado: false,
  parceiro: "Usuário Desconhecido"
)

puts "\n📝 Tentando cadastrar como usuário desconhecido (não autenticado)"
resultado5 = cadastro_no_auth.cadastrar(pet3)
puts "🚫 #{resultado5[:message]}" unless resultado5[:success]

sleep 1

# ==============================================================================
# DEMONSTRAÇÃO 4: Cadeia Completa
# ==============================================================================

puts "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "🔹 Demo 4: Cadeia Completa de Decoradores"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "📋 Ordem: Autenticação → Validação → Cadastro → Notificação"

pet4 = Pet.new(
  name: "Bolt",
  species: "Dog",
  age: 4,
  description: "Border Collie inteligente"
)

# Constrói a cadeia
cadastro = CadastroPetSimples.new
cadastro = NotificadorDecorator.new(cadastro, canal: 'email')
cadastro = ValidadorDecorator.new(cadastro)
cadastro = AutenticadorDecorator.new(
  cadastro,
  autenticado: true,
  parceiro: "Pet Shop XYZ"
)

puts "\n📝 Cadastrando: #{pet4.name} via cadeia completa"
puts "   ├─ 1️⃣  Verificando autenticação..."
puts "   ├─ 2️⃣  Validando dados..."
puts "   ├─ 3️⃣  Salvando no banco..."
puts "   └─ 4️⃣  Enviando notificação..."

resultado6 = cadastro.cadastrar(pet4)

if resultado6[:success]
  puts "\n✅ #{resultado6[:message]}"
  if resultado6[:notificacao]
    puts "📧 #{resultado6[:notificacao][:mensagem]}"
  end
else
  puts "\n❌ #{resultado6[:message]}"
end

sleep 1

# ==============================================================================
# DEMONSTRAÇÃO 5: Falha na Cadeia
# ==============================================================================

puts "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "🔹 Demo 5: Testando Falha na Cadeia"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

pet5 = Pet.new(name: "Max", species: "Dog", age: -5) # Idade inválida!

cadastro_fail = CadastroPetSimples.new
cadastro_fail = NotificadorDecorator.new(cadastro_fail, canal: 'sms')
cadastro_fail = ValidadorDecorator.new(cadastro_fail)
cadastro_fail = AutenticadorDecorator.new(cadastro_fail, autenticado: true)

puts "\n📝 Tentando cadastrar pet com idade inválida (-5 anos)"
puts "   ├─ 1️⃣  Verificando autenticação... ✅"
puts "   ├─ 2️⃣  Validando dados... ❌ (FALHOU)"
puts "   └─ 🚫 Cadastro e notificação não serão executados"

resultado7 = cadastro_fail.cadastrar(pet5)

puts "\n❌ #{resultado7[:message]}"
puts "ℹ️  Notificação enviada? #{resultado7[:notificacao] ? 'Sim' : 'Não (cadastro falhou)'}"

sleep 1

# ==============================================================================
# DEMONSTRAÇÃO 6: Flexibilidade
# ==============================================================================

puts "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "🔹 Demo 6: Flexibilidade - Diferentes Combinações"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

pet6 = Pet.new(name: "Nina", species: "Cat", age: 3, description: "Gata persa")

# Combinação 1: Apenas Validação
puts "\n🔸 Combo 1: Apenas Validação"
combo1 = ValidadorDecorator.new(CadastroPetSimples.new)
resultado8 = combo1.cadastrar(pet6)
puts "✅ #{resultado8[:message]}" if resultado8[:success]

Pet.destroy_all

# Combinação 2: Validação + Notificação (sem autenticação)
puts "\n🔸 Combo 2: Validação + Notificação"
combo2 = NotificadorDecorator.new(
  ValidadorDecorator.new(CadastroPetSimples.new),
  canal: 'push'
)
resultado9 = combo2.cadastrar(pet6)
if resultado9[:success]
  puts "✅ #{resultado9[:message]}"
  puts "📱 Notificação via #{resultado9[:notificacao][:canal]}"
end

Pet.destroy_all

# Combinação 3: Apenas Notificação
puts "\n🔸 Combo 3: Apenas Notificação"
combo3 = NotificadorDecorator.new(CadastroPetSimples.new, canal: 'email')
resultado10 = combo3.cadastrar(pet6)
if resultado10[:success]
  puts "✅ #{resultado10[:message]}"
  puts "📧 #{resultado10[:notificacao][:mensagem]}"
end

# ==============================================================================
# DEMONSTRAÇÃO 7: Com Formatação
# ==============================================================================

puts "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "🔹 Demo 7: Cadastro com Formatação"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Pet com dados não formatados
pet7 = Pet.new(name: "  fido  ", species: "  DOG  ", age: 4, description: "  um cãozinho brincalhão  ")
cadastro = FormatadorDecorator.new(CadastroPetSimples.new)

puts "\n📝 Tentando cadastrar: #{pet7.name} (não formatado)"
resultado11 = cadastro.cadastrar(pet7)
puts "✅ #{resultado11[:message]}" if resultado11[:success]
puts "Pet formatado: #{resultado11[:pet].name}, #{resultado11[:pet].species}, #{resultado11[:pet].description}"

Pet.destroy_all

# ==============================================================================
# RESUMO
# ==============================================================================


puts "\n"
puts "╔═══════════════════════════════════════════════════════════════╗"
puts "║                          RESUMO                               ║"
puts "╠═══════════════════════════════════════════════════════════════╣"
puts "║                                                               ║"
puts "║  ✅ Padrão Decorator implementado com sucesso!                ║"
puts "║                                                               ║"
puts "║  📦 Componentes criados:                                      ║"
puts "║     • CadastroPet (Interface)                                ║"
puts "║     • CadastroPetSimples (Componente Concreto)               ║"
puts "║     • CadastroPetDecorator (Decorador Base)                  ║"
puts "║     • ValidadorDecorator                                     ║"
puts "║     • AutenticadorDecorator                                  ║"
puts "║     • NotificadorDecorator                                   ║"
puts "║     • FormatadorDecorator                                    ║"
puts "║                                                               ║"
puts "║  🎯 Vantagens demonstradas:                                   ║"
puts "║     • Flexibilidade na composição                            ║"
puts "║     • Responsabilidade única                                 ║"
puts "║     • Fácil extensão e manutenção                           ║"
puts "║     • Reutilização de componentes                           ║"
puts "║                                                               ║"
puts "║  📚 Documentação disponível em:                               ║"
puts "║     docs/PadroesDeProjeto/DECORATOR_PATTERN.md               ║"
puts "║     docs/PadroesDeProjeto/DECORATOR_FLUXO.md                 ║"
puts "║                                                               ║"
puts "║  🧪 Execute os testes:                                        ║"
puts "║     rails test test/models/cadastro_pet_decorator_test.rb    ║"
puts "║                                                               ║"
puts "╚═══════════════════════════════════════════════════════════════╝"
puts "\n"

puts "🎉 Demonstração concluída!\n\n"
