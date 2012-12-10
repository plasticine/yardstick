require 'capybara'

Capybara.run_server = true
Capybara.app_host = "http://0.0.0.0:9999"
Capybara.server_port = 9999

module Yardstick
  class Browser
    include Capybara::DSL

    attr_accessor :measurements

    def initialize(paths)
      @paths = paths
      measure
    end

    private

    def measure
      @measurements = @paths.each do |name, url|
        ChromeDebugger::Client.open do |chrome|
          document = chrome.load_url(url)
          {
            requests:                        document.request_count,
            onload_event:                    document.onload_event,
            dom_content_event:               document.dom_content_event,
            document_payload:                document.encoded_bytes("Document"),
            script_payload:                  document.encoded_bytes("Script"),
            image_payload:                   document.encoded_bytes("Image"),
            stylesheet_payload:              document.encoded_bytes("Stylesheet"),
            other_payload:                   document.encoded_bytes("Other"),
            document_uncompressed_payload:   document.bytes("Document"),
            script_uncompressed_payload:     document.bytes("Script"),
            image_uncompressed_payload:      document.bytes("Image"),
            stylesheet_uncompressed_payload: document.bytes("Stylesheet"),
            other_uncompressed_payload:      document.bytes("Other"),
            script_count:                    document.request_count_by_resource("Script"),
            image_count:                     document.request_count_by_resource("Image"),
            stylesheet_count:                document.request_count_by_resource("Stylesheet")
          }
        end
      end
    end
  end
end
