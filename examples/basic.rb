begin
  require 'readline'
  include Readline
rescue LoadError
  def readline(prompt=nil)
    print prompt if prompt
    gets
  end
end

username = readline("Username: ")
password = readline("Password: ")

wesabe = Wesabe.new username, password

# login to trigger automatic updates, so your account info will be fresh
wesabe.trigger_updates

# fetch your account data (you may want to wait a minute after triggering updates)
wesabe.fetch_accounts

# the floating point balance of account #1
wesabe[1][:balance]

# the integer balance in cents of account #1
wesabe[1][:balance_in_cents]

# name of account #1
wesabe[1][:name]