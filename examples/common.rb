require 'rubygems'
require File.dirname(__FILE__) + '/../lib/wesabe'

# make sure output is sent to the console immediately
$stderr.sync = $stdout.sync = true

# get readline or fake it
begin
  require 'readline'
  include Readline
rescue LoadError
  def readline(prompt=nil)
    print prompt if prompt
    gets
  end
end

def read_credentials
  username = readline("Username: ")
  begin
    system "stty -echo"
    password = readline("Password: ")
    puts
  ensure
    system "stty echo"
  end
  return username, password
end

def wesabe
  @wesabe ||= Wesabe.new *read_credentials
end
