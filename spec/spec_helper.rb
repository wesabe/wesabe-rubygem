require File.dirname(__FILE__) + '/../lib/wesabe'
require 'spec'

Spec::Runner.configure do |config|
  def fixture(name)
    if File.exist?(path = fixture_path(name, :xml))
      # Hpricot::XML(File.read(path))
      File.read(path)
    end
  end

  def xml_fixture(name)
    Hpricot::XML(fixture(name))
  end

  def fixture_path(name, ext)
    File.dirname(__FILE__) + "/fixtures/#{name}.#{ext}"
  end

  def financial_institution(n)
    Wesabe::FinancialInstitution.from_xml(
      xml_fixture(:financial_institutions).root.children_of_type('financial-inst')[n])
  end

  def account(n)
    Wesabe::Account.from_xml(
      xml_fixture(:accounts).root.children_of_type('account')[n])
  end

  def currency(n)
    account(n).currency
  end

  def credential(n)
    Wesabe::Credential.from_xml(
      xml_fixture(:credentials).root.children_of_type('credential')[n])
  end

  def job(n)
    Wesabe::Job.from_xml(
      xml_fixture(:jobs).root.children_of_type('job')[n])
  end
end
