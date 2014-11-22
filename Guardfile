# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')  { 'spec' }
  watch('visualize_hansard.rb') { 'spec' }
  watch('hansard.rb') { 'spec' }
  watch('hansard_viz/template.erb') { 'spec' }
end

