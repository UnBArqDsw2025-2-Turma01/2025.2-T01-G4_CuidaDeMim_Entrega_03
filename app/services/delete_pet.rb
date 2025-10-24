#Realizar a exclusão de um pet do sistema
def delete(pet)
  if pet.destroy{
      success: true,
      message: "Pet '#{pet.name}' excluído com sucesso!"
      pet: pet
  }else{
      sucess: false,
      message: "Erro ao excluir pet: #{pet.errors.full_messages.join(', ')}"
      pet: pet
  }
end
rescue StandardError => e {
  success: false,
  message: "Erro inesperado ao excluir pet: #{e.message}"
  pet: pet
}
end
end