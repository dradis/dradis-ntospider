module Dradis::Plugins::AppSpider
  class Engine < ::Rails::Engine
    isolate_namespace Dradis::Plugins::NTOSpider

    include ::Dradis::Plugins::Base
    description 'Processes AppSpider reports'
    provides :upload
  end
end
