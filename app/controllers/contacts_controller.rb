class ContactsController < ApplicationController
  append_view_path 'app/views/stores'
  before_action :primary_only, only: [:edit, :update, :new, :create, :destroy]
  before_filter :set_store
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  def index
    @contacts = @store.contacts
  end

  def show
  end

  def new
    @contact = @store.contacts.new
  end

  def edit
  end

  def create
    @contact = @store.contacts.new(contact_params)

    if @contact.save
      redirect_to [:manage, @store], notice: 'Contact was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @contact.update(contact_params)
      redirect_to [:manage, @store], notice: 'Contact was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @contact.destroy
    redirect_to [:manage, @store], notice: 'Contact was successfully destroyed.'
  end

private
  def set_contact
    @contact = @store.contacts.find(params[:id])
  end
  def contact_params
    params.require(:contact).permit(:name, :position, :email, :phone)
  end
end
