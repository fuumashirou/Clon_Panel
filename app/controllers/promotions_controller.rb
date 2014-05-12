class PromotionsController < ApplicationController
  before_action :set_store
  before_action :set_promotion, only: [:show, :edit, :update, :destroy]

  def index
    @promotions = @store.promotions
  end

  def show
  end

  def new
    if params[:type] == "discount"
      @promotion = @store.promotions.new(pack: false)
    else
      @promotion = @store.promotions.new(pack: true)
    end
  end

  def edit
  end

  def create
    @promotion = @store.promotions.new(promotion_params)

    if @promotion.save
      redirect_to [@store, @promotion], notice: 'Promotion was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @promotion.update(promotion_params)
      redirect_to [@store, @promotion], notice: 'Promotion was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @promotion.destroy
    redirect_to [@store, :promotions], notice: 'Promotion was successfully destroyed.'
  end

  private
    def set_promotion
      @promotion = @store.promotions.find(params[:id])
    end

    def promotion_params
      params.require(:promotion).permit!
    end
end
