require File.dirname(__FILE__) + '/common'

# fetch your account data
accounts = wesabe.accounts
max_name = accounts.map{|a|a.name.size}.max
max_balance = accounts.map{|a|a.balance.to_s.size}.max

max_name = [max_name, "Account".size].max
max_balance = [max_balance, "Balance".size].max

# write header
puts "%-#{max_name}s  %#{max_balance}s" % ["Account", "Balance"]
puts "-" * (max_name + 2 + max_balance)

# write data
accounts.sort_by {|a| a.name}.each do |account|
  name_formatter = "%-#{max_name}s"
  balance_formatter = account.balance ? "%#{max_balance}.2f" : "%s"
  puts "#{name_formatter}  #{balance_formatter}" % [account.name, account.balance]
end
