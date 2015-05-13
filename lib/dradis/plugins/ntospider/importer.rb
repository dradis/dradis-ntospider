module Dradis::Plugins::NTOSpider
  class Importer < Dradis::Plugins::Upload::Importer

    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})
      file_content    = File.read( params[:file] )

      logger.info{'Parsing NTOSpider report files...'}

      logger.info{'Done.'}

      return true
    end # /import

  end
end
