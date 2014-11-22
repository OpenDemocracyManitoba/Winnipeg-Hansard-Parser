require 'spec_helper'

describe HansardViz do
  before(:all) do
    json_hansard = json_hansard_from_file('./hansard_json/2014-06-25_regular.json')
    erb_template = erb_template_from_file('./hansard_viz/template.erb')
    @golden_master = open_file('./spec/fixtures/2014-06-25_regular.html').read

    hansard = Hansard.process_json(json_hansard: json_hansard)
    @hansard_viz = HansardViz.new( erb_template: erb_template,
                                   hansard_data: hansard)
  end

  it 'should correctly initialize as a HansardViz object' do
    expect(@hansard_viz.class).to eq(HansardViz)
  end

  it 'should correctly render identical text to golden master' do
    expect(@hansard_viz.render).to eq(@golden_master)
  end
end
