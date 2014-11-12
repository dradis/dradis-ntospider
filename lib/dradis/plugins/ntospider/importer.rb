module Dradis::Plugins::NTOSpider
  class Importer < Dradis::Plugins::Upload::Importer

    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})
      file_content    = File.read( params[:file] )

      logger.info{'Parsing Acunetix output file...'}
      @doc = Nokogiri::XML( file_content )
      logger.info{'Done.'}

      if @doc.xpath('/WebAppScan').empty?
        error = "No scan results were detected in the uploaded file (/WebAppScan). Ensure you uploaded an NTOSpider XML report."
        logger.fatal{ error }
        content_service.create_note text: error
        return false
      end

      @doc.xpath('/WebAppScan/FindingList/Finding').each do |xml_finding|
        process_finding(xml_finding)
      end

      return true
    end # /import


    private
    def process_finding(xml_finding)
      # TODO
    end
  end
end