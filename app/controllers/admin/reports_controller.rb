require 'csv'
class Admin::ReportsController < ApplicationController
  
  def index
  end
  def create
    report_type = params[:report_type]
    context = ReportContext.new(report_type)
    @report_data = context.execute_report
    respond_to do |format|
      format.html do
        render :show
      end
      format.csv do
        csv_string = CSV.generate(headers: true) do |csv|
          csv << @report_data[:headers]
          @report_data[:rows].each do |row|
            csv << row
          end
        end
        filename = "relatorio_#{report_type}_#{Time.now.strftime('%Y%m%d')}.csv"
        send_data csv_string, filename: filename
      end
    end
    rescue => e
    redirect_to admin_reports_path, alert: "Erro: #{e.message}"
  end
end