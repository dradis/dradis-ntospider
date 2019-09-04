module Dradis::Plugins::AppSpider
  class Importer < Dradis::Plugins::Upload::Importer

    BAD_FILENAME_ERROR_MESSAGE = \
      "The uploaded file should be named VulnerabilitiesSummary.xml. "\
      "You'll find VulnerabilitiesSummary.xml inside the /report subdirectory in AppSpider's output."
    NO_VULNSUMMARY_ERROR_MESSAGE = \
      "A proper root element (/VulnSummary) wasn't detected in the uploaded file. "\
      "Ensure the file you uploaded comes from a AppSpider report."
    NO_VULNS_ERROR_MESSAGE = \
      "No vulnerabilities were detected in the uploaded file (/VulnSummary/VulnList/Vuln). "\
      "Ensure the file you uploaded comes from a AppSpider report."

    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})
      file = params.fetch(:file)

      filename = File.basename(file)
      unless filename == "VulnerabilitiesSummary.xml"
        log_error_and_return(BAD_FILENAME_ERROR_MESSAGE)
        return false
      end

      file_content = File.read(file)
      logger.info{'Parsing VulnerabilitiesSummary.xml...'}
      @doc = Nokogiri::XML( file_content )
      if @doc.root && @doc.root.name == 'VulnSummary'
        logger.info{'Done.'}
      else
        log_error_and_return(NO_VULNSUMMARY_ERROR_MESSAGE)
        return false
      end


      if @doc.xpath('/VulnSummary/VulnList/Vuln').empty?
        log_error_and_return(NO_VULNS_ERROR_MESSAGE)
        return false
      end

      @doc.xpath('/VulnSummary/VulnList/Vuln').each do |xml_vuln|
        vuln = ::AppSpider::Vuln.new(xml_vuln)

        host_node_label = xml_vuln.at_xpath('./WebSite').text
        host_node_label = URI.parse(host_node_label).host rescue host_node_label
        host_node = content_service.create_node(label: host_node_label, type: :host)

        plugin_id = vuln.vuln_type
        logger.info{ "\t\t => Creating new issue (plugin_id: #{plugin_id})" }
        issue_text = template_service.process_template(
          template: 'vuln', data: vuln.xml
        )
        issue = content_service.create_issue text: issue_text, id: plugin_id

        logger.info{ "\t\t => Creating new evidence" }
        evidence_content = template_service.process_template(
          template: 'evidence', data: vuln.xml
        )
        content_service.create_evidence(
          issue: issue, node: host_node, content: evidence_content
        )
      end

      true
    end # /import

    private
    def log_error_and_return(message)
      logger.fatal { message }
      content_service.create_note text: "#[Title]#\nAppSpider upload error\n\n#[Description]#\n#{ message }"
    end
  end
end
