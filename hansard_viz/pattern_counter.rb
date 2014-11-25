class PatternCounter
  def initialize(all_words, regex, excludes = [])
    @all_words = all_words
    @regex = regex
    @excludes = excludes.map(&:downcase)
  end

  def matches
    matches = @all_words.scan(@regex)
    matches = remove_one_level_of_array_nesting(matches)
    matches.reject do |mention|
      @excludes.include?(mention.downcase)
    end
  end

  def unique_matches
    unique_matches_counted.keys
  end

  def counted_and_sorted
    unique_matches_counted.sort{ |a, b| b.last <=> a.last}
  end

  def unique_matches_counted
    matches.each_with_object(Hash.new(0)) do |match, h|
      h[match.downcase] += 1
    end
  end


  private
  def remove_one_level_of_array_nesting(object)
    object.first.is_a?(Array) ? object.map(&:first) : object
  end
end
