class Wesabe::FinancialInstitution < Wesabe::BaseModel
  # The id of this +FinancialInstitution+, as used in URLs.
  attr_accessor :id
  # The name of this +FinancialInstitution+ ("Bank of America").
  attr_accessor :name
  # The url users of this +FinancialInstitution+ log in to for online banking.
  attr_accessor :login_url
  # The home url of this +FinancialInstitution+.
  attr_accessor :homepage_url
  
  # Initializes a +Wesabe::FinancialInstitution+ and yields itself.
  # 
  # @yieldparam [Wesabe::FinancialInstitution] financial_institution
  #   The newly-created financial institution.
  def initialize
    yield self if block_given?
  end
  
  # Returns a +Wesabe::FinancialInstitution+ generated from Wesabe's API XML.
  # 
  # @param [Hpricot::Element] xml
  #   The <financial-institution> element from the API.
  # 
  # @return [Wesabe::FinancialInstitution]
  #   The newly-created financial institution populated by +xml+.
  def self.from_xml(xml)
    new do |fi|
      fi.id = (xml.children_of_type("id") + xml.children_of_type("wesabe-id")).first.inner_text
      fi.name = xml.at("name").inner_text
      fi.login_url = xml.at("login-url") && xml.at("login-url").inner_text
      fi.homepage_url = xml.at("homepage-url") && xml.at("homepage-url").inner_text
    end
  end
end
