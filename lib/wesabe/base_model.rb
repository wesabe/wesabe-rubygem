class Wesabe::BaseModel
  include Wesabe::Util
  # The +Wesabe+ instance this model uses.
  # 
  # @return [Wesabe] The object containing the username/password to use.
  attr_accessor :wesabe
  
  # Requests via POST using the given options.
  # 
  # @see Wesabe#post
  def post(options)
    wesabe.post(options)
  end
  
  # Requests via GET using the given options.
  # 
  # @see Wesabe#get
  def get(options)
    wesabe.get(options)
  end
  
  private
  
  def associate(what)
    all_or_one(what) {|obj| obj.wesabe = wesabe}
  end
end
