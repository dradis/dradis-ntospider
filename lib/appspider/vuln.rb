module AppSpider
  # This class represents each of the vulnerabilities reported in the
  # AppSpider VulnerabilitiesSummary.xml file as <Vuln> entities.
  #
  # It provides a convenient way to access the information scattered all over
  # the XML entities.
  #
  # Instead of providing separate methods for each supported property we rely
  # on Ruby's #method_missing to do most of the work.
  class Vuln
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
        :attack_class, :attack_score, :attack_type, :capec,
        :cwe_id, :description, :dissa_asc, :normalized_url, :oval, :owasp2007,
        :owasp2010, :owasp2013, :owasp2017, :recommendation, :vuln_method, :vuln_param,
        :vuln_type, :vuln_url, :web_site, :web_site_ip, :html_entity_attacked, :page, :url, 
        :vuln_param_type, :wasc, :scan_date, :statistically_prevalent_original_response_code, 
        :confidence,  
        # nested tags
        :attack_value, :attack_vuln_url, :attack_post_params, :attack_matched_string,
        :attack_description, :attack_config_description, :benign, :attack_request, :attack_response, 
        :pcre_regex_bl, :mod_security_bl, :snort_bl, :imperva_bl, 
        :pcre_regex_wl, :mod_security_wl, :snort_wl, :imperva_wl
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
        web_site:  'WebSite',
      	web_site_ip:	'WebSiteIP',
      	html_entity_attacked:	'HtmlEntityAttacked',
      	scan_date:	'ScanDate',
      	statistically_prevalent_original_response_code:	'StatisticallyPrevalentOriginalResponseCode',
        capec:     'CAPEC',
        dissa_asc: 'DISSA_ASC',
        owasp2007: 'OWASP2007',
        owasp2010: 'OWASP2010',
        owasp2013: 'OWASP2013',
        owasp2017: 'OWASP2017',
        oval:      'OVAL',
        wasc:      'WASC',
        attack_value:          'AttackValue',
        attack_vuln_url:       'AttackVulnUrl', 
        attack_post_params:    'AttackPostParams', 
        attack_description:			'AttackDescription',
        attack_config_description:	'AttackConfigDescription',
        attack_matched_string: 'AttackMatchedString',
        original_value:					'OriginalValue',
        attack_request:        'AttackRequestList/AttackRequest/Request', 
        attack_response:       'AttackRequestList/AttackRequest/Response',
        benign:									'AttackRequestList/AttackRequest/Benign',
        pcre_regex_bl:					'DefenseBL/PcreRegex',
        mod_security_bl:				'DefenseBL/ModSecurity',
        snort_bl:								'DefenseBL/Snort',
        imperva_bl:							'DefenseBL/Imperva',
        pcre_regex_wl:					'DefenseWL/PcreRegex',
        mod_security_wl:				'DefenseWL/ModSecurity',
        snort_wl:								'DefenseWL/Snort',
        imperva_wl:							'DefenseWL/Imperva'
      }

      method_name = translations_table.fetch(method, method.to_s.camelcase)

      # no attributes in the <issue> node
      # return @xml.attributes[method_name].value if @xml.attributes.key?(method_name)

      # Then we try simple children tags: name, type, ...
      tag = @xml.at_xpath("./#{method_name}")
      if tag && !tag.text.blank?
        if tags_with_html_content.include?(method)
          return cleanup_html(tag.text)
        else
          return tag.text
        end
      else
        # nothing found, the tag is valid but not present in this Vuln
        return nil
      end
    end

    private

    def cleanup_html(source)
      result = source.dup
      result.gsub!(/&quot;/, '"')
      result.gsub!(/&amp;/, '&')
      result.gsub!(/&lt;/, '<')
      result.gsub!(/&gt;/, '>')

      result.gsub!(/<b>(.*?)<\/b>/, '*\1*')
      result.gsub!(/<br\/>/, "\n")
      result.gsub!(/<br>/, "\n")
      result.gsub!(/<font.*?>(.*?)<\/font>/m, '\1')
      result.gsub!(/<h2>(.*?)<\/h2>/, '*\1*')
      result.gsub!(/<i>(.*?)<\/i>/, '\1')
      result.gsub!(/<p>(.*?)<\/p>/m, '\1')
      result.gsub!(/<pre.*?>(.*?)<\/pre>/m){|m| "\n\nbc.. #{ $1 }\n\np.  \n" }

      result.gsub!(/<ul>/, "\n")
      result.gsub!(/<\/ul>/, "\n")
      result.gsub!(/<li>/, "\n* ")
      result.gsub!(/<\/li>/, "\n")

      result
    end

    # Some of the values have embedded HTML content that we need to strip
    def tags_with_html_content
      [:description, :recommendation]
    end

  end
end
