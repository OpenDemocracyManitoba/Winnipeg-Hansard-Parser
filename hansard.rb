class Hansard
  BY_LAW_REGEX = /\d+\/\d{4}/
  CAPITALIZED_PHRASE_REGEX = /([A-Z][\w-]*(\s+[A-Z][\w-]+)+)/

  def initialize(options)
    @hansard_data = options[:json_hansard]
    @stop_words =  options[:stop_words]
  end

  def [](key)
    @hansard_data[key]
  end

  def date_of_meeting
    @hansard_data['meta']['date']
  end

  def sorted_word_occurrences
    all_words_counted.sorted_word_occurrences
  end

  def sorted_capitalized_phrases
    all_capitalized_phrases_minus_attendees.map do |phrase|
      { 'phrase' => phrase, 'count' => all_words.scan(phrase).size }
    end.sort{ |a, b| b['count'] <=> a['count']}
  end

  def sorted_by_laws_mentioned
    by_laws_mentioned.sort{ |a, b| b['count'] <=> a['count']}
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

  def all_words_counted
    WordsCounted.count(all_words, exclude: @stop_words)
  end

  def all_words_by_speaker
    @all_words_by_seaker ||= speaker_sections.reduce(Hash.new('')) do |h, section|
      h[section['name']] += section['spoken']
      h
    end
  end

  def counted_words_by_speaker
    @counted_words_by_speaker ||= all_words_by_speaker.each_with_object({}) do |(k, v), h|
      h[k] = WordsCounted.count(v, exclude: @stop_words)
    end
  end

  def by_laws_mentioned
    all_words.scan(BY_LAW_REGEX).uniq.map do |by_law|
      { 'identifier' => by_law, 'count' => all_words.scan(by_law).size }
    end
  end

  def all_capitalized_phrases
    all_words.scan(CAPITALIZED_PHRASE_REGEX).map(&:first).uniq
  end

  def all_capitalized_phrases_minus_attendees
    all_capitalized_phrases.select do |phrase|
      !attendance_with_guests.include?(phrase)
    end
  end
end
