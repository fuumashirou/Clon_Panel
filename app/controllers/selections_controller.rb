class SelectionsController < ApplicationController
  before_action :primary_only, only: [:edit, :update, :new, :create, :destroy]
  before_action :set_store
  before_action :set_selection, only: [:show, :edit, :update, :destroy]

  def index
    @selections = @store.selections
  end

  def show
  end

  def new
    @selection = @store.selections.new
  end

  def edit
  end

  def create
    @selection = @store.selections.where(title: params[:selection][:title]).first
    unless @selection.nil?
      respond_to do |format|
        format.js
      end
    else
      @selection = @store.selections.new(selection_params)
      respond_to do |format|
        if @selection.save
          format.html { redirect_to [@store, :selections], notice: 'Selection was successfully created.' }
          format.js
        else
          format.html { render action: 'new' }
          format.js
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @selection.update(selection_params)
        format.html { redirect_to [@store, :selections], notice: 'Selection was successfully updated.' }
        format.js
      else
        format.html { render action: 'edit' }
        format.js
      end
    end
  end

  def destroy
    @selection.destroy
    redirect_to [@store, :selections], notice: 'Selection was successfully destroyed.'
  end

  def multi_stock
    @store.selections.each do |selection|
      selection.selection_items.each do |item|
        $redis.hset("Store:#{@store._id}:SelectionItem", item._id, true)
      end
    end
    redirect_to [@store, :selections], notice: 'Stock updated.'
  end

private
  def set_selection
    @selection = @store.selections.find(params[:id])
  end
  def selection_params
    params.require(:selection).permit!
  end
end


