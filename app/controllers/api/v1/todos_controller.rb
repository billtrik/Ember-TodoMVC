class API::V1::TodosController < ApplicationController
  respond_to :json

  def index
    respond_with Todo.all
  end


  def show
    respond_with Todo.find(params[:id])
  end

end
