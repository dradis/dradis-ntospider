module Dradis::Plugins::NTOSpider
  class FieldProcessor < Dradis::Plugins::Upload::FieldProcessor

    def post_initialize(args={})
      if data.name == 'Vuln'
        @nto_object = ::NTOSpider::Vuln.new(data)
      else
        @nto_object = ::NTOSpider::Attack.new(data)
      end
    end

    def value(args={})
      field = args[:field]

      # fields in the template are of the form <foo>.<field>, where <foo>
      # is common across all fields for a given template (and meaningless).
      _, name = field.split('.')

      # The XML uses a <Method> entity, but 'method' is a reserved word here so:
      name = 'vuln_method' if name == 'method'

      @nto_object.try(name) || 'n/a'
    end
  end

end
