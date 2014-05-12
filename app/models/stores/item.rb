class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  embeds_many :selections
  belongs_to :store

  CATEGORIES = { 'Tragos' => %w(Aperitivos Bajativos Barra Bebidas Cafe\ e\ Infuciones Cervezas Champagne De\ la\ casa Energeticos Especiales Gin Jugos Pisco Ron Sin\ Alcohol Tequila Vinos Vodka Whisky),
                 'Comidas' => %w(Ensaladas Especiales Hamburguesas Picoteos Pizzas Postres Sandwiches Sushi Tablas Tex\ Mex Crepes) }
  TYPES = %w(Tragos Comidas)

  attr_accessor :type
  attr_accessor :alternatives
  attr_accessor :remove_alternatives
  field :name,          type: String
  field :description,   type: String
  field :price,         type: Float
  field :category,      type: String
  field :has_selection, type: Mongoid::Boolean, default: false
  field :happy_hour,    type: Mongoid::Boolean, default: false
  field :hh_price,      type: Float
  field :starred,       type: Mongoid::Boolean, default: false
  field :hidden,        type: Mongoid::Boolean, default: false
  field :promotions,    type: Array

  after_update  :modify_category_count, if: Proc.new { |i| i.category_changed? }, unless: Proc.new { |i| i.category_was == nil }
  after_create  :set_stock
  after_destroy :remove_stock
  after_create  :increase_category_count
  after_destroy :decrease_category_count
  after_destroy :remove_from_selections
  before_create :copy_selections
  after_validation :complete
  after_save :assign_item_to_selections

  validates :name, presence: true
  validates :price, presence: true
  validates :category, presence: true
  validate :unique_name_and_category

  def remove_from_selections
    selection_ids = self.selections.map(&:selection_id)
    selection_ids.each do |selection_id|
      selection = self.store.selections.where(id: selection_id).first
      unless selection.nil?
        selection.present_in.delete(Moped::BSON::ObjectId(selection_id))
        selection.save
      end
    end
  end

  def complete
    self.has_selection = self.selections.empty? ? false : true
    if self.type == "Tragos"
      self.happy_hour = self.happy_hour == "true" || self.happy_hour == true ? true : false
    else
      self.happy_hour = false
      self.hh_price = nil
    end
  end

  def add_promotion promotion
    self.promotions = self.promotions.nil? ? [] : self.promotions
    self.promotions.push(promotion._id.to_s)
    self.save
  end

  def remove_promotion promotion
    self.promotions.delete(promotion._id.to_s)
    self.save
  end

  def copy_selections
    unless self.alternatives.nil?
      self.selections = []
      self.alternatives.split(",").each do |alternative|
        selection = self.store.selections.where(id: alternative).first
        unless selection.nil?
          self.selections << selection.clone
        end
      end
    end
  end

  def assign_item_to_selections
    if self.selections
      self.selections.map(&:selection_id).each do |selection_id|
        selection = self.store.selections.find(selection_id)
        if selection
          selection.add_to_set(present_in: self._id)
        end
      end
      if remove_alternatives
        remove_alternatives.split(",").each do |selection_id|
          selection = self.store.selections.find(selection_id)
          if selection
            selection.pull(present_in: self._id)
          end
        end
      end
    end
  end

  def unique_name_and_category
    store = self.store
    query = store.items.where(name: self.name, category: self.category).first
    if !query.nil? && self != query
      errors.add(:name, "Already in use in that category")
    end
  end

  def set_stock
    $redis.hset("Store:#{self.store._id}:Item", self._id, true)
  end

  def remove_stock
    $redis.hdel("Store:#{self.store._id}:Item", self._id)
  end

  def modify_category_count
    debugger
    old = self.store.categories.find_by(name: self.category_was)
    old.inc(items: -1)
    # old.delete if old.items <= 0
    category = self.store.categories.find_or_create_by(name: self.category, type: self.type)
    category.inc(items: 1)
  end
  def increase_category_count
    category = self.store.categories.find_or_create_by(name: self.category, type: self.type)
    category.inc(items: 1)
  end
  def decrease_category_count
    category = self.store.categories.find_by(name: self.category)
    category.inc(items: -1)
    # category.delete if category.items <= 0
  end
end
