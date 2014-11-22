class Hansard

  def self.process_json(options)
    hansard_data = options[:json_hansard]
    @stop_words =  options[:stop_words]
    speaker_sections = hansard_data['hansard'].select { |section| section['type'] == 'speaker' }
    attendance_with_guests = attendance_with_guests(speaker_sections)
    hansard_data['meta']['words_spoken'] = analyses_words(speaker_sections, attendance_with_guests)
    hansard_data
  end

   def self.attendance_with_guests(sections)
    sections.map { |section| section['name'] }.uniq
  end

  def self.analyses_words(sections, attendees)
    all_words = ''
    speaker_words = {}
    attendees.each { |attendee| speaker_words[attendee] = {} }
    sections.each do |section|
      spoken = section['spoken']
      all_words += ' ' + spoken
      speaker_words[section['name']]['all_words'] = ""  unless speaker_words[section['name']]['all_words']
      speaker_words[section['name']]['all_words'] += spoken
    end
    speakers = []
    speaker_words.each do |speaker, data|
      speakers << { 'name' => speaker,
                    'all_words_counted' => WordsCounted.count(data['all_words'] , exclude: @stop_words) }
    end
    { 'speakers' => speakers.sort { |a, b| b['all_words_counted'].word_count <=> a['all_words_counted'].word_count },
      'all_words_counted' => WordsCounted.count(all_words, exclude: @stop_words),
      'capitalized_phrases' => all_words.scan(/([A-Z][\w-]*(\s+[A-Z][\w-]+)+)/).map{|i| [i.first, all_words.scan(i.first).size] }.uniq{|s| s.first}.select{|s| !attendees.include?(s.first)}.sort{|a,b| b.last <=> a.last},
      'by_laws' => all_words.scan(/\d+\/\d{4}/).uniq.map{|i| [i, all_words.scan(i).size]}.sort{|a,b| b.last <=> a.last}
    }
  end



end
