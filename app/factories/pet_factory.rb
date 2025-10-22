class PetFactory
  # O método estático (de classe) que o Controller irá chamar.
  def self.create(pet_params)
    species = pet_params[:species].to_s.downcase
    
    case species
    when 'cachorro', 'dog'
      return ::Dog.new(pet_params)  
    when 'gato', 'cat'
      return ::Cat.new(pet_params)  
    else
      return Pet.new(pet_params)
    end
  end
end