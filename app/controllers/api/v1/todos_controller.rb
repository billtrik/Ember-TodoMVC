class API::V1::TodosController < ApplicationController
  respond_to :json

  def index
    respond_with Todo.all
  end


  def show
    respond_with Todo.find(params[:id])
  end

  def update
    @todo = Todo.find(params[:id])

    if @todo.update post_params
      respond_with @article
    else
      render :json => {:error_message => "We're sorry, but something went wrong. We've been notified about this issue and we'll take a look at it shortly."}
    end
  end


  private
    def post_params
      params.require(:todo).permit(:title, :completed)
    end


end
