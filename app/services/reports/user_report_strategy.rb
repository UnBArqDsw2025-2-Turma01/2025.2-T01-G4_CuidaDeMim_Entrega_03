
require_relative 'strategy_interface'
require_relative 'mock_data'
class Reports::UserReportStrategy < Reports::StrategyInterface

  protected

  def fetch_data
    # Permite filtrar por tipo se passado no options
    if defined?(@options) && @options && @options[:tipo]
      Reports::MockData.fetch_user_data.select { |user| user[:tipo] == @options[:tipo] }
    else
      Reports::MockData.fetch_user_data
    end
  end

  def initialize(options = nil)
    @options = options
  end

  def format_rows(data)
    data.map do |user| 
      [user[:id], user[:nome], user[:email], user[:tipo], user[:data_cadastro]] 
    end
  end

  def build_headers
    ["ID", "Nome", "Email", "Tipo", "Data de Cadastro"]
  end

  def build_title
    "Relatório de Usuários Cadastrados"
  end
end