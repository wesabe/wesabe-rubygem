module Wesabe::Util
  extend self
  
  def all_or_one(what, &block)
    result = Array(what).each(&block)
    return what.is_a?(Array) ? result : result.first
  end
end
