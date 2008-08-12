require File.dirname(__FILE__) + '/../spec_helper'

describe Wesabe::Job do
  before do
    @job = job(0)
  end
  
  describe "class method from_xml" do
    it "returns a Wesabe::Job populated by the xml response" do
      @job.id.should == "d3d63410-688d-11dd-45be-7dfe37500884"
      @job.status.should == "successful"
      @job.result.should == "ok"
      @job.created_at.should == Time.utc(2008, 8, 12, 16, 43, 44) # 2008-08-12T16:43:44Z
    end
  end
  
  describe "reload" do
    before do
      @job = Wesabe::Job.from_xml(Hpricot.XML(fixture(:pending_job)))
      @job.
        should_receive(:get).
        with(:url => "/credentials/#{@job.credential.id}/jobs/#{@job.id}.xml").
        and_return(Hpricot.XML(fixture(:job)))
    end
    
    it "replaces the contents of the job" do
      @job.status = @job.result = @job.created_at = nil
      @job.reload
      @job.status.should == "successful"
      @job.result.should == "ok"
      @job.created_at.should == Time.utc(2008, 8, 12, 16, 01, 02) # 2008-08-12T16:01:02Z
    end
    
    it "returns self" do
      @job.reload.should == @job
    end
  end
  
  describe "when status is pending" do
    before do
      @job.status = 'pending'
    end
    
    it "is pending" do
      @job.should be_pending
    end
    
    it "is not complete" do
      @job.should_not be_complete
    end
    
    it "is not successful" do
      @job.should_not be_successful
    end
    
    it "is not failed" do
      @job.should_not be_failed
    end
  end
  
  describe "when the status is successful" do
    before do
      @job.status = 'successful'
    end
    
    it "is not pending" do
      @job.should_not be_pending
    end
    
    it "is complete" do
      @job.should be_complete
    end
    
    it "is successful" do
      @job.should be_successful
    end
    
    it "is not failed" do
      @job.should_not be_failed
    end
  end
  
  describe "when the status is failed" do
    before do
      @job.status = 'failed'
    end
    
    it "is not pending" do
      @job.should_not be_pending
    end
    
    it "is complete" do
      @job.should be_complete
    end
    
    it "is not successful" do
      @job.should_not be_successful
    end
    
    it "is failed" do
      @job.should be_failed
    end
  end
end
