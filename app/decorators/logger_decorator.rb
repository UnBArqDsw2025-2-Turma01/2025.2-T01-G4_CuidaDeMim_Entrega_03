require_relative 'cadastro_pet_decorator'

class LoggerDecorator < CadastroPetDecorator
  
  # Sobrescreve o método principal (cadastrar)
  def cadastrar(pet)
    # 1. LOG: Registra a tentativa de cadastro ANTES de delegar
    log_message = "AUDITORIA: Tentativa de cadastro do Pet #{pet.nome} pelo usuário #{pet.user_id || 'Desconhecido'}."
    Rails.logger.info(log_message)
    
    # 2. DELEGAÇÃO: Chama o próximo componente/decorador na cadeia
    resultado = super(pet)
    
    # 3. LOG: Registra o resultado APÓS a delegação
    if resultado[:success]
      Rails.logger.info("AUDITORIA: Cadastro de Pet #{pet.nome} realizado com SUCESSO. ID: #{resultado[:pet].id}")
    else
      Rails.logger.error("AUDITORIA: Falha no cadastro do Pet #{pet.nome}. Motivo: #{resultado[:message]}")
    end

    # 4. RETORNO: Retorna o resultado inalterado
    resultado
  end
end