# frozen_string_literal: true

require "test_helper"

class CadastroPetDecoratorTest < ActiveSupport::TestCase
  # ==============================================================================
  # Testes do Componente Base: CadastroPetSimples
  # ==============================================================================

  test "cadastro simples deve salvar pet válido" do
    pet = Pet.new(name: "Rex", species: "Dog", age: 3)
    cadastro = CadastroPetSimples.new

    resultado = cadastro.cadastrar(pet)

    assert resultado[:success], "O cadastro deveria ter sucesso"
    assert_includes resultado[:message], "cadastrado com sucesso"
    assert pet.persisted?, "Pet deveria estar salvo no banco"
  end

  test "cadastro simples deve falhar com pet inválido" do
    pet = Pet.new(name: "", species: "") # Nome e espécie obrigatórios
    cadastro = CadastroPetSimples.new

    resultado = cadastro.cadastrar(pet)

    assert_not resultado[:success], "O cadastro não deveria ter sucesso"
    assert_includes resultado[:message], "Erro ao cadastrar pet"
  end

  # ==============================================================================
  # Testes do ValidadorDecorator
  # ==============================================================================

  test "validador deve permitir pet com dados válidos" do
    pet = Pet.new(name: "Luna", species: "Cat", age: 2)
    cadastro = CadastroPetSimples.new
    cadastro_validado = ValidadorDecorator.new(cadastro)

    resultado = cadastro_validado.cadastrar(pet)

    assert resultado[:success], "Validação deveria passar para pet válido"
    assert pet.persisted?
  end

  test "validador deve bloquear pet sem nome" do
    pet = Pet.new(name: "", species: "Dog", age: 3)
    cadastro = CadastroPetSimples.new
    cadastro_validado = ValidadorDecorator.new(cadastro)

    resultado = cadastro_validado.cadastrar(pet)

    assert_not resultado[:success], "Validação deveria falhar sem nome"
    assert_includes resultado[:message], "Nome do pet não pode estar vazio"
    assert_not pet.persisted?, "Pet não deveria ser salvo"
  end

  test "validador deve bloquear pet sem idade" do
    pet = Pet.new(name: "Thor", species: "Dog", age: nil)
    cadastro = CadastroPetSimples.new
    cadastro_validado = ValidadorDecorator.new(cadastro)

    resultado = cadastro_validado.cadastrar(pet)

    assert_not resultado[:success]
    assert_includes resultado[:message], "Idade do pet deve ser informada"
  end

  test "validador deve bloquear pet com idade negativa" do
    pet = Pet.new(name: "Max", species: "Dog", age: -1)
    cadastro = CadastroPetSimples.new
    cadastro_validado = ValidadorDecorator.new(cadastro)

    resultado = cadastro_validado.cadastrar(pet)

    assert_not resultado[:success]
    assert_includes resultado[:message], "Idade do pet deve ser um valor positivo"
  end

  test "validador deve bloquear pet com idade muito alta" do
    pet = Pet.new(name: "Velho", species: "Dog", age: 35)
    cadastro = CadastroPetSimples.new
    cadastro_validado = ValidadorDecorator.new(cadastro)

    resultado = cadastro_validado.cadastrar(pet)

    assert_not resultado[:success]
    assert_includes resultado[:message], "Idade do pet parece inválida"
  end

  test "validador deve bloquear pet sem espécie" do
    pet = Pet.new(name: "Sem Espécie", species: "", age: 2)
    cadastro = CadastroPetSimples.new
    cadastro_validado = ValidadorDecorator.new(cadastro)

    resultado = cadastro_validado.cadastrar(pet)

    assert_not resultado[:success]
    assert_includes resultado[:message], "Espécie do pet não pode estar vazia"
  end

  # ==============================================================================
  # Testes do AutenticadorDecorator
  # ==============================================================================

  test "autenticador deve permitir cadastro quando autenticado" do
    pet = Pet.new(name: "Bolt", species: "Dog", age: 4)
    cadastro = CadastroPetSimples.new
    cadastro_autenticado = AutenticadorDecorator.new(
      cadastro,
      autenticado: true,
      parceiro: "ONG Teste"
    )

    resultado = cadastro_autenticado.cadastrar(pet)

    assert resultado[:success], "Cadastro deveria ter sucesso quando autenticado"
    assert pet.persisted?
  end

  test "autenticador deve bloquear cadastro quando não autenticado" do
    pet = Pet.new(name: "Rex", species: "Dog", age: 3)
    cadastro = CadastroPetSimples.new
    cadastro_nao_autenticado = AutenticadorDecorator.new(
      cadastro,
      autenticado: false
    )

    resultado = cadastro_nao_autenticado.cadastrar(pet)

    assert_not resultado[:success], "Cadastro deveria falhar sem autenticação"
    assert_includes resultado[:message], "Acesso negado"
    assert_not pet.persisted?, "Pet não deveria ser salvo sem autenticação"
  end

  test "autenticador deve incluir nome do parceiro na mensagem de erro" do
    pet = Pet.new(name: "Nina", species: "Cat", age: 2)
    cadastro = CadastroPetSimples.new
    cadastro_nao_autenticado = AutenticadorDecorator.new(
      cadastro,
      autenticado: false,
      parceiro: "Parceiro Teste"
    )

    resultado = cadastro_nao_autenticado.cadastrar(pet)

    assert_includes resultado[:message], "Parceiro Teste"
  end

  # ==============================================================================
  # Testes do NotificadorDecorator
  # ==============================================================================

  test "notificador deve adicionar informação de notificação ao resultado" do
    pet = Pet.new(name: "Mel", species: "Dog", age: 1)
    cadastro = CadastroPetSimples.new
    cadastro_com_notificacao = NotificadorDecorator.new(cadastro, canal: 'email')

    resultado = cadastro_com_notificacao.cadastrar(pet)

    assert resultado[:success]
    assert resultado[:notificacao].present?, "Deveria ter informação de notificação"
    assert_equal 'email', resultado[:notificacao][:canal]
    assert resultado[:notificacao][:enviada]
  end

  test "notificador não deve enviar notificação se cadastro falhar" do
    pet = Pet.new(name: "", species: "") # Pet inválido
    cadastro = CadastroPetSimples.new
    cadastro_com_notificacao = NotificadorDecorator.new(cadastro, canal: 'sms')

    resultado = cadastro_com_notificacao.cadastrar(pet)

    assert_not resultado[:success]
    assert_nil resultado[:notificacao], "Não deveria ter notificação se cadastro falhou"
  end

  test "notificador deve funcionar com diferentes canais" do
    %w[email sms push].each do |canal|
      pet = Pet.new(name: "Thor", species: "Dog", age: 5)
      cadastro = CadastroPetSimples.new
      cadastro_notificado = NotificadorDecorator.new(cadastro, canal: canal)
      resultado = cadastro_notificado.cadastrar(pet)

      assert resultado[:success], "Cadastro deveria ter sucesso"
      assert_equal canal, resultado[:notificacao][:canal]
      pet.destroy # Limpa para próxima iteração
    end
  end

  # ==============================================================================
  # Testes de Cadeia de Decoradores (Integração)
  # ==============================================================================

  test "cadeia completa deve funcionar com pet válido e autenticado" do
    pet = Pet.new(name: "Luna", species: "Cat", age: 2, description: "Gata amigável")

    # Constrói a cadeia: Autenticação → Validação → Cadastro → Notificação
    cadastro = CadastroPetSimples.new
    cadastro = NotificadorDecorator.new(cadastro, canal: 'email')
    cadastro = ValidadorDecorator.new(cadastro)
    cadastro = AutenticadorDecorator.new(cadastro, autenticado: true, parceiro: "ONG Teste")

    resultado = cadastro.cadastrar(pet)

    assert resultado[:success], "Cadeia completa deveria ter sucesso"
    assert pet.persisted?, "Pet deveria estar salvo"
    assert resultado[:notificacao].present?, "Deveria ter notificação"
  end

  test "cadeia deve falhar na autenticação antes de validar" do
    pet = Pet.new(name: "Rex", species: "Dog", age: 3)

    cadastro = CadastroPetSimples.new
    cadastro = NotificadorDecorator.new(cadastro)
    cadastro = ValidadorDecorator.new(cadastro)
    cadastro = AutenticadorDecorator.new(cadastro, autenticado: false)

    resultado = cadastro.cadastrar(pet)

    assert_not resultado[:success], "Deveria falhar na autenticação"
    assert_includes resultado[:message], "Acesso negado"
    assert_not pet.persisted?, "Pet não deveria ser salvo"
    assert_nil resultado[:notificacao], "Não deveria ter notificação"
  end

  test "cadeia deve falhar na validação após autenticação" do
    pet = Pet.new(name: "", species: "Dog", age: 3) # Nome vazio

    cadastro = CadastroPetSimples.new
    cadastro = NotificadorDecorator.new(cadastro)
    cadastro = ValidadorDecorator.new(cadastro)
    cadastro = AutenticadorDecorator.new(cadastro, autenticado: true)

    resultado = cadastro.cadastrar(pet)

    assert_not resultado[:success], "Deveria falhar na validação"
    assert_includes resultado[:message], "Nome do pet não pode estar vazio"
    assert_not pet.persisted?
    assert_nil resultado[:notificacao]
  end

  test "decoradores podem ser combinados em qualquer ordem" do
    pet = Pet.new(name: "Nina", species: "Cat", age: 3)

    # Ordem diferente: Validação → Autenticação → Cadastro → Notificação
    cadastro = CadastroPetSimples.new
    cadastro = NotificadorDecorator.new(cadastro, canal: 'sms')
    cadastro = AutenticadorDecorator.new(cadastro, autenticado: true)
    cadastro = ValidadorDecorator.new(cadastro)

    resultado = cadastro.cadastrar(pet)

    assert resultado[:success], "Decoradores em ordem diferente deveriam funcionar"
    assert pet.persisted?
  end

  test "apenas alguns decoradores podem ser usados" do
    pet = Pet.new(name: "Max", species: "Dog", age: 5)

    # Usa apenas Validação + Notificação (sem Autenticação)
    cadastro = CadastroPetSimples.new
    cadastro = NotificadorDecorator.new(cadastro)
    cadastro = ValidadorDecorator.new(cadastro)

    resultado = cadastro.cadastrar(pet)

    assert resultado[:success], "Deveria funcionar sem todos os decoradores"
    assert pet.persisted?
    assert resultado[:notificacao].present?
  end
end
