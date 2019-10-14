# Generates a unique identifier for AR models
class GenerateRandomCodeService
  def self.perform(klass, column)
    loop do
      random_code = SecureRandom.hex(8).upcase
      break random_code unless klass.exists?(column => random_code)
    end
  end
end
