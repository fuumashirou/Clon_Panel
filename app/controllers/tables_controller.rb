class TablesController < ApplicationController
  append_view_path 'app/views/stores'
  layout "display", only: :display
  before_action :primary_only, only: [:create, :destroy]
  before_action :set_store
  before_action :set_table, only: [:show, :destroy, :update_token]

  def index
    @tables = @store.tables
  end

  def show
    @checkins = RedisCheckin.find_by({ table_id: @table._id })
  end

  def create
    number = @store.tables.size + 1
    @table = @store.tables.new(number: number)

    if @table.save
      redirect_to [@store, :tables], notice: 'Table was successfully created.'
    else
      render action: 'new'
    end
  end

  def destroy
    @table.destroy
    redirect_to [@store, :tables], notice: 'Table was successfully destroyed.'
  end

  def update_all
    @store.tables.each do |table|
      table.generate_new_token
    end
    redirect_to [@store, :tables], notice: "#{@store.tables.count} mesas fueron modificadas."
  end

  def update_token
    @table.generate_new_token
    redirect_to [@store, :tables], notice: 'La mesa fue modificada.'
  end

  def display
  end

private
  def set_table
    @table = @store.tables.find(params[:id])
  end
  def table_params
    params.require(:table).permit(:number)
  end
end
