module Dradis::Plugins::NTOSpider
  module Mapping
    def self.default_mapping
      {
        'evidence' => {
          'URL' => '{{ ntospider[evidence.attack_vuln_url] }}',
          'Param' => '{{ ntospider[evidence.attack_post_params] }}',
          'String' => '{{ ntospider[evidence.attack_matched_string] }}',
          'Request' => '{{ ntospider[evidence.attack_request] }}',
          'Response' => '{{ ntospider[evidence.attack_response] }}'
        },
        'vuln' => {
          'Title' => '{{ ntospider[vuln.vuln_type] }}',
          'Attack Class' => '{{ ntospider[vuln.attack_class] }}',
          'Attack Type' => '{{ ntospider[vuln.attack_type] }}',
          'Attack Score' => '{{ ntospider[vuln.attack_score] }}',
          'Attack Value' => '{{ ntospider[vuln.attack_value] }}',
          'Method' => '{{ ntospider[vuln.vuln_method] }}',
          'Description' => '{{ ntospider[vuln.description] }}',
          'Recommendation' => '{{ ntospider[vuln.recommendation] }}',
          'CweId' => '{{ ntospider[vuln.cwe_id] }}',
          'CAPEC' => '{{ ntospider[vuln.capec] }}',
          'DISSA_ASC' => '{{ ntospider[vuln.dissa_asc] }}',
          'OWASP2010' => '{{ ntospider[vuln.owasp2010] }}',
          'OWASP2013' => '{{ ntospider[vuln.owasp2013] }}',
          'OWASP2017' => '{{ ntospider[vuln.owasp2017] }}',
          'OVAL' => '{{ ntospider[vuln.oval] }}'
        }
      }
    end
  end
end
