# frozen_string_literal: true

# Decorador concreto que adiciona autenticação antes do cadastro
# Responsabilidade: Verificar se o parceiro está autenticado antes de permitir o cadastro
class AutenticadorDecorator < CadastroPetDecorator
  # @param componente [CadastroPet] O componente a ser decorado
  # @param autenticado [Boolean] Se o usuário está autenticado
  # @param parceiro [String, nil] Nome ou identificação do parceiro (opcional)
  def initialize(componente, autenticado:, parceiro: nil)
    super(componente)
    @autenticado = autenticado
    @parceiro = parceiro
  end

  # Adiciona comportamento de autenticação antes de cadastrar
  # @param pet [Pet] O objeto pet a ser cadastrado
  # @return [Hash] Resultado da autenticação e cadastro
  def cadastrar(pet)
    unless @autenticado
      mensagem = "Acesso negado! Parceiro não autenticado."
      mensagem += " Usuário: #{@parceiro}" if @parceiro
      
      Rails.logger.warn(mensagem)
      return {
        success: false,
        message: mensagem,
        pet: pet
      }
    end

    log_msg = "Parceiro autenticado"
    log_msg += " (#{@parceiro})" if @parceiro
    log_msg += " procedendo com o cadastro do pet '#{pet.name}'"
    Rails.logger.info(log_msg)

    # Se autenticado, delega para o próximo componente na cadeia
    super(pet)
  end
end
