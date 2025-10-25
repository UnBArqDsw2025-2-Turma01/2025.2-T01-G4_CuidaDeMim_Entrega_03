class Pet < ApplicationRecord
  # Validação simples para garantir que a Factory está funcionando
  validates :name, presence: true
  validates :species, presence: true

  # Método padrão para o caso de não ser um tipo especial (Dog ou Cat)
  def sound
    "..."
  end

  def movement
    "(Se movendo de forma genérica)"
  end
  
  # Método simples para mostrar informações básicas
  def info
    "Pet genérico: nome=#{name}, espécie=#{species}"
  end

  # Método simples para retornar o tipo do pet
  def tipo
    "Genérico"
  end

  def vaccine_info
    "Requer vacinas básicas."
  end

end
