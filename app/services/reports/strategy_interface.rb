class Reports::StrategyInterface
  
  def handle_report
    # Validação simples antes de processar o relatório
    validate_strategy_implementation

    data = fetch_data
    
    # Validação dos dados obtidos
    raise "Nenhum dado disponível para o relatório" if data.nil? || data.empty?
    
    rows = format_rows(data)
    
    headers = build_headers
    
    title = build_title
    
    return { title: title, headers: headers, rows: rows }
  end

  protected

  def fetch_data
    raise NotImplementedError, "#{self.class.name} não implementou o método 'fetch_data'"
  end

  def format_rows(data)
    raise NotImplementedError, "#{self.class.name} não implementou o método 'format_rows'"
  end

  def build_headers
    raise NotImplementedError, "#{self.class.name} não implementou o método 'build_headers'"
  end

  def build_title
    raise NotImplementedError, "#{self.class.name} não implementou o método 'build_title'"
  end

  private

  # Método de validação para garantir que a estratégia está corretamente implementada
  def validate_strategy_implementation
    required_methods = [:fetch_data, :format_rows, :build_headers, :build_title]
    
    required_methods.each do |method|
      unless self.class.method_defined?(method)
        raise "Estratégia #{self.class.name} não implementou o método obrigatório '#{method}'"
      end
    end
  end
end