class BlobValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    return unless values.attached?
    return if record.attachment_changes[attribute.to_s].blank?

    Array(values).each do |value|
      record.errors.add(attribute, 'has invalid content type') unless valid_content_type?(value.blob)
      next if options[:size_range].blank?

      if options[:size_range].min > value.blob.byte_size
        record.errors.add(attribute, :min_size_error, min_size: ActiveSupport::NumberHelper.number_to_human_size(options[:size_range].min))
      elsif options[:size_range].max < value.blob.byte_size
        record.errors.add(attribute, :max_size_error, max_size: ActiveSupport::NumberHelper.number_to_human_size(options[:size_range].max))
      end
    end
  end

  private

  def valid_content_type?(blob)
    return true if options[:content_type].nil?

    case options[:content_type]
    when Regexp
      options[:content_type].match?(blob.content_type)
    when Array
      options[:content_type].include?(blob.content_type)
    when Symbol
      blob.public_send("#{options[:content_type]}?")
    else
      options[:content_type] == blob.content_type
    end
  end
end
