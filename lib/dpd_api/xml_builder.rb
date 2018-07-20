require 'erb'
require 'ostruct'

module DPDApi
  class XMLBuilder < OpenStruct
    attr_reader :request

    def initialize(request, attrs = {})
      @request = request
      @type = type

      formatted_attrs = DPDApi::XMLFormatter.format_attrs(attrs)
      super formatted_attrs
    end

    def build
      build_xml("#{request}.xml.erb")
    end

    private
    attr_reader :type

    def xml_path
      [DPDApi.root_path, 'lib', 'xml']
    end

    def build_xml(file)
      path = File.join(xml_path << file)
      ERB.new(File.read(path)).result(binding)
    end
  end
end
