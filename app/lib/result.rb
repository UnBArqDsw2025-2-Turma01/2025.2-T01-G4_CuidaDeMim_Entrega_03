class Result
  attr_reader :data, :errors

  def initialize(success:, data: nil, errors: nil)
    @success = success
    @data = data
    @errors = errors
  end

  def self.success(data = nil) = new(success: true, data: data)
  def self.failure(errors = nil) = new(success: false, errors: errors)

  def success? = @success
  def failure? = !@success
end