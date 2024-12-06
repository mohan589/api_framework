class RestsController < ApplicationController
  before_action :set_rest, only: [:show, :update, :destroy]

  def index
    @rests = Rest.all
    render json: @rests
  end

  def show
    render json: @rest
  end

  def create
    @rest = Rest.new(rest_params)
    if @rest.save
      render json: @rest, status: :created
    else
      render json: @rest.errors, status: :unprocessable_entity
    end
  end

  def update
    if @rest.update(rest_params)
      render json: @rest
    else
      render json: @rest.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @rest.destroy
  end

  private

  def set_rest
    @rest = Rest.find(params[:id])
  end

  def rest_params
    params.require(:rest).permit(:name)
  end
end
