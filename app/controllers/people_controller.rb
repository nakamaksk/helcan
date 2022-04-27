class PeopleController < ApplicationController
  before_action :set_person, only: %i[ show edit update destroy ]

  # GET /people or /people.json
  def index
    @people = Person.all
  end

  # GET /people/1 or /people/1.json
  def show
    @weights_for_line_chart = weights_for_line_chart(@person)
    @min_weight = @weights_for_line_chart.filter{|_, v| v }.min_by{|(_, val)| val}[1]
    @max_weight = @weights_for_line_chart.filter{|_, v| v }.max_by{|(_, val)| val}[1]
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to person_url(@person), notice: "Person was successfully created." }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to person_url(@person), notice: "Person was successfully updated." }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy

    respond_to do |format|
      format.html { redirect_to people_url, notice: "Person was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:last_name, :first_name, :birth_date, :height, :weight, :body_fat, :goal)
    end

  # 日毎の体重取得
  # https://github.com/kufu/activerecord-bitemporal
  # OK : bitemporal_id で検索を行う
  # MEMO: id = bitemporal_id なの
  #       find_by(bitemporal_id: employee.id)
  #       でも動作するが employee.bitemporal_id と書いたほうが意図が伝わりやすい
  def weights_for_line_chart(person)
    Person.ignore_valid_datetime
          .where(bitemporal_id: person.bitemporal_id)
          .group_by_day(:valid_from)
          .maximum(:weight)
  end
end
