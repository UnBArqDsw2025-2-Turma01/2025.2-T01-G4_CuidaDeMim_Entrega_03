# Este módulo serve como um "banco de dados fake" para nossos relatórios.
module Reports
  module MockData
    
    # Corresponde ao seu pedido de "dados dos usuarios de cadastro msm"
    def self.fetch_user_data
      [
        { id: 1, nome: "Ana Silva", email: "ana.silva@email.com", tipo: "adotante", data_cadastro: "2025-08-01" },
        { id: 2, nome: "Bruno Costa", email: "bruno.costa@email.com", tipo: "adotante", data_cadastro: "2025-08-03" },
        { id: 3, nome: "Carla Dias", email: "carla.dias@email.com", tipo: "adotante", data_cadastro: "2025-08-05" },
        { id: 4, nome: "ONG Patinhas Felizes", email: "contato@patinhas.org", tipo: "ong", data_cadastro: "2025-08-05" },
        { id: 5, nome: "Daniel Moreira", email: "daniel.m@email.com", tipo: "adotante", data_cadastro: "2025-08-10" },
        { id: 6, nome: "Eduarda Lima", email: "eduarda.l@email.com", tipo: "adotante", data_cadastro: "2025-08-12" },
        { id: 7, nome: "Fábio Mendes", email: "fabio.m@email.com", tipo: "adotante", data_cadastro: "2025-08-15" },
        { id: 8, nome: "Gabriela Nunes", email: "gabi.nunes@email.com", tipo: "adotante", data_cadastro: "2025-08-20" },
        { id: 9, nome: "ONG Salva Cão", email: "contato@salvacao.org", tipo: "ong", data_cadastro: "2025-08-21" },
        { id: 10, nome: "Hugo Pereira", email: "hugo.p@email.com", tipo: "adotante", data_cadastro: "2025-09-02" },
        { id: 11, nome: "Isabela Rocha", email: "isa.rocha@email.com", tipo: "adotante", data_cadastro: "2025-09-05" },
        { id: 12, nome: "João Pedro", email: "jp@email.com", tipo: "adotante", data_cadastro: "2025-09-10" },
        { id: 13, nome: "Karina Alves", email: "karina.a@email.com", tipo: "adotante", data_cadastro: "2025-09-12" },
        { id: 14, nome: "Lucas Martins", email: "lucas.m@email.com", tipo: "adotante", data_cadastro: "2025-09-15" },
        { id: 15, nome: "Maria Oliveira", email: "maria.o@email.com", tipo: "adotante", data_cadastro: "2025-09-20" },
        { id: 16, nome: "ONG Focinhos Carentes", email: "ajuda@focinhos.org", tipo: "ong", data_cadastro: "2025-09-22" },
        { id: 17, nome: "Natália Souza", email: "natalia.s@email.com", tipo: "adotante", data_cadastro: "2025-10-01" },
        { id: 18, nome: "Otávio Santos", email: "otavio.s@email.com", tipo: "adotante", data_cadastro: "2025-10-03" },
        { id: 19, nome: "Patrícia Ribeiro", email: "patricia.r@email.com", tipo: "adotante", data_cadastro: "2025-10-05" },
        { id: 20, nome: "Quintino Barros", email: "quintino.b@email.com", tipo: "adotante", data_cadastro: "2025-10-07" }
      ]
    end

    # Corresponde ao seu pedido de "pelo menos uns 20" dados
    def self.fetch_adoption_data
      [
        { id: 101, pet: "Rex", ong: "ONG Patinhas Felizes", adotante: "Ana Silva", data: "2025-09-01" },
        { id: 102, pet: "Mimi", ong: "ONG Salva Cão", adotante: "Bruno Costa", data: "2025-09-03" },
        { id: 103, pet: "Thor", ong: "ONG Patinhas Felizes", adotante: "Carla Dias", data: "2025-09-05" },
        { id: 104, pet: "Luna", ong: "ONG Focinhos Carentes", adotante: "Daniel Moreira", data: "2025-09-07" },
        { id: 105, pet: "Max", ong: "ONG Salva Cão", adotante: "Eduarda Lima", data: "2025-09-10" },
        { id: 106, pet: "Bella", ong: "ONG Patinhas Felizes", adotante: "Fábio Mendes", data: "2025-09-12" },
        { id: 107, pet: "Charlie", ong: "ONG Focinhos Carentes", adotante: "Gabriela Nunes", data: "2025-09-15" },
        { id: 108, pet: "Lucy", ong: "ONG Salva Cão", adotante: "Hugo Pereira", data: "2025-09-18" },
        { id: 109, pet: "Cooper", ong: "ONG Patinhas Felizes", adotante: "Isabela Rocha", data: "2025-09-20" },
        { id: 110, pet: "Daisy", ong: "ONG Focinhos Carentes", adotante: "João Pedro", data: "2025-09-22" },
        { id: 111, pet: "Rocky", ong: "ONG Salva Cão", adotante: "Karina Alves", data: "2025-09-25" },
        { id: 112, pet: "Sadie", ong: "ONG Patinhas Felizes", adotante: "Lucas Martins", data: "2025-09-28" },
        { id: 113, pet: "Molly", ong: "ONG Focinhos Carentes", adotante: "Maria Oliveira", data: "2025-10-01" },
        { id: 114, pet: "Buddy", ong: "ONG Salva Cão", adotante: "Natália Souza", data: "2025-10-02" },
        { id: 115, pet: "Lola", ong: "ONG Patinhas Felizes", adotante: "Otávio Santos", data: "2025-10-04" },
        { id: 116, pet: "Duke", ong: "ONG Focinhos Carentes", adotante: "Patrícia Ribeiro", data: "2025-10-05" },
        { id: 117, pet: "Zoe", ong: "ONG Salva Cão", adotante: "Quintino Barros", data: "2025-10-06" },
        { id: 118, pet: "Bailey", ong: "ONG Patinhas Felizes", adotante: "Ana Silva", data: "2025-10-08" },
        { id: 119, pet: "Maggie", ong: "ONG Focinhos Carentes", adotante: "Bruno Costa", data: "2025-10-10" },
        { id: 120, pet: "Toby", ong: "ONG Salva Cão", adotante: "Carla Dias", data: "2025-10-12" }
      ]
    end
  end
end