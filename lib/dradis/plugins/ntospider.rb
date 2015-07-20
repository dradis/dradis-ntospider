module Dradis
  module Plugins
    module NTOSpider
    end
  end
end

require 'dradis/plugins/ntospider/engine'
require 'dradis/plugins/ntospider/field_processor'
require 'dradis/plugins/ntospider/importer'
require 'dradis/plugins/ntospider/version'


module Dradis
  module Plugins
    module NTOSpider
      # This is required while we transition the Upload Manager to use
      # Dradis::Plugins only
      module Meta
        NAME = "NTOSpider report upload plugin"
        EXPECTS = "NTOSpider report."
        module VERSION
          include Dradis::Plugins::NTOSpider::VERSION
        end
      end
    end
  end
end

