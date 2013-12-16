class API::V1::TodosController < ApplicationController
  respond_to :json

  def index
    respond_with Todo.all
  end


  def show
    respond_with Todo.find(params[:id])
  end

  def create
    @todo = Todo.new post_params

    if @todo.save
      render :json => @todo
    else
      render :json => {:error_message => "Error on create."}
    end
  end

  def update
    @todo = Todo.find(params[:id])

    if @todo.update post_params
      respond_with @todo
    else
      render :json => {:error_message => "Error on update."}
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    respond_with @todo
  end



  private
    def post_params
      params.require(:todo).permit(:title, :completed)
    end


end
