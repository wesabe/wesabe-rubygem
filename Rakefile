task :default => :install

desc "install the gem locally"
task :install do
  `which thor &>/dev/null`
  if $?.exitstatus != 0
    $stderr.puts "This project uses thor (http://github.com/wycats/thor)"
    exit(1)
  end
  
  sh %{thor :install}
end
