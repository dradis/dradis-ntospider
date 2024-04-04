module Dradis::Plugins::NTOSpider
  module Mapping
    DEFAULT_MAPPING = {
      evidence: {
        'URL' => '{{ ntospider[evidence.attack_vuln_url] }}',
        'Param' => '{{ ntospider[evidence.attack_post_params] }}',
        'String' => '{{ ntospider[evidence.attack_matched_string] }}',
        'Request' => '{{ ntospider[evidence.attack_request] }}',
        'Response' => '{{ ntospider[evidence.attack_response] }}'
      },
      vuln: {
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
    }.freeze

    SOURCE_FIELDS = {
      evidence: [
        'evidence.attack_config_description',
        'evidence.attack_description',
        'evidence.attack_id',
        'evidence.attack_matched_string',
        'evidence.attack_post_params',
        'evidence.attack_request',
        'evidence.attack_response',
        'evidence.attack_user_notes',
        'evidence.attack_value',
        'evidence.attack_vuln_url',
        'evidence.benign',
        'evidence.original_value',
        'evidence.original_response_code'
      ],
      vuln: [
        'vuln.attack_class',
        'vuln.attack_score',
        'vuln.attack_type',
        'vuln.attack_value',
        'vuln.capec',
        'vuln.confidence',
        'vuln.cwe_id',
        'vuln.description',
        'vuln.dissa_asc',
        'vuln.html_entity_attacked',
        'vuln.imperva_bl',
        'vuln.imperva_wl',
        'vuln.mod_security_bl',
        'vuln.mod_security_wl',
        'vuln.normalized_url',
        'vuln.oval',
        'vuln.owasp2007',
        'vuln.owasp2010',
        'vuln.owasp2013',
        'vuln.owasp2017',
        'vuln.pcre_regex_bl',
        'vuln.pcre_regex_wl',
        'vuln.recommendation',
        'vuln.scan_date',
        'vuln.snort_bl',
        'vuln.snort_wl',
        'vuln.statistically_prevalent_original_response_code',
        'vuln.vuln_method',
        'vuln.vuln_param',
        'vuln.vuln_type',
        'vuln.vuln_url',
        'vuln.wasc'
      ]
    }.freeze
  end
end
