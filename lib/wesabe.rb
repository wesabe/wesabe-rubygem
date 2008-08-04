$:.unshift(File.dirname(__FILE__))

require 'net/https'
require 'rexml/document'
require 'yaml'

# Provides an object-oriented interface to the Wesabe API.
class Wesabe
  attr_accessor :username, :password
  
  # Initializes access to the Wesabe API with a certain user. All requests 
  # will be made in the context of this user.
  # 
  # @param [String] username
  #   The username of an active Wesabe user.
  # 
  # @param [String] password
  #   The password of an active Wesabe user.
  def initialize(username, password)
    self.username = username
    self.password = password
  end
  
  # Fetches the user's accounts list from Wesabe or, if the list was already
  # fetched, returns the cached result.
  # 
  # @return [Array<Wesabe::Account>]
  #   A list of the user's active accounts.
  def accounts
    @accounts ||= load_accounts
  end
  
  # Returns an account with the given id or +nil+ if the account is not found.
  # 
  # @param [#to_s] id
  #   Something whose +to_s+ result matches the +to_s+ result of the account id.
  # 
  # @return [Wesabe::Account, nil]
  #   The account whose user-scoped id is +id+ or +nil+ if there is no account
  #   with that +id+.
  def account(id)
    accounts.find {|a| a.id.to_s == id.to_s}
  end
  
  private
  
  def load_accounts
    process_accounts(
      REXML::Document.new(
        Request.execute(
          :url => '/accounts.xml', 
          :username => username, 
          :password => password)))
  end
  
  def process_accounts(xml)
    accounts = []
    xml.root.each_element("//account") do |element|
      accounts << Account.from_xml(element)
    end
    accounts
  end
end

require 'wesabe/request'
require 'wesabe/account'
require 'wesabe/currency'
require 'wesabe/credential'
require 'wesabe/financial_institution'
