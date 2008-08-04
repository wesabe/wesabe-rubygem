require File.dirname(__FILE__) + '/../lib/wesabe'

Spec::Runner.configure do |config|
  def fixture(name)
    if File.exist?(path = fixture_path(name, :xml))
      REXML::Document.new(File.read(path))
    end
  end
  
  def fixture_path(name, ext)
    File.dirname(__FILE__) + "/fixtures/#{name}.#{ext}"
  end
end
