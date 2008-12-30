require File.dirname(__FILE__) + '/../spec_helper'

describe Wesabe::Credential do
  before do
    @cred = credential(0)
  end

  describe "class method from_xml" do
    it "returns a Wesabe::Credential populated by the xml response" do
      @cred.id.should == 1
      @cred.financial_institution.should be_an_instance_of(Wesabe::FinancialInstitution)
      @cred.accounts.should have(2).items
      @cred.accounts.each {|a| a.should be_an_instance_of(Wesabe::Account)}
    end
  end

  describe "start_job" do
    describe "with a successful response" do
      before do
        @cred.stub!(:post).and_return(fixture(:new_job))
      end

      it "posts with the correct options" do
        @cred.
          should_receive(:post).
          with(:url => "/credentials/#{@cred.id}/jobs.xml").
          and_return(fixture(:new_job))
        @cred.start_job
      end

      it "returns a Wesabe::Job representing the newly-created job" do
        job = @cred.start_job
        job.should be_an_instance_of(Wesabe::Job)
        job.id.should == "dc7ac0e6-6887-11dd-42be-7dfe37500884"
        job.status.should == "pending"
        job.result.should == "started"
      end

      it "associates the Wesabe::Job with this Wesabe::Credential" do
        job = @cred.start_job
        job.credential.should == @cred
      end
    end

    describe "with an unsuccessful response" do
      describe "because the creds were rejected by the FI" do
        before do
          @response = stub(:response, :code => '401', :body => fixture(:new_job_creds_denied))
          @cred.stub!(:post).and_raise(
            Wesabe::Request::RequestFailed.new(@response))
        end

        it "raises with the right error message" do
          lambda { @cred.start_job }.
            should raise_error(Wesabe::Request::RequestFailed,
              "The last job run for these credentials was rejected by the financial institution.")
        end
      end

      describe "because the creds already have a job running" do
        before do
          @response = stub(:response, :code => '400', :body => fixture(:new_job_existing_job))
          @cred.stub!(:post).and_raise(
            Wesabe::Request::RequestFailed.new(@response))
        end

        it "raises with the right error message" do
          lambda { @cred.start_job }.
            should raise_error(Wesabe::Request::RequestFailed,
              "The last job run for these credentials is still running.")
        end
      end
    end
  end
end
