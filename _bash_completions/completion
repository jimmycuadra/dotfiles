#!/usr/bin/env ruby

class Completion
  def initialize(command)
    @command = command
  end

  def matches
    collection.select do |task|
      task[0, typed.length] == typed
    end
  end

  private

  def typed
    @command[/\s(.+?)$/, 1] || ''
  end

  def collection
    # override me
  end
end
