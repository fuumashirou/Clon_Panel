class Selection
  include Mongoid::Document
  embedded_in :store
  embedded_in :item
  embeds_many :selection_items

  field :title,           type: String
  field :required,        type: Mongoid::Boolean, default: true
  field :items_limit,     type: Integer
  field :aditional_price, type: Float
  field :present_in,      type: Array
  field :selection_id,    type: String, default: ->{ _id }

  before_validation :complete_data, if: Proc.new { |s| s.new_record? }
  after_create :set_selection_items_stock, unless: Proc.new { |s| s.selection_items.nil? }, unless: Proc.new { |s| s.item }
  before_destroy :remove_from_items
  after_destroy :remove_selection_items_stock, unless: Proc.new { |s| s.selection_items.nil? }
  after_update :update_associated

  accepts_nested_attributes_for :selection_items, allow_destroy: true, reject_if: Proc.new { |s| s.blank? }

  validates :title, presence: true, uniqueness: true

  def update_associated
    if self.store
      unless self.present_in.empty? || self.present_in_change
        self.present_in.each do |item_id|
          item = self.store.items.where(id: item_id).first
          unless item.nil?
            selection = item.selections.where(selection_id: self.selection_id).first
            unless selection.nil?
              selection.title = self.title
              selection.required = self.required
              selection.items_limit = self.items_limit
              selection.aditional_price = self.aditional_price
              selection.selection_items = self.selection_items
              selection.save
            end
          end
        end
      end
    end
  end

  def remove_from_items
    store = self.store
    unless !self.present_in || self.present_in.empty?
      self.present_in.each do |item_id|
        item = self.store.items.where(id: item_id).first
        unless item.nil?
          selection = item.selections.where(selection_id: self.selection_id).first
          unless selection.nil?
            selection.delete
          end
        end
      end
    end
  end

  def complete_data
    self.items_limit = self.items_limit.nil? ? 1 : self.items_limit
    self.aditional_price = self.aditional_price.nil? ? 0 : self.aditional_price
  end

  def set_selection_items_stock
    self.selection_items.each do |item|
      $redis.hset("Store:#{self.store._id}:SelectionItem", item._id, true)
    end
  end

  def remove_selection_items_stock
    self.selection_items.each do |item|
      $redis.hdel("Store:#{self.store._id}:SelectionItem", item._id)
    end
  end
end
