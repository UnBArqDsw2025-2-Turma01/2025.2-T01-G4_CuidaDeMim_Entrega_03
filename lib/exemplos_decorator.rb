# frozen_string_literal: true

# Exemplo de uso do padrão Decorator para cadastro de pets
# Este arquivo demonstra como usar os decoradores de forma flexível e encadeável
#
# Execute no console Rails: rails runner lib/exemplos_decorator.rb
# Ou no console Rails interativo: rails console
# Depois: load 'lib/exemplos_decorator.rb'

puts "\n" + "=" * 80
puts "DEMONSTRAÇÃO DO PADRÃO DECORATOR - CuidaDeMim"
puts "=" * 80 + "\n"

# ==============================================================================
# EXEMPLO 1: Cadastro Simples (sem decoradores)
# ==============================================================================
puts "\n📌 EXEMPLO 1: Cadastro Simples (Sem Decoradores)\n"
puts "-" * 80

pet1 = Pet.new(
  name: "Rex",
  species: "Dog",
  age: 3,
  description: "Cachorro amigável",
  adopted: false
)

cadastro_simples = CadastroPetSimples.new
resultado1 = cadastro_simples.cadastrar(pet1)

puts "✅ Resultado: #{resultado1[:message]}"
Pet.last&.destroy # Limpa o banco

# ==============================================================================
# EXEMPLO 2: Cadastro com Validação
# ==============================================================================
puts "\n📌 EXEMPLO 2: Cadastro com Validação\n"
puts "-" * 80

# Pet válido
pet2_valido = Pet.new(
  name: "Luna",
  species: "Cat",
  age: 2,
  description: "Gata carinhosa"
)

cadastro = CadastroPetSimples.new
cadastro_com_validacao = ValidadorDecorator.new(cadastro)
resultado2 = cadastro_com_validacao.cadastrar(pet2_valido)

puts "✅ Pet válido - Resultado: #{resultado2[:message]}"
Pet.last&.destroy

# Pet inválido (sem nome)
pet2_invalido = Pet.new(
  name: "",
  species: "Cat",
  age: 2
)

resultado3 = cadastro_com_validacao.cadastrar(pet2_invalido)
puts "❌ Pet inválido - Resultado: #{resultado3[:message]}"

# ==============================================================================
# EXEMPLO 3: Cadastro com Autenticação
# ==============================================================================
puts "\n📌 EXEMPLO 3: Cadastro com Autenticação\n"
puts "-" * 80

pet3 = Pet.new(
  name: "Thor",
  species: "Dog",
  age: 5,
  description: "Pastor alemão protetor"
)

cadastro = CadastroPetSimples.new

# Parceiro autenticado
cadastro_autenticado = AutenticadorDecorator.new(
  cadastro,
  autenticado: true,
  parceiro: "ONG Patinhas Felizes"
)
resultado4 = cadastro_autenticado.cadastrar(pet3)
puts "✅ Autenticado - Resultado: #{resultado4[:message]}"
Pet.last&.destroy

# Parceiro NÃO autenticado
cadastro_nao_autenticado = AutenticadorDecorator.new(
  cadastro,
  autenticado: false,
  parceiro: "Usuário Desconhecido"
)
resultado5 = cadastro_nao_autenticado.cadastrar(pet3)
puts "❌ Não autenticado - Resultado: #{resultado5[:message]}"

# ==============================================================================
# EXEMPLO 4: Cadastro com Notificação
# ==============================================================================
puts "\n📌 EXEMPLO 4: Cadastro com Notificação\n"
puts "-" * 80

pet4 = Pet.new(
  name: "Mel",
  species: "Dog",
  age: 1,
  description: "Filhote de golden retriever"
)

cadastro = CadastroPetSimples.new
cadastro_com_notificacao = NotificadorDecorator.new(cadastro, canal: 'email')
resultado6 = cadastro_com_notificacao.cadastrar(pet4)

puts "✅ Resultado: #{resultado6[:message]}"
puts "📧 Notificação: #{resultado6[:notificacao][:mensagem]}"
Pet.last&.destroy

# ==============================================================================
# EXEMPLO 5: Cadeia Completa de Decoradores
# ==============================================================================
puts "\n📌 EXEMPLO 5: Cadeia Completa de Decoradores\n"
puts "-" * 80
puts "Ordem: Autenticação → Validação → Cadastro → Notificação\n\n"

pet5 = Pet.new(
  name: "Bolt",
  species: "Dog",
  age: 4,
  description: "Border collie inteligente e ativo"
)

# Constrói a cadeia de decoradores
cadastro = CadastroPetSimples.new
cadastro = NotificadorDecorator.new(cadastro, canal: 'sms')
cadastro = ValidadorDecorator.new(cadastro)
cadastro = AutenticadorDecorator.new(
  cadastro,
  autenticado: true,
  parceiro: "Empresa Pet Shop XYZ"
)

resultado7 = cadastro.cadastrar(pet5)

puts "✅ Resultado final: #{resultado7[:message]}"
if resultado7[:notificacao]
  puts "📱 Notificação: #{resultado7[:notificacao][:mensagem]}"
end
Pet.last&.destroy

# ==============================================================================
# EXEMPLO 6: Testando Falhas na Cadeia
# ==============================================================================
puts "\n📌 EXEMPLO 6: Testando Falhas na Cadeia\n"
puts "-" * 80

# Pet com idade inválida
pet6_invalido = Pet.new(
  name: "Max",
  species: "Dog",
  age: -1, # Idade negativa!
  description: "Teste de validação"
)

cadastro = CadastroPetSimples.new
cadastro = NotificadorDecorator.new(cadastro, canal: 'push')
cadastro = ValidadorDecorator.new(cadastro)
cadastro = AutenticadorDecorator.new(cadastro, autenticado: true)

resultado8 = cadastro.cadastrar(pet6_invalido)

puts "❌ Pet com idade inválida - Resultado: #{resultado8[:message]}"
puts "ℹ️  Notificação enviada? #{resultado8[:notificacao].present? ? 'Sim' : 'Não (cadastro falhou)'}"

# ==============================================================================
# EXEMPLO 7: Flexibilidade do Decorator - Diferentes Combinações
# ==============================================================================
puts "\n📌 EXEMPLO 7: Flexibilidade - Diferentes Combinações\n"
puts "-" * 80

pet7 = Pet.new(
  name: "Nina",
  species: "Cat",
  age: 3,
  description: "Gata persa elegante"
)

# Combinação 1: Apenas validação + notificação (sem autenticação)
cadastro_combo1 = CadastroPetSimples.new
cadastro_combo1 = NotificadorDecorator.new(cadastro_combo1, canal: 'email')
cadastro_combo1 = ValidadorDecorator.new(cadastro_combo1)

puts "\nCombo 1: Validação + Notificação"
resultado9 = cadastro_combo1.cadastrar(pet7)
puts "✅ #{resultado9[:message]}"
Pet.last&.destroy

# Combinação 2: Apenas autenticação + notificação (sem validação)
cadastro_combo2 = CadastroPetSimples.new
cadastro_combo2 = NotificadorDecorator.new(cadastro_combo2, canal: 'push')
cadastro_combo2 = AutenticadorDecorator.new(cadastro_combo2, autenticado: true)

puts "\nCombo 2: Autenticação + Notificação"
resultado10 = cadastro_combo2.cadastrar(pet7)
puts "✅ #{resultado10[:message]}"
Pet.last&.destroy

puts "\n" + "=" * 80
puts "🎉 Demonstração concluída!"
puts "=" * 80 + "\n"
