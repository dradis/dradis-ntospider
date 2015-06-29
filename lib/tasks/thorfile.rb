class NTOSpiderTasks < Thor
  include Core::Pro::ProjectScopedTask if defined?(::Core::Pro)

  namespace "dradis:plugins:ntospider"

  desc "upload REPORT_PATH", "upload NTOSpider XML results"
  def upload(report_path)
    require 'config/environment'

    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG

    unless File.exists?(report_path)
      $stderr.puts "** the file [#{report_path}] does not exist"
      exit -1
    end

    content_service = nil
    template_service = nil
    if defined?(Dradis::Pro)
      detect_and_set_project_scope
      content_service = Dradis::Pro::Plugins::ContentService.new(plugin: Dradis::Plugins::NTOSpider)
      template_service = Dradis::Pro::Plugins::TemplateService.new(plugin: Dradis::Plugins::NTOSpider)
    else
      content_service = Dradis::Plugins::ContentService.new(plugin: Dradis::Plugins::NTOSpider)
      template_service = Dradis::Plugins::TemplateService.new(plugin: Dradis::Plugins::NTOSpider)
    end

    importer = Dradis::Plugins::NTOSpider::Importer.new(
      logger: logger,
      content_service: content_service,
      template_service: template_service
    )

    importer.import(path: report_path)

    logger.close
  end
end
