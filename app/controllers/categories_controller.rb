class CategoriesController < ApplicationController
  before_action :primary_only
  before_action :set_store
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = @store.categories
  end

  def show
  end

  def new
    @category = @store.categories.new
  end

  def edit
  end

  def create
    @category = @store.categories.new(category_params)

    if @category.save
      redirect_to [@store, :categories], notice: 'Category was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @category.update(category_params)
      redirect_to [@store, :categories], notice: 'Category was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to [@store, :categories], notice: 'Category was successfully destroyed.'
  end

private
  def set_category
    @category = @store.categories.find(params[:id])
  end
  def category_params
    params.require(:category).permit(:type, :name, :description, :items)
  end
end
