class PetsController < ApplicationController
  before_action :set_pet, only: %i[ show edit update destroy ]

  # GET /pets or /pets.json
  def index
    @pets = Pet.all
  end

  # GET /pets/1 or /pets/1.json
  def show
    # Adicionando um log para demonstrar o método exclusivo do Concrete Product, se existir
    puts "Pet sound check: #{@pet.sound}" if @pet.respond_to?(:sound)
  end

  # GET /pets/new
  def new
    @pet = Pet.new
  end

  # GET /pets/1/edit
  def edit
  end

  # POST /pets or /pets.json
  def create
    # APLICAÇÃO DO PADRÃO CRIACIONAL (FACTORY METHOD)
    # Ele apenas delega a responsabilidade para a PetFactory.
    @pet = PetFactory.create(pet_params)

    # APLICAÇÃO DO PADRÃO ESTRUTURAL (DECORATOR)
    # Constrói uma cadeia de decoradores para adicionar comportamentos ao cadastro
    resultado = cadastrar_com_decorators(@pet)

    respond_to do |format|
      if resultado[:success]
        # Lógica de demonstração no console (verifique a saída do 'rails s')
        puts "LOG: Pet criado com sucesso usando Factory + Decorator. Tipo: #{@pet.species}"
        puts "LOG: Testando método exclusivo: #{@pet.sound}" if @pet.respond_to?(:sound)

        format.html { redirect_to pet_url(@pet), notice: resultado[:message] }
        format.json { render :show, status: :created, location: @pet }
      else
        format.html { render :new, status: :unprocessable_entity, alert: resultado[:message] }
        format.json { render json: { error: resultado[:message] }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pets/1 or /pets/1.json
  def update
    respond_to do |format|
      if @pet.update(pet_params)
        format.html { redirect_to @pet, notice: "Pet was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @pet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pets/1 or /pets/1.json
  def destroy
    @pet.destroy!

    respond_to do |format|
      format.html { redirect_to pets_path, notice: "Pet was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pet
      @pet = Pet.find(params[:id])
    end

    # A Factory precisa do 'species' para funcionar, então ele deve ser permitido aqui.
    def pet_params
      params.require(:pet).permit(:name, :species, :age, :description, :adopted)
    end

    # Constrói a cadeia de decoradores para o cadastro do pet
    # Demonstra o padrão Decorator em ação
    def cadastrar_com_decorators(pet)
      # Componente base: cadastro simples
      cadastro = CadastroPetSimples.new

      # Adiciona o decorador de notificação (por último, para notificar após sucesso)
      cadastro = NotificadorDecorator.new(cadastro, canal: 'email')

      # Adiciona o decorador de validação (verifica dados antes de cadastrar)
      cadastro = ValidadorDecorator.new(cadastro)

      # Adiciona o decorador de autenticação (verifica acesso antes de tudo)
      # TODO: Integrar com sistema de autenticação real (Devise, etc.)
      # Por enquanto, simula autenticação como true
      autenticado = true # Altere para false para testar bloqueio
      parceiro = "Parceiro Exemplo ONG" # Simula o parceiro autenticado
      cadastro = AutenticadorDecorator.new(cadastro, autenticado: autenticado, parceiro: parceiro)

      # Executa a cadeia de decoradores
      cadastro.cadastrar(pet)
    end

    def destroy(pet)
      if pet.destroy
        Rails.logger.info("Pet '#{pet.name}' destruído com sucesso.")

        respond_to do |format|
          format.html { redirect_to pets_url, notice: "Pet foi deletado com sucesso" }
          format.json { render json: { message: "Pet deletado com sucesso" }, status: :ok }
        end
      else
        Rails.logger.error("Falha ao deletar o pet '#{pet.name}': #{pet.errors.full_messages.join(', ')}")

        respond_to do |format|
          format.html { redirect_to pets_url, alert: "Falha ao deletar o pet." }
          format.json { render json: { error: "Falha ao deletar o pet" }, status: :unprocessable_entity }
        end
      end
    end