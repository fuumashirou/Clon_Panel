class Promotion
  include Mongoid::Document
  belongs_to :store
  embeds_many :items, class_name: "PromotionItem"

  mount_uploader :image, ImageUploader

  attr_accessor :pack_items
  field :name,     type: String
  field :start_at, type: DateTime
  field :end_at,   type: DateTime
  field :active,   type: Mongoid::Boolean, default: true
  field :starred,  type: Mongoid::Boolean, default: false
  field :pack,     type: Mongoid::Boolean, default: true
  # Pack
  field :price,    type: Float
  field :image,    type: String
  field :quantity, type: Integer
  # Discount
  field :discount, type: Float
  field :fixed,    type: Mongoid::Boolean, default: false

  before_save :add_items, if: Proc.new { |p| p.new_record? }
  before_destroy :remove_items, unless: Proc.new { |p| p.pack }

  validates_presence_of :name, :start_at, :end_at

  def add_items
      items = Item.find(self.pack_items)
      self.items = items
    if self.pack == false
      items.each do |item|
        item.add_promotion self
      end
    end
  end

  def remove_items
    item_ids = self.items.map(&:_id)
    items = Item.find(item_ids)
    items.each do |item|
      item.remove_promotion self
    end
  end

end
