module DPDApi
  class XMLFormatter
    UNAUTHORIZED_CHARACTERS_REGEX = /[^A-Z0-9àâäéèêëîïôöùûüñÀÂÄÉÈÊËÎÏÔÖÙÛÜÑ 2&"#'{}()\[\]|_\\\/Çç^@°=+\-£$¤%μ*<>?,\.;:§!]/i.freeze

    class << self
      def format_attrs(attrs)
        new.format_attrs(attrs)
      end
    end

    def format_attrs(attrs)
      attrs.each do |k, v|
        case v
        when String
          attrs[k] = format_string(v)
        when Date
          attrs[k] = v.to_s
        when Hash
          attrs[k] = format_attrs(v)
        end
      end

      attrs
    end

    private

    def format_string(str)
      encode_unauthorized_chars(
        str.unicode_normalize.encode(xml: :text)
      )
    end

    def encode_unauthorized_chars(str)
      str.gsub(UNAUTHORIZED_CHARACTERS_REGEX) do |v|
        "&##{v.ord};"
      end
    end
  end
end
