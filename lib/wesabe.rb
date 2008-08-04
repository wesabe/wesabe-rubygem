$:.unshift(File.dirname(__FILE__))

require 'net/https'
require 'rexml/document'
require 'yaml'

class Wesabe
  attr_accessor :username, :password
  
  def initialize(username, password)
    self.username = username
    self.password = password
  end
  
  def accounts
    unless @accounts
      @accounts = []
      accounts = Request.execute(
                  :url => '/accounts.xml', 
                  :username => username, 
                  :password => password)
      REXML::Document.new(accounts).root.each_element("//account") do |element|
        @accounts << Account.from_xml(element)
      end
    end
    
    return @accounts
  end
  
  def account(id)
    accounts.find {|a| a.id == id}
  end
end

require 'wesabe/request'
require 'wesabe/account'
require 'wesabe/currency'
