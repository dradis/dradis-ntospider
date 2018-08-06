require_relative 'gem_version'

module Dradis::Plugins::APPSpider
  # Returns the version of the currently loaded APPSpider as a
  # <tt>Gem::Version</tt>.
  def self.version
    gem_version
  end
end
