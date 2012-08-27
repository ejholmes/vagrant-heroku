#!/usr/bin/env rake
require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = 'test/**/*_test.rb'
end

task :default => :test

require File.expand_path('../environment', __FILE__)

desc "Build the box"
task :build do
  Environment.box.build("auto" => true, "force" => true)
end
