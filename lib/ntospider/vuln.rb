module NTOSpider
  # This class represents each of the vulnerabilities reported in the
  # NTOSpider VulnerabilitiesSummary.xml file as <Vuln> entities.
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
        :crawl_traffic, :crawl_traffic_template, :crawl_traffic_response,

        # simple tags
        :attack_class, :attack_score, :attack_type, :attack_value, :capec,
        :cwe_id, :description, :dissa_asc, :normalized_url, :oval, :owasp2007,
        :owasp2010, :owasp2013, :recommendation, :vuln_method, :vuln_param,
        :vuln_type, :vuln_url, :web_site
        # nested tags
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

      method_name = TRANSLATIONS_TABLE.fetch(method, method.to_s.camelcase)
      tag = @xml.at_xpath("./#{method_name}")

      # If tag is valid but not present in this Vuln, return nothing:
      return nil unless tag && tag.text.present?

      if TAGS_WITH_HTML_CONTENT.include?(method)
        cleanup_html(tag.text)
      elsif BASE_64_ENCODED_TAGS.include?(method)
        Base64.decode64(tag.text)
      else
        tag.text
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
      result.gsub!(/<br\/?>/, "\n")
      result.gsub!(/<font.*?>(.*?)<\/font>/m, '\1')
      result.gsub!(/<h2>(.*?)<\/h2>/, '*\1*')
      result.gsub!(/<i>(.*?)<\/i>/, '\1')
      result.gsub!(/<p>(.*?)<\/p>/m, '\1')
      result.gsub!(/<pre.*?>(.*?)<\/pre>/m){|m| "\n\nbc.. #{ $1 }\n\np.  \n" }

      result.gsub!(/<\/?ul>/, "\n")
      result.gsub!(/<\/?li>/, "\n")

      result
    end

    # In Ruby we use snake_case; in XML CamelCase is used for some attributes:
    TRANSLATIONS_TABLE = {
      capec:     'CAPEC',
      dissa_asc: 'DISSA_ASC',
      owasp2007: 'OWASP2007',
      owasp2010: 'OWASP2010',
      owasp2013: 'OWASP2013',
      oval:      'OVAL',
      wasc:      'WASC'
    }

    # Some of the values have embedded HTML content that we need to strip
    TAGS_WITH_HTML_CONTENT = [:description, :recommendation]

    # Tags whose value in the XML is base-64 encoded:
    BASE_64_ENCODED_TAGS = [
      :crawl_traffic, :crawl_traffic_template, :crawl_traffic_response
    ]

  end
end
