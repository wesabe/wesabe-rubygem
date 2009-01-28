ARGV.each do |file|
  if !file || !File.exist?(file)
    $stderr.puts "usage: #{$0} FILE1 [FILE2 [FILE3 ...]]"
    exit(1)
  end
end

require File.dirname(__FILE__) + '/common'

ARGV.each do |file|
  puts "======= #{file} ======="

  # TODO <brian@wesabe.com> 2009-01-28: Support uploads to non-existing accounts.
  # This is a little silly, but currently the upload system requires the
  # account id (last4), account type, and balance (QIF only). These are things
  # in the OFX file, so why do we make clients handle these things? *sigh*
  begin
    puts

    # QIF doesn't have the last4 or balance
    wesabe.accounts.each_with_index do |account, i|
      puts "#{i+1}. #{account.name}"
    end
    # puts "#{wesabe.accounts.size}. Other (new account)"

    idx = readline("Which account should I upload this to? ").to_i
    if (1..wesabe.accounts.size).include?(idx)
      upload = wesabe.accounts[idx-1].new_upload
    elsif idx == wesabe.accounts.size+1 # Other
      # uh. not yet
    end

    if upload.nil?
      $stderr.puts "Cat got your tongue?"
      retry
    end
  end

  upload.statement = File.read(file)
  upload.upload!
  puts "======= #{file} [#{upload.status}] ======="
  puts
end
