module Dradis::Plugins::NTOSpider
  class Engine < ::Rails::Engine
    isolate_namespace Dradis::Plugins::NTOSpider

    include ::Dradis::Plugins::Base
    description 'Processes NTOSpider reports'
    provides :upload

    def self.template_names
      { module_parent => { evidence: 'evidence', issue: 'vuln' } }
    end
  end
end
