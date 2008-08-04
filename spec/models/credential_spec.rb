require File.dirname(__FILE__) + '/../spec_helper'

describe Wesabe::Credential do
  describe "class method from_xml" do
    it "returns a Wesabe::Credential populated by the xml response" do
      c = credential(1)
      c.id.should == 1
      c.financial_institution.should be_an_instance_of(Wesabe::FinancialInstitution)
      c.accounts.should have(2).items
      c.accounts.each {|a| a.should be_an_instance_of(Wesabe::Account)}
    end
  end
end
