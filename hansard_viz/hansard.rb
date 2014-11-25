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

  def date_of_meeting
    @hansard_data['meta']['date']
  end

  def sorted_word_occurrences
    PatternCounter.new(all_words, WORD_REGEX, @stop_words)
                  .counted_and_sorted
  end

  def by_laws_counted
    PatternCounter.new(all_words, BY_LAW_REGEX)
                  .counted_and_sorted
  end

  def capitalized_phrases_counted
    PatternCounter.new(all_words, CAPITALIZED_PHRASE_REGEX, attendance_with_guests)
                  .counted_and_sorted
  end

  def speakers_sorted_by_counted_words
    counted_words_by_speaker.sort_by do |name, counted_words| 
      counted_words
    end.reverse!
  end

  private
  def sections_of_type(section_type)
    @hansard_data['hansard'].select do |section| 
      section['type'] == section_type
    end
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
      h[k] = PatternCounter.new(v, WORD_REGEX).number_of_matches
    end
  end
end

