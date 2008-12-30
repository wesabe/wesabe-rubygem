module Wesabe::Util
  extend self

  # Yields +what+ or, if +what+ is an array, each element of +what+. It's
  # sort of like an argument-agnostic +map+.
  #
  # @yieldparam [Object] element
  #   If +what+ is an +Array+, this is +what+. Otherwise it's elements of +what+.
  #
  # @return [Array<Object>,Object]
  #   If +what+ is an array, it acts like +what.map+. Otherwise +yield(what)+.
  def all_or_one(what, &block)
    result = Array(what).each(&block)
    return what.is_a?(Array) ? result : result.first
  end
end
