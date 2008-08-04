class Wesabe::Currency
  attr_accessor :decimal_places, :symbol, :separator, :delimiter
  
  # Initializes a +Wesabe::Currency+ and yields itself.
  # 
  # @yieldparam [Wesabe::Currency] currency
  #   The newly-created currency.
  def initialize
    yield self if block_given?
  end
  
  alias_method :precision, :decimal_places
  alias_method :precision=, :decimal_places=
  
  # Returns a +Wesabe::Currency+ generated from Wesabe's API XML.
  # 
  # @param [REXML::Element] xml
  #   The <currency> element from the API.
  # 
  # @return [Wesabe::Currency]
  #   The newly-created currency populated by +xml+.
  def self.from_xml(xml)
    new do |currency|
      currency.decimal_places = xml.attributes["decimal_places"].to_i
      currency.symbol         = xml.attributes["symbol"]
      currency.separator      = xml.attributes["separator"]
      currency.delimiter      = xml.attributes["delimiter"]
    end
  end
end
