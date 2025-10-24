# Carrega a "Classe Base" (agora chamada strategy_interface) e os dados
require_relative 'strategy_interface'
require_relative 'mock_data'

# Herda da classe Reports::StrategyInterface
class Reports::AdoptionReportStrategy < Reports::StrategyInterface

  protected

  def fetch_data
    Reports::MockData.fetch_adoption_data
  end

  def format_rows(data)
    data.map do |adocao| 
      [adocao[:id], adocao[:pet], adocao[:ong], adocao[:adotante], adocao[:data]]
    end
  end

  def build_headers
    ["ID Adoção", "Nome do Pet", "ONG/Parceiro", "Adotante", "Data Aprovação"]
  end

  def build_title
    "Relatório de Adoções Aprovadas"
  end
end