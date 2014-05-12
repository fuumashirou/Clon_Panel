class HappyHoursController < ApplicationController
  before_action :primary_only, except: :show
  before_action :set_store
  before_action :set_happy_hour, only: [:show, :edit, :update]

  def show
  end

  def new
    @happy_hour = @store.build_happy_hour
    @happy_hour.build_schedules
    @happy_hour.build_rules
  end

  def edit
  end

  def create
    @happy_hour = @store.build_happy_hour(happy_hour_params)

    if @happy_hour.save
      redirect_to [@store, :happy_hour], notice: 'Happy hour was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @happy_hour.update(happy_hour_params)
      redirect_to [@store, :happy_hour], notice: 'Happy hour was successfully updated.'
    else
      render action: 'edit'
    end
  end

private
  def set_happy_hour
    @happy_hour = @store.happy_hour
  end

  def happy_hour_params
    params.require(:happy_hour).permit!
  end
end
