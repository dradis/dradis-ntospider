module Dradis::Plugins::NTOSpider
  class Importer < Dradis::Plugins::Upload::Importer

    NO_VULNS_ERROR_MESSAGE = \
      "No vulnerabilities were detected in the uploaded file (/VulnSummary/VulnList/Vuln). "\
      "Ensure you uploaded a NTOSpider report."

    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})
      path = params.fetch(:path)

      logger.info{'Locating VulnerabilitiesSummary.xml in NTOSpider report files...'}
      begin
        file_content = File.read(File.join(path, "VulnerabilitiesSummary.xml"))
      rescue
        logger.fatal{ "Couldn't find VulnerabilitiesSummary.xml in #{ path }" }
        return false
      end
      logger.info{'Done.'}

      logger.info{'Parsing VulnerabilitiesSummary.xml...'}
      @doc = Nokogiri::XML( file_content )
      logger.info{'Done.'}

      host_node = content_service.create_node(label: @doc.at_xpath('/VulnSummary/ScanName').text, type: :host)

      if @doc.xpath('/VulnSummary/VulnList/Vuln').empty?
        logger.fatal{ NO_VULNS_ERROR_MESSAGE }
        content_service.create_note text: NO_VULNS_ERROR_MESSAGE, node: host_node
        return false
      end

      @doc.xpath('/VulnSummary/VulnList/Vuln').each do |xml_vuln|
        vuln = ::NTOSpider::Vuln.new(xml_vuln)
        plugin_id = vuln.vuln_type
        logger.info{ "\t\t => Creating new issue (plugin_id: #{plugin_id})" }
        issue_text = template_service.process_template(
          template: 'vuln', data: vuln.xml
        )
        issue = content_service.create_issue text: issue_text, id: plugin_id

        logger.info{ "\t\t => Creating new evidence" }
        evidence_content = template_service.process_template(
          template: 'evidence', data: xml_vuln
        )
        content_service.create_evidence(
          issue: issue, node: host_node, content: evidence_content
        )
      end

      true
    end # /import
  end
end
