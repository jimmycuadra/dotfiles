#!/usr/bin/env ruby

if defined?(Bundler)
  Gem.post_reset_hooks.reject! do |hook|
    hook.source_location.first =~ %r{/bundler/}
  end

  Gem::Specification.reset
  load "rubygems/custom_require.rb"
end

begin
  require "pry"
rescue LoadError
end

if defined?(Pry)
  Pry.start
  exit
end
