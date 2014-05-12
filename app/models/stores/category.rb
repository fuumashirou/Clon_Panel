class Category
  include Mongoid::Document
  embedded_in :store

  field :type,        type: String
  field :name,        type: String
  field :description, type: String
  field :items,       type: Integer, default: 0

  before_validation :complete
  after_save :change_items_category, if: Proc.new { |i| i.name_changed? }
  before_destroy :has_items

  validates :type, presence: true
  validates :name, presence: true, uniqueness: true

  def complete
    self.name = self.name.strip()
  end

  def has_items
    errors.add :base, "Cannot delete category with items" if self.items > 0
  end

  def change_items_category
    self.store.items.where(category: self.name_was).each do |item|
      item.set(category: self.name)
    end
  end
end
