# frozen_string_literal: true

# Decorador concreto que adiciona notificação após o cadastro bem-sucedido
# Responsabilidade: Enviar notificações após o cadastro do pet
class NotificadorDecorator < CadastroPetDecorator
  # @param componente [CadastroPet] O componente a ser decorado
  # @param canal [String] Canal de notificação (email, sms, push, etc.)
  def initialize(componente, canal: 'email')
    super(componente)
    @canal = canal
  end

  # Adiciona comportamento de notificação após cadastrar
  # @param pet [Pet] O objeto pet a ser cadastrado
  # @return [Hash] Resultado do cadastro com informações de notificação
  def cadastrar(pet)
    # Primeiro executa o cadastro (delega para o componente decorado)
    resultado = super(pet)

    # Se o cadastro foi bem-sucedido, envia notificação
    if resultado[:success]
      notificar(pet)
      resultado[:notificacao] = {
        enviada: true,
        canal: @canal,
        mensagem: "Notificação enviada com sucesso via #{@canal}"
      }
    else
      Rails.logger.info("Cadastro falhou, notificação não será enviada")
    end

    resultado
  end

  private

  # Simula o envio de notificação
  # @param pet [Pet] O pet que foi cadastrado
  def notificar(pet)
    mensagem = <<~MSG
      ========================================
      📧 NOTIFICAÇÃO DE CADASTRO (via #{@canal.upcase})
      ========================================
      Pet: #{pet.name}
      Espécie: #{pet.species}
      Idade: #{pet.age} ano(s)
      Descrição: #{pet.description || 'Sem descrição'}
      
      O pet foi cadastrado com sucesso no sistema CuidaDeMim!
      Em breve estará disponível para adoção.
      ========================================
    MSG

    Rails.logger.info(mensagem)
    
    # Aqui você poderia integrar com serviços reais de notificação:
    # - ActionMailer para emails
    # - Twilio para SMS
    # - Firebase para push notifications
    # Por enquanto, apenas logamos a notificação
  end
end
