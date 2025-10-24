# frozen_string_literal: true

# Serviço para exclusão de pets do sistema
# Responsabilidade: Realizar a exclusão de um pet com tratamento de erros
class DeletePet
  # Realiza a exclusão de um pet do sistema
  # @param pet [Pet] O objeto pet a ser excluído
  # @return [Hash] Resultado da exclusão com status e mensagem
  def self.delete(pet)
    if pet.destroy
      Rails.logger.info("Pet '#{pet.name}' excluído com sucesso.")
      {
        success: true,
        message: "Pet '#{pet.name}' excluído com sucesso!",
        pet: pet
      }
    else
      Rails.logger.error("Erro ao excluir pet: #{pet.errors.full_messages.join(', ')}")
      {
        success: false,
        message: "Erro ao excluir pet: #{pet.errors.full_messages.join(', ')}",
        pet: pet
      }
    end
  rescue StandardError => e
    Rails.logger.error("Erro inesperado ao excluir pet: #{e.message}")
    {
      success: false,
      message: "Erro inesperado ao excluir pet: #{e.message}",
      pet: pet
    }
  end
end