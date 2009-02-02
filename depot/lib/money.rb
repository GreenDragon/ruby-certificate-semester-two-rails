# Stolen from 
# http://wiki.rubyonrails.org/rails/pages/HowToUseIntegerFieldsAsMoney

class Money

  attr_reader :cents

  def initialize(cents)
    @cents = cents
  end

  def to_s
    sprintf("%0.2f", @cents / 100.0 )
  end
end

class String
  def cents
    Integer(sprintf("%0.0f", self.to_f * 100.0))
  end
end
