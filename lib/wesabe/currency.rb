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
  # @param [Hpricot::Element] xml
  #   The <currency> element from the API.
  # 
  # @return [Wesabe::Currency]
  #   The newly-created currency populated by +xml+.
  def self.from_xml(xml)
    new do |currency|
      currency.decimal_places = xml[:decimal_places].to_s.to_i
      currency.symbol         = xml[:symbol].to_s
      currency.separator      = xml[:separator].to_s
      currency.delimiter      = xml[:delimiter].to_s
    end
  end
end
