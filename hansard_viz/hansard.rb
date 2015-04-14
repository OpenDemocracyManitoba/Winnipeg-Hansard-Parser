require_relative './pattern_counter.rb'

class Hansard
  BY_LAW_REGEX = /\d+\/\d{4}/
  CAPITALIZED_PHRASE_REGEX = /([A-Z][\w-]*(?:\s+[A-Z][\w-]+)+)/
  WORD_REGEX = /[\p{Alpha}\-']+/

  def initialize(options)
    @hansard_data  = options[:json_hansard]
    @stop_words    = options[:stop_words] || []
  end

  def all_sections
    @hansard_data['hansard']
  end

  def speaker_sections
    @speaker_sections ||= sections_of_type('speaker')
  end

  def motion_sections
    @motion_sections ||= sections_of_type('motion')
  end

  def vote_sections
    @vote_sections ||= sections_of_type('vote')
  end

  def topic_sections
    @topic_sections ||= sections_of_type('section')
  end

  def date_of_meeting
    @hansard_data['meta']['date']
  end

  def sorted_word_occurrences
    PatternCounter.new(all_words, WORD_REGEX, @stop_words)
                  .unique_matches_sorted
  end

  def by_laws_counted
    PatternCounter.new(all_words, BY_LAW_REGEX)
                  .unique_matches_sorted
  end

  def capitalized_phrases_counted
    excluded_phrases = attendance_with_guests
    excluded_phrases << 'By-law  No'
    PatternCounter.new(all_words, CAPITALIZED_PHRASE_REGEX, excluded_phrases)
                  .unique_matches_sorted
                  .map do |phrase, count| # Re-Capitalize Phrases
                    [phrase.split.map(&:capitalize).join(' '), count]
                  end
  end

  def speakers_sorted_by_counted_words
    counted_words_by_speaker.sort_by do |_name, counted_words|
      counted_words
    end.reverse!
  end

  def all_words
    @all_words ||= speaker_sections.reduce('') do |words, speaker_section|
      words + speaker_section['spoken']
    end
  end
  
  def attendance_with_guests
    @attendance_with_guests ||= speaker_sections.map do |section|
      section['name']
    end.uniq.reject { |name| name =~ /clerk/i}
  end
  
  def guests_in_attendance
  end
  

  private

  def sections_of_type(section_type)
    @hansard_data['hansard'].select do |section|
      section['type'] == section_type
    end
  end

  def all_words_by_speaker
    speaker_sections.each_with_object(Hash.new('')) do |section, h|
      h[section['name']] += section['spoken']
    end
  end

  def counted_words_by_speaker
    all_words_by_speaker.each_with_object({}) do |(k, v), h|
      h[k] = PatternCounter.new(v, WORD_REGEX).matches.size
    end.reject { |words| words =~ /clerk/i}
  end
end
