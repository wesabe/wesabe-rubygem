require File.dirname(__FILE__) + '/common'

# update each credential in turn
wesabe.credentials.each do |cred|
  print "Updating #{cred.financial_institution.name}"
  job = cred.start_job
  until job.complete?
    print '.'
    job.reload
    sleep 1
  end
  puts " #{job.result}"
end
