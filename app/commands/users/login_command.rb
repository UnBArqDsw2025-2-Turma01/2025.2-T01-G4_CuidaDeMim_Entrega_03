module Users
  class LoginCommand
    def initialize(email, password)
      @email = email
      @password = password
    end

    def call
      user = User.find_by(email: email, password: password)

      if user
        Result.success(user)
      else
        Result.failure("Email ou senha inválidos")
      end
    end

    private

    attr_reader :email, :password
  end
end