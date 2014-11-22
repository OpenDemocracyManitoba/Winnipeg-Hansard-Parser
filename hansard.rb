class Hansard
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

  def capitalized_phrases
    all_words.scan(/([A-Z][\w-]*(\s+[A-Z][\w-]+)+)/).map{|i| [i.first, all_words.scan(i.first).size] }.uniq{|s| s.first}.select{|s| !attendance_with_guests.include?(s.first)}.sort{|a,b| b.last <=> a.last}
  end

  def by_laws_mentioned
    all_words.scan(/\d+\/\d{4}/).uniq.map{|i| [i, all_words.scan(i).size]}.sort{|a,b| b.last <=> a.last}
  end

  def speakers_sorted_by_counted_words
    counted_words_by_speaker.sort_by { |name, counted_words| counted_words.word_count }.reverse
  end

  private
  def sections_of_type(section_type)
    @hansard_data['hansard'].select { |section| section['type'] == section_type }
  end

  def speaker_sections
    @speaker_sections ||= sections_of_type('speaker')
  end

  def attendance_with_guests
    @attendance_with_guests ||= speaker_sections.map { |section| section['name'] }.uniq
  end

  def all_words
    @all_words ||= speaker_sections.reduce('') { |all_words, speaker_section| all_words + speaker_section['spoken'] }
  end

  def all_words_counted
    WordsCounted.count(all_words, exclude: @stop_words)
  end


  def all_words_by_speaker
    @all_words_by_seaker ||= speaker_sections.reduce(Hash.new('')) { |h, section| h[section['name']] += section['spoken']; h }
  end

  def counted_words_by_speaker
    @counted_words_by_speaker ||= all_words_by_speaker.each_with_object({}) do |(k, v), h|
      h[k] = WordsCounted.count(v, exclude: @stop_words)
    end
  end
end
