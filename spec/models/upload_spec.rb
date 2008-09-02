require File.dirname(__FILE__) + '/../spec_helper'

describe Wesabe::Upload do
  before do
    @upload = account(0).new_upload
  end
  
  describe "upload!" do
    before do
      @upload.stub!(:pack_statement)
    end
    
    it "POSTs to /rest/upload/statement" do
      @upload.stub!(:process_response).and_yield
      @upload.
        should_receive(:post).
        with(:url => '/rest/upload/statement', :payload => anything)
      @upload.upload!
    end
    
    it "POSTs the payload generated from pack_statement" do
      payload = stub(:payload)
      @upload.stub!(:pack_statement).and_return(payload)
      @upload.stub!(:process_response).and_yield
      
      @upload.
        should_receive(:post).
        with(:url => anything, :payload => payload)
      @upload.upload!
    end
    
    describe "when the response is 200 OK" do
      describe "and the upload was successful" do
        before do
          @upload.stub!(:post).and_return fixture(:successful_upload)
        end
        
        it "does not raise anything" do
          lambda { @upload.upload! }.should_not raise_error
        end
        
        it "records its status" do
          lambda { @upload.upload! }.
            should change(@upload, :status).from(nil).to('processed')
        end
        
        it "is successful" do
          @upload.upload!
          @upload.should be_successful
          @upload.should_not be_failed
        end
      end
      
      describe "and the upload failed" do
        before do
          @upload.stub!(:post).and_return fixture(:failed_upload)
        end
        
        it "raises StatementError" do
          lambda { @upload.upload! }.
            should raise_error(Wesabe::Upload::StatementError, "There was an error importing the statement.")
        end
        
        it "records its status" do
          lambda { @upload.upload! rescue nil }.
            should change(@upload, :status).from(nil).to('failed')
        end
      end
      
      describe "and the response body is gibberish" do
        before do
          @upload.stub!(:post).and_return "fooglebuddy"
        end
        
        it "raises Exception" do
          lambda { @upload.upload! }.
            should raise_error(Wesabe::Upload::Exception, "There was an error processing the response: fooglebuddy")
        end
        
        it "sets the status to nil" do
          lambda { @upload.upload! rescue nil }.
            should_not change(@upload, :status).from(nil)
        end
      end
    end
    
    describe "when the request raises RequestFailed" do
      before do
        @upload.stub!(:post).and_raise(Wesabe::Request::RequestFailed)
      end
      
      it "raises RequestFailed" do
        lambda { @upload.upload! }.should raise_error(Wesabe::Request::RequestFailed)
      end
      
      it "sets the status to nil" do
        lambda { @upload.upload! rescue nil }.
          should_not change(@upload, :status).from(nil)
      end
    end
  end
  
  describe "pack_statement" do
    it "wraps the statement in <upload> and <statement> tags" do
      @upload.statement = "<OFX></OFX>"
      @upload.send(:pack_statement).should == %{<upload><statement wesabe_id="us-003383">&lt;OFX&gt;&lt;/OFX&gt;</statement></upload>}
    end
  end
end
