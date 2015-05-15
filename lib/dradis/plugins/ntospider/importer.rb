module Dradis::Plugins::NTOSpider
  class Importer < Dradis::Plugins::Upload::Importer

    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})
      file_content = File.read( params[:file] )

      logger.info{ 'Parsing NTOSpider report files...' }
      doc = Nokogiri::XML( file_content )
      logger.info{ 'Done.' }

      if doc.root.name != 'VulnSummary'
        error = "Document doesn't seem to be VulnerabilitiesSummary.xml file from NTO"
        logger.fatal{ error }
        content_service.create_note text: error
        return false
      end

      doc.xpath('VulnSummary/VulnList/Vuln').each do |xml_vuln|
        vuln_name = xml_vuln.at('VulnType').text
        vuln_type = xml_vuln.at('AttackClass').text
        logger.info{ "Adding #{ vuln_name } (#{ vuln_type })" }
      end
      return true
    end # /import

  end
end
