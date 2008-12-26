# Encapsulates an upload and allows uploading files to wesabe.com.
class Wesabe::Upload < Wesabe::BaseModel
  # The accounts this upload is associated with.
  attr_accessor :accounts
  # The financial institution this upload is associated with.
  attr_accessor :financial_institution
  # Whether this upload succeeded or failed, or +nil+ if it hasn't started.
  attr_accessor :status
  # The raw statement to post.
  attr_accessor :statement
  
  # Initializes a +Wesabe::Upload+ and yields itself.
  # 
  # @yieldparam [Wesabe::Upload] upload
  #   The newly-created upload.
  def initialize
    yield self if block_given?
  end
  
  # Uploads the statement to Wesabe, raising on problems. It can raise
  # anything that is raised by +Wesabe::Request#execute+ in addition to 
  # the list below.
  # 
  #   begin
  #     upload.upload!
  #   rescue Wesabe::Upload::StatementError => e
  #     $stderr.puts "The file you chose to upload couldn't be imported."
  #     $stderr.puts "This is what Wesabe said: #{e.message}"
  #   rescue Wesabe::Request::Exception
  #     $stderr.puts "There was a problem communicating with Wesabe."
  #   end
  # 
  # @raise [Wesabe::Upload::StatementError]
  #   When the statement cannot be processed, this is returned (error code 5).
  # 
  # @see Wesabe::Request#execute
  def upload!
    process_response do
      post(:url => '/rest/upload/statement', :payload => pack_statement)
    end
  end
  
  # Determines whether this upload succeeded or not.
  # 
  # @return [Boolean]
  #   +true+ if +status+ is +"processed"+, +false+ otherwise.
  def successful?
    status == "processed"
  end
  
  # Determines whether this upload failed or not.
  # 
  # @return [Boolean]
  #   +false+ if +status+ is +"processed"+, +true+ otherwise.
  def failed?
    !successful?
  end
  
  private
  
  # Generates XML to upload to wesabe.com to create this +Upload+.
  # 
  # @return [String]
  #   An XML document containing the relevant upload data.
  def pack_statement
    upload = self
    
    Hpricot.build do
      tag! :upload do
        tag! :statement, :accttype => upload.accounts[0].type, :acctid => upload.accounts[0].number, :wesabe_id => upload.financial_institution.id do
          text! upload.statement
        end
      end
    end.inner_html
  end
  
  # Processes the response that is the result of +yield+ing.
  # 
  # @see upload!
  def process_response
    self.status = nil
    raw = yield
    doc = Hpricot.XML(raw)
    response = doc.at("response")
    raise Exception, "There was an error processing the response: #{raw}" unless response
    self.status = response["status"]
    
    if !successful?
      message = response.at("error>message")
      raise StatementError, message && message.inner_text
    end
  end
end

class Wesabe::Upload::Exception < RuntimeError; end
class Wesabe::Upload::StatementError < Wesabe::Upload::Exception; end
