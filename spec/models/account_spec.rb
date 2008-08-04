require File.dirname(__FILE__) + '/../spec_helper'

describe Wesabe::Account do
  describe "class method from_xml" do
    describe "with a non-cash account" do
      it "returns an Account with its properties set" do
        a = account(1)
        a.id.should == 1
        a.name.should == "American Express Card - Blue"
        a.currency.should be_an_instance_of(Wesabe::Currency)
        a.financial_institution.should be_an_instance_of(Wesabe::FinancialInstitution)
        a.balance.should == -393.42
      end
    end
    
    describe "with a cash account" do
      it "returns an Account with a nil balance" do
        account(2).balance.should be_nil
      end
      
      it "returns an Account with a nil financial_institution" do
        account(2).financial_institution.should be_nil
      end
    end
  end
end
