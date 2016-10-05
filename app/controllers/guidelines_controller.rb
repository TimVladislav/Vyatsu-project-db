class GuidelinesController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "229250"
  before_action :find_guide_with_id, only: [:show, :edit, :update, :destroy]

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
    @guide = Guideline.new(guide_params)
    if @guide.save
      redirect_to @guide
    else
      render 'edit'
    end
  end

  def update
    if @guide.update(guide_params)
      redirect_to @guide
    else
      render 'edit'
    end
  end

  def destroy
    @guide.destroy
    redirect_to guidelines_path
  end

  private

  def guide_params
    params.require(:guide).permit(:name, :author, :subject, :doc)
  end

  protected

  def find_guide_with_id
    @guide = Guideline.find(params[:id])
  end
end
