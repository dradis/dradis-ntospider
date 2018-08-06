module Dradis::Plugins::APPSpider
  class Engine < ::Rails::Engine
    isolate_namespace Dradis::Plugins::APPSpider

    include ::Dradis::Plugins::Base
    description 'Processes APPSpider reports'
    provides :upload
  end
end
