class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  def index
    if params[:user_id]
      user = User.find_by_id(params[:user_id])
      if user 
        items = user.items
        render json: items
      else
        render_not_found_response
      end
      
    else
      items = Item.all
      render json: items, include: :user
    end
  end

  def show
    item = Item.find_by_id(params[:id])
    if item
      render json: item, status: :ok
    else
      render_not_found_response
    end
  end
  

  def create
    if params[:user_id]
      user = User.find_by(params[:user_id])
      if user
        user.items.create(params_hash)
        render json: user.items.last, status: :created
      else
        render_not_found_response
      end

    else
      item = Item.create(params_hash)
      render json: item, status: :created
    end
  end

  private

  def params_hash
    params.permit(:user_id, :description, :name, :price)
  end
  def render_not_found_response
    render json: { error: 'Not Found' }, status: :not_found
  end
end
