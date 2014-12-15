require 'rubygems'
require 'fileutils'
require 'rake/testtask'
require 'rubygems/package_task'

task :default => :test

Rake::TestTask.new("test") do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.warning = true
  t.verbose = true
end

spec = Gem::Specification.new do |s| 
  s.name = "logue"
  s.version = "1.0.2"
  s.author = "Jeff Pace"
  s.email = "jeugenepace@gmail.com"
  s.homepage = "http://jeugenepace.github.com/logue"
  s.platform = Gem::Platform::RUBY
  s.summary = "A minimalist logging module."
  s.description = "A module that adds logging/trace functionality."
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.require_path = "lib"
  s.test_files = FileList["{test}/**/*test.rb"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = [ "README.md" ]
  s.license = 'MIT'

  s.add_dependency "rainbow", ">= 2.0.0"
end
 
Gem::PackageTask.new(spec) do |pkg| 
  pkg.need_zip = true 
  pkg.need_tar_gz = true 
end 
