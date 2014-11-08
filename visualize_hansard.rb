require 'json'
require 'erb'

class HansardViz
  include ERB::Util

  def initialize(files)
    @hansard          = JSON.parse(files[:json_hansard].read)
    @template         = files[:erb_template].read
    @output_html_file = files[:html_dataviz]
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

handsard_viz = HansardViz.new({ json_hansard: input_json_file,
                      erb_template: input_template_file,
                      html_dataviz: output_html_file })

handsard_viz.save

