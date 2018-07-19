module DPDApi
  class DPDError < StandardError
    attr_accessor :body, :attrs, :status_code, :status_text

    def initialize message, **args
      raise ArgumentError 'DPD error must be initialized with a hash' unless args.is_a? Hash
      raise ArgumentError 'Error must contain some information' unless args.any?

      @body ||= args[:body]
      @attrs ||= args[:attrs]
      @status_code ||= args[:status_code]
      @status_text ||= args[:status_text]

      super(message)
    end
  end
end
