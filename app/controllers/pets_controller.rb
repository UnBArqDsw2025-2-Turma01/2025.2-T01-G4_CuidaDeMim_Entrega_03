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
      # Logando o movimento no 'show' também
      puts "Pet movement check: #{@pet.movement}" if @pet.respond_to?(:movement)
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

      respond_to do |format|
      if @pet.save
          # Lógica de demonstração no console (verifique a saída do 'rails s')
          puts "LOG: Pet criado com sucesso usando a Factory. Tipo: #{@pet.species}"
          puts "LOG: Testando método exclusivo (sound): #{@pet.sound}" if @pet.respond_to?(:sound)
          # Logando o novo método de movimento
          puts "LOG: Testando método exclusivo (movement): #{@pet.movement}" if @pet.respond_to?(:movement)

          format.html { redirect_to pet_url(@pet), notice: "Pet cadastrado com sucesso (via Factory)!" }
          format.json { render :show, status: :created, location: @pet }
      else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @pet.errors, status: :unprocessable_entity }
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
  end
