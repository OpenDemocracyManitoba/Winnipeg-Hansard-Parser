# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')  { 'spec' }
  watch('hansard_viz/erb_binding.rb') { 'spec' }
  watch('hansard_viz/hansard.rb') { 'spec' }
  watch('hansard_viz/template.erb') { 'spec' }
end

