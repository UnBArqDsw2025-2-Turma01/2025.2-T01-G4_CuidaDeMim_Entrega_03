class PetFactory
  # Lista de espécies suportadas para validação
  SUPPORTED_SPECIES = %w[cachorro dog gato cat].freeze

  # O método estático (de classe) que o Controller irá chamar.
  def self.create(pet_params)
    species = pet_params[:species].to_s.downcase
    
    # Validação de entrada
    raise ArgumentError, "Parâmetros de pet não podem ser vazios" if pet_params.nil? || pet_params.empty?
    raise ArgumentError, "Espécie é obrigatória" if species.blank?
    
    case species
    when 'cachorro', 'dog'
      return ::Dog.new(pet_params)  
    when 'gato', 'cat'
      return ::Cat.new(pet_params)
    else
      # Log de espécie não reconhecida para debugging
      Rails.logger.warn("Espécie não reconhecida: #{species}. Criando Pet genérico.")
      return Pet.new(pet_params)
    end
  end

  # Método auxiliar para listar espécies suportadas
  def self.supported_species
    SUPPORTED_SPECIES
  end

  # Método para verificar se uma espécie é suportada
  def self.species_supported?(species)
    SUPPORTED_SPECIES.include?(species.to_s.downcase)
  end
end