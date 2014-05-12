class HhRules
  include Mongoid::Document
  embedded_in :happy_hour

  field :quantity,       type: Integer, default: 2
  field :personal,       type: Mongoid::Boolean
  field :free_selection, type: Mongoid::Boolean
end
