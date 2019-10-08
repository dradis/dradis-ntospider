require 'spec_helper'

describe Dradis::Plugins::NTOSpider::Importer do
  before(:each) do
    # Stub template service
    templates_dir = File.expand_path('../../templates', __FILE__)
    expect_any_instance_of(Dradis::Plugins::TemplateService)
    .to receive(:default_templates_dir).and_return(templates_dir)

    # Init services
    plugin = Dradis::Plugins::NTOSpider

    @content_service = Dradis::Plugins::ContentService::Base.new(
      logger: Logger.new(STDOUT),
      plugin: plugin
    )

    @importer = plugin::Importer.new(
      content_service: @content_service,
      plugin: plugin
    )

    # Stub dradis-plugins methods
    #
    # They return their argument hashes as objects mimicking
    # Nodes, Issues, etc
    allow(@content_service).to receive(:create_node) do |args|
      OpenStruct.new(args)
    end
    allow(@content_service).to receive(:create_note) do |args|
      OpenStruct.new(args)
    end
    allow(@content_service).to receive(:create_issue) do |args|
      OpenStruct.new(args)
    end
    allow(@content_service).to receive(:create_evidence) do |args|
      OpenStruct.new(args)
    end
  end

  it 'creates nodes, issues and evidence as needed' do
    # nodes
    expect(@content_service).to receive(:create_node).with(
      hash_including(label: 'www.webscantest.com', type: :host)
    ).exactly(4).times

    # issues
    expect(@content_service).to receive(:create_issue).with(
      hash_including(id: 'Browser Cache directive (web application performance)')
    ).once

    expect(@content_service).to receive(:create_issue).with(
      hash_including(id: 'Predictable Resource Location')
    ).once

    expect(@content_service).to receive(:create_issue).with(
      hash_including(id: 'Content Type Charset Check')
    ).once

    expect(@content_service).to receive(:create_issue).with(
      hash_including(id: 'Collecting Sensitive Personal Information')
    ).once

    # evidence
    expect(@content_service).to receive(:create_evidence) do |args|
      expect(args[:issue].id).to eq('Browser Cache directive (web application performance)')
      expect(args[:node].label).to eq('www.webscantest.com')
    end.once

    expect(@content_service).to receive(:create_evidence) do |args|
      expect(args[:issue].id).to eq('Predictable Resource Location')
      expect(args[:node].label).to eq('www.webscantest.com')
    end.once

    expect(@content_service).to receive(:create_evidence) do |args|
      expect(args[:issue].id).to eq('Content Type Charset Check')
      expect(args[:node].label).to eq('www.webscantest.com')
    end.twice

    expect(@content_service).to receive(:create_evidence) do |args|
      expect(args[:issue].id).to eq('Collecting Sensitive Personal Information')
      expect(args[:node].label).to eq('www.webscantest.com')
    end.exactly(3).times

    @importer.import(file: 'spec/fixtures/files/VulnerabilitiesSummary.xml')
  end
end
