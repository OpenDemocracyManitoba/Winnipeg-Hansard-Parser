require 'json'
require 'erb'
require 'words_counted'
require './hansard.rb'

class HansardViz
  include ERB::Util

  def initialize(options)
    @template = options[:erb_template].read
    @hansard = options[:hansard_data]
  end

   def render
    ERB.new(@template).result(binding)
  end
end

if ARGV.size == 2
  input_json_file = File.open(ARGV[0], 'r:UTF-8')
  input_template_file = File.open(ARGV[1], 'r:UTF-8')
  stop_words_file = File.open('stopwords.txt', 'r:UTF-8')
    @stopwords        = files[:stop_words].readlines.map(&:chop)
    @hansard          = Hansard.process_json(files[:json_hansard])

  hansard_viz = HansardViz.new(json_hansard: hansard,
                               erb_template: input_template_file,
                               stop_words: stop_words_file)

  puts hansard_viz.render
end

