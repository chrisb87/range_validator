# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = "range_validator"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Baker"]
  s.date = "2011-02-24"
  s.description = %q{Active Model Range Validator. 
      Supports validating that active model fields are valid ranges that do or do
      not overlap with other ranges.}
  s.email = "baker.chris.3@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "Gemfile",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "lib/range_validator.rb",
    "locales/en.yml",
    "range_validator.gemspec",
    "spec/range_validator_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/chrisb87/range_validator"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.5.2"
  s.summary = "Active Model Range Validator"
  s.test_files = [
    "spec/range_validator_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activemodel>, [">= 3.0.0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_development_dependency(%q<rspec>, [">= 2.5.0"])
      s.add_development_dependency(%q<ruby-debug>, [">= 0"])
    else
      s.add_dependency(%q<activemodel>, [">= 3.0.0"])
      s.add_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_dependency(%q<rspec>, [">= 2.5.0"])
      s.add_dependency(%q<ruby-debug>, [">= 0"])
    end
  else
    s.add_dependency(%q<activemodel>, [">= 3.0.0"])
    s.add_dependency(%q<activesupport>, [">= 3.0.0"])
    s.add_dependency(%q<rspec>, [">= 2.5.0"])
    s.add_dependency(%q<ruby-debug>, [">= 0"])
  end
end

