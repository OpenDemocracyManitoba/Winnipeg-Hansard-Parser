require 'spec_helper'

describe HansardViz do
  before(:all) do
    input_json_file = File.open('./hansard_json/2014-06-25_regular.json', 'r:UTF-8')
    input_template_file = File.open('./hansard_viz/template.erb', 'r:UTF-8')
    stop_words_file = File.open('./stopwords.txt', 'r:UTF-8')
    @golden_master = File.open('./spec/fixtures/2014-06-25_regular.html').read

    @hansard_viz = HansardViz.new({ json_hansard: input_json_file,
                          erb_template: input_template_file,
                          stop_words: stop_words_file })
  end

  it 'should correctly initialize as a HansardViz object' do
    expect(@hansard_viz.class).to eq(HansardViz)
  end

  it 'should correctly render identical text to golden master' do
    expect(@hansard_viz.render).to eq(@golden_master)
  end
end
