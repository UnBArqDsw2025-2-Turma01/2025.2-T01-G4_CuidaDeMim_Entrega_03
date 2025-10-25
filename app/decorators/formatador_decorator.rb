# frozen_string_literal: true

class FormatadorDecorator < CadastroPetDecorator
  def initialize(cadastro_pet)
    super(cadastro_pet)
  end

  def cadastrar(pet)
    formatar_dados(pet)
    super(pet)
  end

  private

  def formatar_dados(pet)
    pet.name = pet.name.strip.capitalize if pet.name.present?
    pet.species = pet.species.strip.downcase if pet.species.present?
    pet.description = pet.description.strip.capitalize if pet.description.present?
  end
end
