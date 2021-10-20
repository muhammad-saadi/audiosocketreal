module RequestLimitConcern
  extend ActiveSupport::Concern

  module ClassMethods
    def define_request_limits(types: {})
      raise StandardError, 'Type must be a hash' unless types.is_a?(Hash)

      types.each_key do |type|
        limit = types[type]

        has_one "#{type}_limit".to_sym, -> { where(request_type: type) }, class_name: 'RequestLimit', as: :limitable, dependent: :destroy

        define_method "increment_#{type}_usage!" do
          public_send("create_#{type}_limit") if public_send("#{type}_limit").blank?

          public_send("#{type}_limit").increment_usage(max_limit: limit)
        end
      end
    end
  end
end
