Gem::Specification.new do |s|
  s.name = %q{wesabe}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Donovan"]
  s.date = %q{2008-08-04}
  s.description = %q{Wraps communication with the Wesabe API}
  s.email = %q{brian@wesabe.com}
  s.extra_rdoc_files = ["README.markdown", "LICENSE"]
  s.files = ["LICENSE", "README.markdown", "Rakefile", "lib/wesabe.rb"]
  s.has_rdoc = true
  s.homepage = %q{https://www.wesabe.com/page/api/examples}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{wesabe}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Wraps communication with the Wesabe API}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
