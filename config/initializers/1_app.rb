module Twable
  VERSION = File.read(Rails.root.join("VERSION")).strip
end
#
# Load all libs for threadsafety
#
Dir["#{Rails.root}/lib/**/*.rb"].each { |file| require file }

Khipu.configure do |config|
  config.receiver_id "4883"
  config.secret      "72a895bbb4c783a3b702855bb223ba7dcb1d7414"
  config.bank        "Bawdf"
end
