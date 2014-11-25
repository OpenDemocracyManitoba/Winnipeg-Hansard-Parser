class PatternCounter
  def initialize(all_words, regex, excludes = [])
    @all_words = all_words
    @regex = regex
    @excludes = excludes.map(&:downcase)
  end

  def matches
    return @matches  if @matches
    @matches = @all_words.scan(@regex)
    @matches = remove_one_level_of_array_nesting(@matches)
    @matches = @matches.map(&:downcase).reject do |mention|
      @excludes.include?(mention.downcase)
    end
  end

  def unique_matches
    @unique_matches ||= matches.uniq
  end

  def counted_and_sorted
    unique_matches.map do |match|
      [match, matches.count { |m| m == match }]
    end.sort{ |a, b| b.last <=> a.last}
  end

  private
  def remove_one_level_of_array_nesting(object)
    object.first.is_a?(Array) ? object.map(&:first) : object
  end
end
