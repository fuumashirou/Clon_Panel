class WaitersController < ApplicationController
  append_view_path 'app/views/stores'
  layout "display", only: :display
  before_action :set_store
  before_action :set_waiter, only: [:show, :edit, :update, :destroy]

  def index
    @waiters = @store.waiters
  end

  def show
  end

  def new
    @waiter = @store.waiters.new
  end

  def edit
  end

  def create
    @waiter = @store.waiters.new(waiter_params)

    if @waiter.save
      redirect_to [@store, @waiter], notice: 'Waiter was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @waiter.update(waiter_params)
      redirect_to [@store, @waiter], notice: 'Waiter was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @waiter.destroy
    redirect_to [@store, :waiters], notice: 'Waiter was successfully destroyed.'
  end

  private
    def set_waiter
      @waiter = @store.waiters.find(params[:id])
    end
    def waiter_params
      params.require(:waiter).permit(:username, :allowed, :active)
    end
end
