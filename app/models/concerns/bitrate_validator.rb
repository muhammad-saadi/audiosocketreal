require 'streamio-ffmpeg'

class BitrateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    return unless values.attached?
    return if record.attachment_changes[attribute.to_s].blank?

    metadata = FFMPEG::Movie.new(record.attachment_changes[attribute.to_s].attachable.path).metadata[:streams][0]
    unless options[:bits].include? metadata[:bits_per_sample]
      record.errors.add(attribute, "bits per sample should be #{options[:bits].map { |bit| "#{bit}-bit" }.join(' or ')}")
    end

    unless options[:sample_rate] == metadata[:sample_rate].to_i
      record.errors.add(attribute, "sample rate should be #{options[:sample_rate] / 1000}k")
    end
  end
end
