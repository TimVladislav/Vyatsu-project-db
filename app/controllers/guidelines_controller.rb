class GuidelinesController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "229250"
  before_action :find_guide_with_id, only: [:show, :edit]

  def index
    @guides = Guideline.all
  end

  def show
  end

  def new
    @guide = Guideline.new
  end

  def edit
  end

  def create
    @guid = Guidelines.new(guide_params)
    if @guide.save
      redirect_to @guide
    else
      render 'edit'
    end
  end

  private

  def guide_params
    params.require(:guldeline).permit(:name, :author, :subject)
  end

  protected

  def find_guide_with_id
    @guide = Guideline.find(params[:id])
  end
end
