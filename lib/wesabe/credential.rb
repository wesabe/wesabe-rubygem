class Wesabe::Credential
  # The id of the credential, used to identify the account in URLs.
  attr_accessor :id
  # The financial institution this credential is for.
  attr_accessor :financial_institution
  # The accounts linked to this credential.
  attr_accessor :accounts
  
  # Initializes a +Wesabe::Credential+ and yields itself.
  # 
  # @yieldparam [Wesabe::Credential] credential
  #   The newly-created credential.
  def initialize
    yield self if block_given?
  end
  
  # Returns a +Wesabe::Credential+ generated from Wesabe's API XML.
  # 
  # @param [Hpricot::Element] xml
  #   The <credential> element from the API.
  # 
  # @return [Wesabe::Credential]
  #   The newly-created credential populated by +xml+.
  def self.from_xml(xml)
    new do |cred|
      cred.id = xml.at('id').inner_text.to_i
      cred.financial_institution = Wesabe::FinancialInstitution.from_xml(
                                    xml.children_of_type('financial-institution')[0])
      cred.accounts = xml.search('accounts account').map do |account|
        Wesabe::Account.from_xml(account)
      end
    end
  end
end
