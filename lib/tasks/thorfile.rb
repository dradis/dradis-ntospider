class NTOSpiderTasks < Thor
  include Rails.application.config.dradis.thor_helper_module

  namespace "dradis:plugins:appspider"

  desc "upload FILE", "upload APPSpider XML results"
  def upload(file_path)
    require 'config/environment'

    unless File.exists?(file_path)
      $stderr.puts "** the file [#{file_path}] does not exist"
      exit -1
    end

    detect_and_set_project_scope

    importer = Dradis::Plugins::APPSpider::Importer.new(task_options)
    importer.import(file: file_path)
  end
end