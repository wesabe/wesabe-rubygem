require 'net/https'
require 'rexml/document'
require 'yaml'

class Wesabe
  attr_accessor :username, :password, :accounts, :account_xml, :http
  
  def initialize(username, password)
    self.username = username
    self.password = password
    initialize_http
  end
  
  def initialize_http
    self.http = Net::HTTP.new("www.wesabe.com", 443)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.ca_file = self.class.ca_file
  end
  
  def fetch_accounts
    self.account_xml = get_accounts_xml
    self.accounts = parse_accounts_list account_xml
  end
  
  def trigger_updates
    http.start do |wesabe|
      request = Net::HTTP::Post.new('/user/login')
      request.set_form_data({'username' => username, 'password' => password})
      response = http.request(request)
      
      case response
      when Net::HTTPOK
        STDERR.puts "Bad username and password"
        exit(-1)
      when Net::HTTPRedirection
        puts "Logged in successfully"
        response.body
      else
        STDERR.puts "Unexpected response: #{response.inspect}"
        exit(-1)
      end
    end
  end
  
  def get_accounts_xml
    http.start do |wesabe|
      request = Net::HTTP::Get.new('/accounts.xml')
      request.basic_auth(username, password)
      response = http.request(request)
      
      case response
      when Net::HTTPFound
        STDERR.puts "Incorrect username or password."
        exit(-1)
      when Net::HTTPOK
        response.body
      else
        STDERR.puts "Unexpected response: #{response.inspect}"
        exit(-1)
      end
    end
  end
  
  def parse_accounts_list(xml)
    accounts = {}
    doc = REXML::Document.new(xml)
    doc.root.each_element('//account') do |account|
      id = account.elements["id"].text
      name = account.elements["name"].text
      balance = account.elements["current-balance"]
      if balance
        balance = balance.text.to_f
        balance_in_cents = (balance * 100).to_i
      end
      accounts[id] = {
        :name => name, 
        :balance => balance, 
        :balance_in_cents => balance_in_cents
      }
    end
    accounts
  end
  
  def [](id)
    accounts[id.to_s]
  end
  
  def self.ca_file
    [File.expand_path("~/.wesabe"), File.dirname(__FILE__)].each do |dir|
      file = File.join(dir, "cacert.pem")
      return file if File.exist?(file)
    end
    raise "Unable to find a CA pem file to use for www.wesabe.com"
  end
end
