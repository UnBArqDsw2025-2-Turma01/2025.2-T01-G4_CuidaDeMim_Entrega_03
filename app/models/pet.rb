class Pet < ApplicationRecord
  # Validação simples para garantir que a Factory está funcionando
  validates :name, presence: true
  validates :species, presence: true

  # Método padrão para o caso de não ser um tipo especial (Dog ou Cat)
  def sound
    "..."
  end
end