# frozen_string_literal: true

# Decorador base abstrato para cadastro de pets
# Implementa o padrão Decorator do GoF, mantendo referência ao componente decorado
# e delegando a chamada para ele
class CadastroPetDecorator
  include CadastroPet

  # @param componente [CadastroPet] O componente a ser decorado
  def initialize(componente)
    @componente = componente
  end

  # Delega a chamada para o componente decorado
  # @param pet [Pet] O objeto pet a ser cadastrado
  # @return [Hash] Resultado do cadastro
  def cadastrar(pet)
    @componente.cadastrar(pet)
  end
end
