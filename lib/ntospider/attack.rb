module NTOSpider
  # This class represents each of the vulnerabilities reported in the
  # AppSpider VulnerabilitiesSummary.xml file as
  # <AttackList/Attack> entities.
  class Attack
    attr_accessor :xml
    # Accepts an XML node from Nokogiri::XML.
    def initialize(xml_node)
      @xml = xml_node
    end

    # List of supported tags. They can be attributes, simple descendants or
    # collections (e.g. <references/>, <tags/>)
    def supported_tags
      [
        # attributes

        # simple tags
        :attack_config_description, :attack_description, :attack_id,
        :attack_matched_string, :attack_post_params, :attack_user_notes,
        :attack_value, :attack_vuln_url, :original_response_code,
        :original_value,

        # nested tags
        :attack_request, :attack_response, :benign
      ]
    end

    # This allows external callers (and specs) to check for implemented
    # properties
    def respond_to?(method, include_private=false)
      return true if supported_tags.include?(method.to_sym)
      super
    end

    # This method is invoked by Ruby when a method that is not defined in this
    # instance is called.
    #
    # In our case we inspect the @method@ parameter and try to find the
    # attribute, simple descendent or collection that it maps to in the XML
    # tree.
    def method_missing(method, *args)
      # We could remove this check and return nil for any non-recognized tag.
      # The problem would be that it would make tricky to debug problems with
      # typos. For instance: <>.potr would return nil instead of raising an
      # exception
      unless supported_tags.include?(method)
        super
        return
      end

      # First we try the attributes. In Ruby we use snake_case, but in XML
      # CamelCase is used for some attributes
      translations_table = {
         attack_request: 'AttackRequestList/AttackRequest/Request',
        attack_response: 'AttackRequestList/AttackRequest/Response',
                 benign: 'AttackRequestList/AttackRequest/Benign'
      }

      method_name = translations_table.fetch(method, method.to_s.camelcase)

      # no attributes in the <attack> node
      # return @xml.attributes[method_name].value if @xml.attributes.key?(method_name)

      # Then we try simple children tags: name, type, ...
      tag = @xml.at_xpath("./#{method_name}")
      if tag && !tag.text.blank?
        return tag.text
      else
        # nothing found, the tag is valid but not present in this Attack
        return nil
      end
    end
  end
end
