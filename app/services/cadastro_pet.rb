# frozen_string_literal: true

# Interface base para o cadastro de pets (Componente do padrão Decorator)
# Define o contrato que todos os componentes concretos e decoradores devem seguir
module CadastroPet
  # Método principal que realiza o cadastro do pet
  # @param pet [Pet] O objeto pet a ser cadastrado
  # @return [Hash] Resultado do cadastro com status e mensagem
  def cadastrar(pet)
    raise NotImplementedError, "#{self.class} deve implementar o método 'cadastrar'"
  end
end
