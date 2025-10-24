class Reports::StrategyInterface
  
  def handle_report

    data = fetch_data
    
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
end