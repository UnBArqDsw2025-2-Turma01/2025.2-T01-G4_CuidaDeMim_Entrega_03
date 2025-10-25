class ReportContext
  STRATEGIES = {
    'user_report' => Reports::UserReportStrategy.new,
    'adoption_report' => Reports::AdoptionReportStrategy.new,
    'partnership_report' => Reports::PartnershipReportStrategy.new
  }.freeze
  attr_reader :strategy

  def initialize(report_type)
    @strategy = STRATEGIES[report_type]
  end

  def execute_report
    unless @strategy
      raise "Tipo de Relatório Inválido: Não há estratégia definida."
    end
    @strategy.handle_report
  end

  def self.available_strategies
    STRATEGIES.keys
  end

  # Método simples para verificar se uma estratégia é válida
  def self.valid_strategy?(report_type)
    STRATEGIES.key?(report_type.to_s)
  end
end