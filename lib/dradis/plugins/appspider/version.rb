require_relative 'gem_version'

module Dradis::Plugins::AppSpider
  # Returns the version of the currently loaded NTOSpider as a
  # <tt>Gem::Version</tt>.
  def self.version
    gem_version
  end
end
