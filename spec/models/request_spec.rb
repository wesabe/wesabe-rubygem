require File.dirname(__FILE__) + '/../spec_helper'

describe Wesabe::Request do
  def request(options={})
    Wesabe::Request.new({
      :url => '/accounts.xml', 
      :username => 'quentin', 
      :password => 'abcde'}.merge(options))
  end
  
  describe "initialize" do
    it "takes a hash of options" do
      req = request
      req.url.should == '/accounts.xml'
      req.username.should == 'quentin'
      req.password.should == 'abcde'
    end
    
    describe "without a url" do
      it "raises" do
        lambda { request(:url => nil) }.
          should raise_error(ArgumentError, "Missing option 'url'")
      end
    end
    
    describe "without a username" do
      it "raises" do
        lambda { request(:username => nil) }.
          should raise_error(ArgumentError, "Missing option 'username'")
      end
    end
    
    describe "without a password" do
      it "raises" do
        lambda { request(:password => nil) }.
          should raise_error(ArgumentError, "Missing option 'password'")
      end
    end
  end
  
  describe "net" do
    def net(*args)
      request(*args).send(:net)
    end
    
    it "returns an SSL-enabled Net::HTTP instance" do
      net.should be_an_instance_of(Net::HTTP)
      net.use_ssl.should be_true
      net.verify_mode.should == OpenSSL::SSL::VERIFY_PEER
    end
  end
  
  describe "process_response" do
    def process(code, body, header={})
      request.send(:process_response, 
        stub(:response, :code => code, :body => body, :header => header))
    end
    
    describe "with a 200 response" do
      it "returns the response body" do
        process('200', '<accounts></accounts>').should == '<accounts></accounts>'
      end
    end
    
    describe "with a 302 response" do
      it "raises Redirect with the url" do
        lambda { process('302', '', 'Location' => 'https://www.wesabe.com/user/login') }.
          should raise_error(Wesabe::Request::Redirect, 'https://www.wesabe.com/user/login')
      end
    end
    
    describe "with a 401 response" do
      it "raises Unauthorized" do
        lambda { process('401', '') }.should raise_error(Wesabe::Request::Unauthorized)
      end
    end
  end
end
