# Model.attributes した際に出力されるvalueがstringであった場合
# scrubメソッドを通し、不正なバイト文字列が出力されるのを防ぐ
module AttributeScrubbable
  extend ActiveSupport::Concern

  module ClassMethods
    def scrub_attributes(*scrub_attrs)
      scrub_attrs.each do |at|
        define_method(at) do
          self.attributes[at.to_s]
        end
      end
    end
  end

  included do
    alias_method :original_attributes, :attributes

    def attributes
      original_attributes.each_with_object({}) do |(k, v), new_attributes|
        if v.is_a?(String)
          new_attributes[k] = v.scrub
        else
          new_attributes[k] = v
        end
      end
    end
  end
end
