class PromotionItem
  include Mongoid::Document
  embedded_in :promotion

  field :name, type: String
end
