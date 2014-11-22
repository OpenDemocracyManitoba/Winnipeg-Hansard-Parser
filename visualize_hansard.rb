require 'json'
require 'erb'
require 'words_counted'
require './hansard.rb'

class HansardViz
  include ERB::Util

  def initialize(options)
    @template = options[:erb_template]
    @hansard = options[:hansard_data]
  end

   def render
    ERB.new(@template).result(binding)
  end
end

def open_file(filename) 
  File.open(filename, 'r:UTF-8')
end

def json_hansard_from_file(filename)
  JSON.parse(open_file(filename).read)
end

def stopwords_from_file(filename)
  open_file(filename).readlines.map(&:chop) 
end

def erb_template_from_file(filename)
  open_file(filename).read
end

if ARGV.size == 2
  json_hansard = json_hansard_from_file(ARGV[0])
  erb_template = erb_template_from_file(ARGV[1])
  stop_words = stopwords_from_file('./stopwords.txt')

  hansard = Hansard.process_json(json_hansard: json_hansard,
                                 stop_words: stop_words)


  hansard_viz = HansardViz.new( erb_template: erb_template,
                                hansard_data: hansard)
  puts hansard_viz.render
end
