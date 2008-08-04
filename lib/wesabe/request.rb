class Wesabe::Request
  attr_reader :url, :username, :password, :method, :proxy, :payload
  
  private
  
  def initialize(options=Hash.new)
    @url = options[:url] or raise ArgumentError, "Missing option 'url'"
    @username = options[:username] or raise ArgumentError, "Missing option 'username'"
    @password = options[:password] or raise ArgumentError, "Missing option 'password'" 
    @proxy = options[:proxy]
    @method = options[:method] || :get
    @payload = options[:payload]
  end
  
  # Returns a new Net::HTTP instance to connect to the Wesabe API.
  # 
  # @return [Net::HTTP]
  #   A connection object all ready to be used to communicate securely.
  def net
    if proxy
      proxy_uri = URI.parse(proxy)
      http_klass = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)
    else
      http_klass = Net::HTTP
    end
    
    http = http_klass.new(uri.host, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.ca_file = self.class.ca_file
    end
    http
  end
  
  def uri
    URI.join(self.class.base_url, url)
  end
  
  def process_response(res)
    if %w[200 201 202].include?(res.code)
      res.body
    elsif %w[301 302 303].include?(res.code)
      url = res.header['Location']
      
      if url !~ /^http/
        uri = URI.parse(@url)
        uri.path = "/#{url}".squeeze('/')
        url = uri.to_s
      end
      
      raise Redirect, url
    elsif res.code == "401"
      raise Unauthorized
    elsif res.code == "404"
      raise ResourceNotFound
    else
      raise RequestFailed, url
    end
  end
  
  public
  
  # Executes the request and returns the response.
  # 
  # @return [String]
  #   The response object for the request just made.
  # 
  # @raise [Wesabe::ServerConnectionBroken]
  #   If the connection with the server breaks.
  # 
  # @raise [Timeout::Error]
  #   If the request takes too long.
  def execute
    # set up the uri
    @username = uri.user if uri.user
    @password = uri.password if uri.password
    
    # set up the request
    req = Net::HTTP.const_get(method.to_s.capitalize).new(uri.request_uri)
    req.basic_auth(username, password)
    
    net.start do |http|
      process_response http.request(req, payload || "")
    end
  end
  
  # Executes a request and returns the response.
  # 
  # @param [String] options[:url]
  #   The url relative to +Wesabe::Request.base_url+ to request (required).
  # 
  # @param [String] options[:username]
  #   The Wesabe username (required).
  # 
  # @param [String] options[:password]
  #   The Wesabe password (required).
  # 
  # @param [String] options[:proxy]
  #   The proxy url to use (optional).
  # 
  # @param [String, Symbol] options[:method]
  #   The HTTP method to use (defaults to +:get+).
  # 
  # @param [String] options[:payload]
  #   The post-body to use (defaults to an empty string).
  # 
  # @return [Net::HTTPResponse]
  #   The response object for the request just made.
  # 
  # @raise [EOFError]
  #   If the connection with the server breaks.
  # 
  # @raise [Timeout::Error]
  #   If the request takes too long.
  def self.execute(options=Hash.new)
    new(options).execute
  end
  
  def self.ca_file
    [File.expand_path("~/.wesabe"), File.join(File.dirname(__FILE__), '..')].each do |dir|
      file = File.join(dir, "cacert.pem")
      return file if File.exist?(file)
    end
    raise "Unable to find a CA pem file to use for www.wesabe.com"
  end
  
  # Gets the base url for the Wesabe API.
  def self.base_url
    @base_url ||= "https://www.wesabe.com"
  end
  
  # Sets the base url for the Wesabe API.
  def self.base_url=(base_url)
    @base_url = base_url
  end
end

class Wesabe::Request::Exception < RuntimeError; end
class Wesabe::Request::ServerBrokeConnection < Exception; end
class Wesabe::Request::Redirect < Exception; end
class Wesabe::Request::Unauthorized < Exception; end
class Wesabe::Request::ResourceNotFound < Exception; end
class Wesabe::Request::RequestFailed < Exception; end
