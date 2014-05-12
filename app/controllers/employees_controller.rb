class EmployeesController < ApplicationController
  append_view_path 'app/views/stores'
  before_action :primary_only
  before_action :set_store

  def index
    @employees = @store.employees
  end

  def new
    @employee = @store.employees.new
  end

  def create
    @employee = @store.employees.new(employee_params)

    if @employee.save
      redirect_to [:manage, @store], notice: "Employee was successfully created."
    else
      render action: "new"
    end
  end

  def edit
    @employee = @store.employees.find(params[:id])
  end

  def update
    @employee = @store.employees.find(params[:id])

    if @employee.update(employee_params)
      redirect_to [:manage, @store], notice: "Employee was successfully updated."
    else
      render action: "edit"
    end
  end

  def destroy
    @employee = @store.employees.find(params[:id])

    if @employee.destroy
      redirect_to [:manage, @store], notice: "Employee was successfully destroyed."
    else
      redirect_to "edit", alert: "Employee couldnt be destroyed."
    end
  end

private
  def employee_params
    params.require(:employee).permit(:username, :password, :password_confirmation)
  end
end
