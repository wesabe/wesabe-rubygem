class Wesabe::Job < Wesabe::BaseModel
  # The globally unique identifier for this job.
  attr_accessor :id
  # The status of this job (pending|successful|failed).
  attr_accessor :status
  # The result of this job, which gives more specific 
  # information for "pending" and "failed" statuses.
  attr_accessor :result
  # When this job was created.
  attr_accessor :created_at
  # The credential that this job belongs to.
  attr_accessor :credential
  
  # Initializes a +Wesabe::Job+ and yields itself.
  # 
  # @yieldparam [Wesabe::Job] job
  #   The newly-created job.
  def initialize
    yield self if block_given?
  end
  
  # Reloads this job from the server, useful when polling for updates.
  # 
  #   job = credential.start_job
  #   until job.complete?
  #     print '.'
  #     job.reload
  #     sleep 1
  #   end
  #   puts
  #   puts "Job finished with status=#{job.status}, result=#{job.result}"
  # 
  # @return [Wesabe::Job] Returns self.
  def reload
    replace Wesabe::Job.from_xml(get(:url => "/credentials/#{credential.id}/jobs/#{id}.xml"))
    return self
  end
  
  # Determines whether this job is still running.
  # 
  # @return [Boolean] Whether the job is still running.
  def pending?
    status == 'pending'
  end
  
  # Determines whether this job is finished.
  # 
  # @return [Boolean] Whether the job is finished running.
  def complete?
    !pending?
  end
  
  # Determines whether this job is successful.
  # 
  # @return [Boolean]
  #   Whether this job has completed and, if so, whether it was successful.
  def successful?
    status == 'successful'
  end
  
  # Determines whether this job failed.
  # 
  # @return [Boolean]
  #   Whether this job has completed and, if so, whether it failed.
  def failed?
    status == 'failed'
  end
  
  # Returns a +Wesabe::Job+ generated from Wesabe's API XML.
  # 
  # @param [Hpricot::Element] xml
  #   The <job> element from the API.
  # 
  # @return [Wesabe::Job]
  #   The newly-created job populated by +xml+.
  def self.from_xml(xml)
    new do |job|
      job.id = xml.at('id').inner_text
      job.status = xml.at('status').inner_text
      job.result = xml.at('result').inner_text
      job.created_at = Time.parse(xml.at('created-at').inner_text)
    end
  end
  
  private
  
  def replace(with)
    with.instance_variables.each {|ivar| instance_variable_set(ivar, with.instance_variable_get(ivar))}
  end
end
