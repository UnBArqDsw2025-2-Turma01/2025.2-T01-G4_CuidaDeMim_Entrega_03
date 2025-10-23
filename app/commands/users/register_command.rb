module Users
  class RegisterCommand
    def initialize(params)
      @params = params
    end

    def call
      user = User.new(params)
      if user.save
        Result.success(user)
      else
        Result.failure(user.errors.full_messages)
      end
    end

    private

    attr_reader :params
  end
end