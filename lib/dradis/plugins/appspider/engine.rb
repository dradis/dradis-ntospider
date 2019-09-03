module Dradis::Plugins::Appspider
  class Engine < ::Rails::Engine
    isolate_namespace Dradis::Plugins::Appspider

    include ::Dradis::Plugins::Base
    description 'Processes APPSpider reports'
    provides :upload
  end
end
