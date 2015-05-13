module Dradis::Plugins::NTOSpider
  class FieldProcessor < Dradis::Plugins::Upload::FieldProcessor

    def post_initialize(args={})
      @ntospider_object = ::NTOSpider::Issue.new(data)
    end

    def value(args={})
      field = args[:field]

      # fields in the template are of the form <foo>.<field>, where <foo>
      # is common across all fields for a given template (and meaningless).
      _, name = field.split('.')

      @ntospider_object.try(name) || 'n/a'
    end
  end

end
