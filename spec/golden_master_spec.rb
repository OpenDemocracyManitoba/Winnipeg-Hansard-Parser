require 'spec_helper'

describe ErbBinding do
  before(:all) do
    json_hansard = json_hansard_from_file('./hansard_json/2014-06-25_regular.json')
    erb_template = erb_template_from_file('./hansard_viz/template.erb')
    @golden_master = open_file('./spec/fixtures/2014-06-25_regular.html').read

    hansard = Hansard.new(json_hansard: json_hansard)
    @hansard_viz = ErbBinding.new(erb_template: erb_template,
                                    data_to_bind: hansard)
  end

  it 'should correctly initialize as an ErbTemplater object' do
    expect(@hansard_viz.class).to eq(ErbBinding)
  end

  it 'should correctly render identical text to golden master' do
    expect(@hansard_viz.render).to eq(@golden_master)
  end
end
