# frozen_string_literal: true

# Decorador concreto que adiciona validação de dados antes do cadastro
# Responsabilidade: Verificar se os dados do pet são válidos antes de prosseguir
class ValidadorDecorator < CadastroPetDecorator
  # Adiciona comportamento de validação antes de cadastrar
  # @param pet [Pet] O objeto pet a ser cadastrado
  # @return [Hash] Resultado da validação e cadastro
  def cadastrar(pet)
    resultado_validacao = validar_pet(pet)

    unless resultado_validacao[:valido]
      Rails.logger.warn("Validação falhou: #{resultado_validacao[:erros].join(', ')}")
      return {
        success: false,
        message: "Validação falhou: #{resultado_validacao[:erros].join(', ')}",
        pet: pet
      }
    end

    Rails.logger.info("Validação bem-sucedida para pet '#{pet.name}'")
    # Se válido, delega para o próximo componente na cadeia
    super(pet)
  end

  private

  # Valida os dados do pet
  # @param pet [Pet] O pet a ser validado
  # @return [Hash] Resultado da validação com status e lista de erros
  def validar_pet(pet)
    erros = []

    if pet.name.blank?
      erros << "Nome do pet não pode estar vazio"
    end

    if pet.age.nil?
      erros << "Idade do pet deve ser informada"
    elsif pet.age.negative?
      erros << "Idade do pet deve ser um valor positivo"
    elsif pet.age > 30
      erros << "Idade do pet parece inválida (muito alta)"
    end

    if pet.species.blank?
      erros << "Espécie do pet não pode estar vazia"
    end

    {
      valido: erros.empty?,
      erros: erros
    }
  end

  def destroy(pet)
      if pet.destroy
        Rails.logger.info("Pet '#{pet.name}' destruído com sucesso.")

        respond_to do |format|
          format.html { redirect_to pets_url, notice: "Pet foi deleteado com sucesso"}
          format.json { render json: { message: "Pet deletado com sucesso" }, status: :ok }
        end
      else
        Rails.logger.error("Falha ao deletar o pet '#{pet.name}': #{pet.errors.full_messages.join(', ')}")

        respond_to do |format|
          format.html { redirect_to pets_url, alert: "Falha ao deletar o pet." }
          format.json { render json: { error: "Falha ao deletar o pet" }, status: :unprocessable_entity }
        end
      end
end
