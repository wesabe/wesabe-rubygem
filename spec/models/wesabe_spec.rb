require File.dirname(__FILE__) + '/../spec_helper'

describe Wesabe do
  def wesabe
    @wesabe ||= Wesabe.new('username', 'password')
  end

  it "is initialized with username and password" do
    wesabe.username.should == 'username'
    wesabe.password.should == 'password'
  end

  describe "with valid credentials" do
    describe "instance method accounts" do
      def stub_request
        Wesabe::Request.
          should_receive(:execute).
          with(:url => '/accounts.xml', :method => :get, :username => 'username', :password => 'password').
          and_return(fixture(:accounts))
      end

      it "makes a request for all a user's active accounts" do
        stub_request
        wesabe.accounts.should have(4).accounts
      end

      it "caches the result" do
        wesabe.should_receive(:load_accounts).once.and_return([])
        wesabe.accounts
        wesabe.accounts
      end

      it "associates each Account with this Wesabe instance" do
        stub_request
        wesabe.accounts.map{|a| a.wesabe}.should == [wesabe, wesabe, wesabe, wesabe]
      end
    end

    describe "instance method account" do
      before do
        @accounts = [
          Wesabe::Account.new do |a|
            a.id = 6
            a.name = "Amex Blue"
          end,
          Wesabe::Account.new do |a|
            a.id = 1
            a.name = "Wells Fargo - Checking"
          end
        ]
      end

      describe "when the account with the given id is present" do
        it "returns the account" do
          wesabe.stub!(:load_accounts).and_return(@accounts)
          wesabe.account(1).should == @accounts.last
        end
      end

      describe "when the account with the given id is not present" do
        it "returns nil when an account with the given id cannot be found" do
          wesabe.stub!(:load_accounts).and_return(@accounts)
          wesabe.account(8990).should be_nil
        end
      end
    end

    describe "instance method credentials" do
      def stub_request
        Wesabe::Request.
          should_receive(:execute).
          with(:url => '/credentials.xml', :method => :get, :username => 'username', :password => 'password').
          and_return(fixture(:credentials))
      end

      it "makes a request for all a user's credentials" do
        stub_request
        wesabe.credentials.should have(2).credentials
      end

      it "caches the result" do
        wesabe.should_receive(:load_credentials).once.and_return([])
        wesabe.credentials
        wesabe.credentials
      end

      it "associates each Credential with this Wesabe instance" do
        stub_request
        wesabe.credentials.map{|c| c.wesabe}.should == [wesabe, wesabe]
      end
    end
  end
end
