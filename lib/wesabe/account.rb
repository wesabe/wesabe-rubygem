# Encapsulates an account from Wesabe's API.
class Wesabe::Account < Wesabe::BaseModel
  # The user-scoped account id, used to identify the account in URLs.
  attr_accessor :id
  # The application-scoped account id, used in upload
  attr_accessor :number
  # The user-provided account name ("Bank of America - Checking")
  attr_accessor :name
  # This account's balance or +nil+ if the account is a cash account.
  attr_accessor :balance
  # This account's currency.
  attr_accessor :currency
  # The financial institution this account is held at.
  attr_accessor :financial_institution
  
  # Initializes a +Wesabe::Account+ and yields itself.
  # 
  # @yieldparam [Wesabe::Account] account
  #   The newly-created account.
  def initialize
    yield self if block_given?
  end
  
  # Creates a +Wesabe::Upload+ that can be used to upload to this account.
  # 
  # @return [Wesabe::Upload]
  #   The newly-created upload, ready to be used to upload a statement.
  def new_upload
    Wesabe::Upload.new do |upload|
      upload.accounts = [self]
      upload.financial_institution = financial_institution
      associate upload
    end
  end
  
  # Returns a +Wesabe::Account+ generated from Wesabe's API XML.
  # 
  # @param [Hpricot::Element] xml
  #   The <account> element from the API.
  # 
  # @return [Wesabe::Account]
  #   The newly-created account populated by +xml+.
  def self.from_xml(xml)
    new do |account|
      account.id = xml.at("id").inner_text.to_i
      account.name = xml.at("name").inner_text
      account.number = xml.at("account-number").inner_text.to_i if xml.at("account-number")
      balance = xml.at("current-balance")
      account.balance = balance.inner_text.to_f if balance
      account.currency = Wesabe::Currency.from_xml(xml.at("currency"))
      fi = xml.at("financial-institution")
      account.financial_institution = Wesabe::FinancialInstitution.from_xml(fi) if fi
    end
  end
  
  def inspect
    inspect_these :id, :number, :name, :balance, :financial_institution, :currency
  end
end
