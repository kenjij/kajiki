require 'kajiki/optimist'
require 'kajiki/presets'
require 'kajiki/runner'

module Kajiki

  def self.run(opts, &block)
    Runner.run(opts, &block)
  end

end
