require 'json'
require 'erb'
require 'words_counted'
require 'pp'

class HansardViz
  include ERB::Util

  def initialize(files)
    @stopwords        = files[:stop_words].readlines.map { |line| line.chop }
    @hansard          = process(files[:json_hansard])
    @template         = files[:erb_template].read
    @output_html_file = files[:html_dataviz]
  end

  def process(file)
    hansard_data = JSON.parse(file.read)
    speaker_sections = hansard_data['hansard'].select { |section| section['type'] == 'speaker' }
    attendance_with_guests = attendance_with_guests(speaker_sections)
    hansard_data['meta']['words_spoken'] = analyses_words(speaker_sections, attendance_with_guests)
    hansard_data
  end

  def attendance_with_guests(sections)
    sections.map { |section| section['name'] }.uniq
  end

  def analyses_words(sections, attendees)
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
                    'all_words_counted' => WordsCounted.count(data['all_words']) } #, exclude: @stopwords) }
    end
    { 'speakers' => speakers.sort { |a, b| b['all_words_counted'].word_count <=> a['all_words_counted'].word_count },
      'all_words_counted' => WordsCounted.count(all_words, exclude: @stopwords) }
  end

  def render
    ERB.new(@template).result(binding)
  end

  def save
    @output_html_file.write(render)
  end
end

if ARGV.size != 3
  puts 'Missing required arguments.'
  puts "Example: #{$PROGRAM_NAME} input.json template.erb output.html"
  exit
end

input_json_file = File.open(ARGV[0], 'r:UTF-8')
input_template_file = File.open(ARGV[1], 'r:UTF-8')
output_html_file = File.open(ARGV[2], 'w:UTF-8')
stop_words_file = File.open('stopwords.txt', 'r:UTF-8')

hansard_viz = HansardViz.new({ json_hansard: input_json_file,
                      erb_template: input_template_file,
                      html_dataviz: output_html_file,
                      stop_words: stop_words_file })

hansard_viz.save

