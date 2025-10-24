# Representa um tipo de Pet criado pela Factory
class Cat < Pet
  # Método exclusivo do Cat para demonstração do objeto correto e do GOF factory
  def sound
    "Miau! (Sou um Cat, minha Factory me criou com este som)"
  end  

  def movement
    "Andando silenciosamente... (Movimento de Cat)"
  end

end
