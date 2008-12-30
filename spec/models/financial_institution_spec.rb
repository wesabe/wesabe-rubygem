require File.dirname(__FILE__) + '/../spec_helper'

describe Wesabe::FinancialInstitution do
  describe "class method from_xml" do
    it "returns a Wesabe::FinancialInstitution populated by the xml response" do
      fi = financial_institution(0)
      fi.id.should == "us-003383"
      fi.name.should == "American Express Card"
      fi.login_url.should == "https://www99.americanexpress.com/myca/ofxdl/us/action?request_type=authreg_ofxdownload&Face=en_US"
      fi.homepage_url.should == "http://www.americanexpress.com"
    end

    describe "when the xml is abbreviated" do
      it "returns id and name only" do
        fi = account(0).financial_institution
        fi.id.should == "us-003383"
        fi.name.should == "American Express Card"
        fi.login_url.should be_nil
        fi.homepage_url.should be_nil
      end
    end
  end
end
