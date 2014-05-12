module PaymentTypes
  class Main
    @@methods = YAML.load(File.read(File.expand_path("#{Rails.root}/lib/payment/payment_methods.yaml", __FILE__)))

    attr_accessor :name, :website, :variable_value, :fixed_value, :currency, :button_image, :active, :countries

    def initialize data
      self.name            = data["name"]
      self.website         = data["website"]
      self.variable_value  = data["variable_value"] || 0
      self.fixed_value     = data["fixed_value"]    || 0
      self.currency        = data["currency"]
      self.button_image    = data["button_image"]
      self.active          = data["active"]         || false
      self.countries       = data["countries"]
    end

    def self.list
      return @@methods.keys
    end

    def self.find name
      if @@methods[name]
        return PaymentTypes::Main.new @@methods[name]
      else
        return nil
      end
    end
  end
end
