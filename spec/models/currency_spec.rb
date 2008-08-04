require File.dirname(__FILE__) + '/../spec_helper'

describe Wesabe::Currency do
  def currency(n)
    Wesabe::Currency.from_xml(fixture(:accounts).root.elements[n].elements["currency"])
  end
  
  it "aliases precision to decimal_places" do
    c = Wesabe::Currency.new
    
    c.decimal_places = 5
    c.precision.should == 5
    
    c.precision = 4
    c.decimal_places.should == 4
  end
  
  describe "class method from_xml" do
    it "returns a Currency with its properties set" do
      c = currency(1)
      c.delimiter.should == ','
      c.separator.should == '.'
      c.decimal_places.should == 2
    end
  end
end
