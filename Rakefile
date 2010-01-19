require 'rubygems'
require 'rubygems/specification'
require 'rake/gempackagetask'
require 'bundler'
require File.dirname(__FILE__)+'/lib/wesabe'

GEM = "wesabe"
GEM_VERSION = Wesabe::VERSION
AUTHOR = "Brian Donovan"
EMAIL = "brian@wesabe.com"
HOMEPAGE = "https://www.wesabe.com/page/api"
SUMMARY = "Wraps communication with the Wesabe API"
PROJECT = "wesabe"

SPEC = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.markdown", "LICENSE"]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.rubyforge_project = PROJECT

  env = Bundler::Bundle.load.environment
  env.dependencies.each do |dep|
    s.add_dependency(dep.name, dep.version.to_s)
  end

  s.require_path = 'lib'
  # s.bindir = "bin"
  # s.executables = %w( wesabe )
  s.files = %w(LICENSE README.markdown Rakefile) + Dir.glob("{bin,lib,specs}/**/*")
end

Rake::GemPackageTask.new(SPEC) do |pkg|
  pkg.gem_spec = SPEC
end

require 'spec/rake/spectask'
desc "Run specs"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts << %w(-fs --color) << %w(-O spec/spec.opts)
  t.spec_opts << '--loadby' << 'random'
  t.spec_files = Dir["spec/**/*_spec.rb"]
end

desc "Generates the documentation for this project"
task :doc do
  `yardoc 'lib/**/*.rb' 2>/dev/null`
  `open doc/index.html 2>/dev/null`
end

namespace :wesabe do
  desc "Downloads and installs an updated PEM file (requires openssl)"
  task :update_pem do
    # get the certificate
    certs = `echo QUIT | openssl s_client -showcerts -connect www.wesabe.com:443 2>/dev/null`
    pem = certs[/-----BEGIN CERTIFICATE-----(?:.|\n)+?-----END CERTIFICATE-----/, 0]

    # write it to our pem file
    dir  = File.expand_path("~/.wesabe")
    path = File.join(dir, "cacert.pem")
    FileUtils.mkdir_p(dir)
    File.open(path, 'w') do |file|
      file.puts pem
    end
    puts "Wrote PEM file to #{path}"
  end
end

task :default => :spec