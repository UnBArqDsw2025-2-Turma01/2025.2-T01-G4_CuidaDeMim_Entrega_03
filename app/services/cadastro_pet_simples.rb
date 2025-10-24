# frozen_string_literal: true

# Componente concreto que implementa o cadastro básico de pets
# Responsabilidade: Realizar o cadastro simples do pet no banco de dados
class CadastroPetSimples
  include CadastroPet

  # Realiza o cadastro simples do pet
  # @param pet [Pet] O objeto pet a ser cadastrado
  # @return [Hash] Resultado do cadastro com status e mensagem
  def cadastrar(pet)
    if pet.save
      {
        success: true,
        message: "Pet '#{pet.name}' cadastrado com sucesso!",
        pet: pet
      }
    else
      {
        success: false,
        message: "Erro ao cadastrar pet: #{pet.errors.full_messages.join(', ')}",
        pet: pet
      }
    end
  rescue StandardError => e
    {
      success: false,
      message: "Erro inesperado ao cadastrar pet: #{e.message}",
      pet: pet
    }
  end
end
