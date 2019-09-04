module Dradis::Plugins::AppSpider
  class Engine < ::Rails::Engine
    isolate_namespace Dradis::Plugins::AppSpider

    include ::Dradis::Plugins::Base
    description 'Processes AppSpider reports'
    provides :upload
  end
end
