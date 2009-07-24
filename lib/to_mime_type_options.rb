# ToMimeTypeOptions
module ToMimeTypeOptions
  mattr_accessor :mime_types
  @mime_types = %w(xml json)

  def self.included(base)
    @mime_types.each do |type|
      base.class_eval <<-EndEval
        def to_#{type}_with_mime_type_options(options = {})
          to_#{type}_without_mime_type_options(self.class.get_to_#{type}_options.merge(options))
        end

        def self.to_#{type}_options(options)
          write_inheritable_attribute :to_#{type}_options, options
        end

        def self.get_to_#{type}_options
          read_inheritable_attribute :to_#{type}_options
        end
      EndEval
      base.alias_method_chain "to_#{type}".to_sym, :mime_type_options
    end
  end
end
