guard 'rspec' do
  watch("spec/spec_helper.rb") { "spec" }
  watch(%r{^spec/support/(.+)\.rb$}) { "spec" }

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/thebigdb\.rb$}) { "spec" }
  watch(%r{^lib/thebigdb/(.+)\.rb$}) {|m| "spec/#{m[1]}_spec.rb" }
end
