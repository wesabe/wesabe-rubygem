class Wesabe::FinancialInstitution
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
  # @param [REXML::Element] xml
  #   The <financial-institution> element from the API.
  # 
  # @return [Wesabe::FinancialInstitution]
  #   The newly-created financial institution populated by +xml+.
  def self.from_xml(xml)
    new do |fi|
      fi.id = (xml.elements["id"] || xml.elements["wesabe-id"]).text
      fi.name = xml.elements["name"].text
      fi.login_url = xml.elements["login-url"] && xml.elements["login-url"].text
      fi.homepage_url = xml.elements["homepage-url"] && xml.elements["homepage-url"].text
    end
  end
end
