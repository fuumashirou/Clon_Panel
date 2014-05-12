class ItemsController < ApplicationController
  before_action :primary_only, only: [:edit, :update, :new, :create, :destroy]
  before_action :set_store
  before_action :set_item, only: [:show, :edit, :update, :destroy, :stock]

  def index
    if params[:query]
      if params[:type] == "name"
        @items = @store.items.where(name: /#{params[:query]}/i)
      elsif params[:type] == "category"
        @items = @store.items.where(category: /#{params[:query]}/i)
      end
    else
      @items = @store.items
    end
  end

  def show
  end

  def new
    @item = @store.items.build
    @selection = @store.selections.build
  end

  def edit
    @selection = @store.selections.build
  end

  def create
    @item = @store.items.new(item_params)

    if @item.save
      redirect_to [@store, @item], notice: 'Item was successfully created.'
    else
      @selection = @store.selections.build
      render action: 'new'
    end
  end

  def update
    if @item.update(item_params)
      if params[:item][:alternatives]
        @item.selections = []
        params[:item][:alternatives].split(",").each do |alternative|
          selection = @store.selections.find(alternative)
          if selection
            @item.selections << selection.clone
          end
        end
        @item.save
      end
      redirect_to [@store, @item], notice: 'Item was successfully updated.'
    else
      @selection = @store.selections.build
      render action: 'edit'
    end
  end

  def destroy
    @item.destroy
    redirect_to [@store, :items], notice: 'Item was successfully destroyed.'
  end

  def stock
    @items = @store.items
    $redis.hset("Store:#{@store._id}:Item", @item._id, params[:stock])
    respond_to do |format|
      format.js
    end
  end

  def multi_stock
    items = @store.items
    items.each do |item|
      $redis.hset("Store:#{@store._id}:Item", item._id, true)
    end
    redirect_to [@store, :items], notice: 'Stock updated.'
  end

private
  def set_item
    @item = @store.items.find(params[:id])
  end
  def item_params
    params.require(:item).permit(:name, :description, :price, :stock, :category, :type, :alternatives, :remove_alternatives, :happy_hour, :hh_price)
  end
end
