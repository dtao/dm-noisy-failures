require File.expand_path("../lib/data_mapper/noisy_failures/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "dm-noisy-failures"
  s.version     = DataMapper::NoisyFailures::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Daniel Tao"]
  s.email       = ["daniel.tao@gmail.com"]
  s.homepage    = "http://github.com/dtao/dm-noisy-failures"
  s.summary     = "Noisy (and descriptive) failures for DataMapper"
  s.description = "This library replaces the default behavior of DataMapper by raising exceptions " +
                  "with descriptive error messages whenever DB operations are not successfully " +
                  "completed."
  s.license     = "MIT"

  s.add_dependency "data_mapper"
  s.add_dependency "dm-core"
  s.add_dependency "dm-validations"
  s.files        = Dir["{lib}/**/*.rb"]
  s.require_path = "lib"
end
