class Table
  include Mongoid::Document
  embedded_in :store

  field :number, type: Integer
  field :token,  type: String

  validates :number, presence: true, uniqueness: true

  after_validation :generate_new_token, if: Proc.new { |t| t.new_record? }

  def generate_new_token
    begin
      random_token = SecureRandom.hex(5)
    end while !self.store.tables.where(token: random_token).empty?
    self.token = random_token
    self.save unless self.new_record?
  end
end
