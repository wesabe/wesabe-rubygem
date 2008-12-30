require File.dirname(__FILE__) + '/../spec_helper'

describe Wesabe::Account do
  before do
    @account = account(0)
    @cash_account = account(1)
  end

  describe "new_upload" do
    it "returns an Upload" do
      @account.new_upload.should be_an_instance_of(Wesabe::Upload)
    end

    it "returns an Upload associated with this Account" do
      @account.new_upload.accounts.should include(@account)
    end

    it "returns an Upload associated with this Account's FinancialInstitution" do
      @account.new_upload.financial_institution.should == @account.financial_institution
    end

    it "returns an Upload associated with this Account's Wesabe instance" do
      @account.wesabe = stub(:wesabe)
      @account.new_upload.wesabe.should == @account.wesabe
    end
  end

  describe "class method from_xml" do
    describe "with a non-cash account" do
      it "returns an Account with its properties set" do
        @account.id.should == 1
        @account.name.should == "American Express Card - Blue"
        @account.type.should == "Credit Card"
        @account.number.should == "5000"
        @account.currency.should be_an_instance_of(Wesabe::Currency)
        @account.financial_institution.should be_an_instance_of(Wesabe::FinancialInstitution)
        @account.balance.should == -393.42
      end
    end

    describe "with a cash account" do
      it "returns an Account with a nil balance" do
        @cash_account.balance.should be_nil
      end

      it "returns an Account with a nil financial_institution" do
        @cash_account.financial_institution.should be_nil
      end
    end
  end
end
