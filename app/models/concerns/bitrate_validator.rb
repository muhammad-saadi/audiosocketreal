require 'streamio-ffmpeg'

class BitrateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    return unless values.attached?
    return if record.attachment_changes[attribute.to_s].blank?

    metadata = FFMPEG::Movie.new(record.attachment_changes[attribute.to_s].attachable.path).metadata[:streams].first
    return record.errors.add(attribute, 'is not supported') if metadata.blank?

    unless options[:bits].include? metadata[:bits_per_sample]
      record.errors.add(attribute, "bits per sample should be #{options[:bits].map { |bit| "#{bit}-bit" }.join(' or ')}")
    end

    unless options[:sample_rate].include? metadata[:sample_rate].to_i
      record.errors.add(attribute, "sample rate should be #{options[:sample_rate].map { |rate| "#{rate.to_f/1000}k" }.join(' or ') }")
    end
  end
end
