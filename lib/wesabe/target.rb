class Wesabe::Target < Wesabe::BaseModel
  # The tag name
  attr_accessor :tag
  # This target's monthly limit ($)
  attr_accessor :monthly_limit
  # This target's amount remaining ($)
  attr_accessor :amount_remaining

  # Initializes a +Wesabe::Target+ and yields itself.
  #
  # @yieldparam [Wesabe::Target] Target
  #   The newly-created Target.
  def initialize
    yield self if block_given?
  end

  # Returns a +Wesabe::Target+ generated from Wesabe's API XML.
  #
  # @param [Hpricot::Element] xml
  #   The <Target> element from the API.
  #
  # @return [Wesabe::Target]
  #   The newly-created Target populated by +xml+.
  def self.from_xml(xml)
    new do |target|
      target.tag = xml.at("tag").at("name").inner_text
      target.monthly_limit = xml.at("monthly-limit").inner_text.to_f
      target.amount_remaining = xml.at("amount-remaining").inner_text.to_f
    end
  end

  def inspect
    inspect_these :tag, :monthly_limit, :amount_remaining
  end
end
