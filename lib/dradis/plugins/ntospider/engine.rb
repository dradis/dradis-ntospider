module Dradis::Plugins::NTOSpider
  class Engine < ::Rails::Engine
    isolate_namespace Dradis::Plugins::NTOSpider

    include ::Dradis::Plugins::Base
    description 'Processes NTOSpider reports'
    provides :upload
  end
end
