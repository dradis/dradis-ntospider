require_relative 'gem_version'

module Dradis::Plugins::Appspider
  # Returns the version of the currently loaded Appspider as a
  # <tt>Gem::Version</tt>.
  def self.version
    gem_version
  end
end
