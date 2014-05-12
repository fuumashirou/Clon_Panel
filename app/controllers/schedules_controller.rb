class SchedulesController < ApplicationController
  append_view_path 'app/views/stores'
  before_action :primary_only, only: [:edit, :update, :new, :create]
  before_action :set_store
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @schedule = @store.build_schedule
  end

  def edit
  end

  def create
    @schedule = @store.build_schedule(schedule_params)

    if @schedule.save
      redirect_to [@store, :schedule], notice: 'Schedule was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @schedule.update(schedule_params)
      redirect_to [@store, :schedule], notice: 'Schedule was successfully updated.'
    else
      render action: 'edit'
    end
  end

private
  def set_schedule
    @schedule = @store.schedule
  end
  def schedule_params
    params.require(:schedule).permit!
  end
end
