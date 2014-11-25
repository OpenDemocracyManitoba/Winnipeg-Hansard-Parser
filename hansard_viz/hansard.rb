require 'words_counted'

class Hansard
  BY_LAW_REGEX = /\d+\/\d{4}/
  CAPITALIZED_PHRASE_REGEX = /([A-Z][\w-]*(?:\s+[A-Z][\w-]+)+)/
  WORD_REGEX = /[\p{Alpha}\-']+/

  def initialize(options)
    @hansard_data = options[:json_hansard]
    @stop_words =  options[:stop_words] || []
  end

  def all_sections
    @hansard_data['hansard']
  end

  def date_of_meeting
    @hansard_data['meta']['date']
  end

  def sorted_word_occurrences
    Mentions.count(all_words, WORD_REGEX, @stop_words)
  end

  def by_laws_counted
    Mentions.count(all_words, BY_LAW_REGEX)
  end

  def capitalized_phrases_counted
    Mentions.count(all_words, CAPITALIZED_PHRASE_REGEX, attendance_with_guests)
  end

  def speakers_sorted_by_counted_words
    counted_words_by_speaker.map do |name, counted_words|
      { 'name' => name, 'word_count' => counted_words.word_count}
    end.sort { |a, b| b['word_count'] <=> a['word_count'] }
  end

  private
  def sections_of_type(section_type)
    @hansard_data['hansard'].select { |section| section['type'] == section_type }
  end

  def speaker_sections
    @speaker_sections ||= sections_of_type('speaker')
  end

  def attendance_with_guests
    @attendance_with_guests ||= speaker_sections.map do |section|
      section['name']
    end.uniq
  end

  def all_words
    @all_words ||= speaker_sections.reduce('') do |all_words, speaker_section|
      all_words + speaker_section['spoken']
    end
  end

  def all_words_by_speaker
    @all_words_by_seaker ||= speaker_sections.each_with_object(Hash.new('')) do |section, h|
      h[section['name']] += section['spoken']
    end
  end

  def counted_words_by_speaker
    @counted_words_by_speaker ||= all_words_by_speaker.each_with_object({}) do |(k, v), h|
      h[k] = WordsCounted.count(v, exclude: @stop_words)
    end
  end
end

class Mentions
  def initialize(all_words, regex, excludes = [])
    @all_words = all_words
    @regex = regex
    @excludes = excludes.map(&:downcase)
  end

  def self.count(all_words, regex, excludes = [])
    new(all_words, regex, excludes).mentions_counted_and_sorted
  end

  def mentions_counted_and_sorted
    unique_mentions.map do |mention|
      { 'mention' => mention, 'count' => mentions.count { |m| m == mention } }
    end.sort{ |a, b| b['count'] <=> a['count']}
  end

  private
  def unique_mentions
    @unique_mentions ||= mentions.uniq
  end

  def mentions
    return @mentions  if @mentions
    @mentions = @all_words.scan(@regex)
    @mentions = remove_one_level_of_array_nesting(@mentions)
    @mentions = @mentions.map(&:downcase).reject { |mention| @excludes.include?(mention.downcase) }
  end

  def remove_one_level_of_array_nesting(object)
    object.first.is_a?(Array) ? object.map(&:first) : object
  end
end
