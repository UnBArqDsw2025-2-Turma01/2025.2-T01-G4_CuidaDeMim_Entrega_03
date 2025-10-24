
require_relative 'strategy_interface'
require_relative 'mock_data' 
class Reports::PartnershipReportStrategy < Reports::StrategyInterface

  protected

  def fetch_data
    # Chama o método do mock_data
    Reports::MockData.fetch_partnership_data
  end

  def format_rows(data)
    data.map do |parceria| 
      # Os campos devem corresponder ao que definimos no mock data
      [
        parceria[:id], 
        parceria[:nome], 
        parceria[:contato], 
        parceria[:status],
        parceria[:pets_cadastrados],
        parceria[:adocoes_efetivadas]
      ] 
    end
  end

  def build_headers
    # Cabeçalhos detalhados para o relatório administrativo
    ["ID Parceria", "Nome da Instituição", "Contato", "Status", "Pets Cadastrados", "Adoções Efetivadas"]
  end

  def build_title
    "Relatório de Desempenho de Parcerias"
  end
end