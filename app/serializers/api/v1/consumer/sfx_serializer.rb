class Api::V1::Consumer::SfxSerializer < ActiveModel::Serializer

  attributes :id, :title, :wav_file, :aiff_file, :mp3_file, :description, :keyword, :duration, :created_at

  has_many :filters, serializer: Api::V1::FilterSerializer

  def wav_file
    object.wav_file.presence && UrlHelpers.rails_blob_url(object.wav_file)
  end

   def aiff_file
    object.aiff_file.presence && UrlHelpers.rails_blob_url(object.aiff_file)
  end

  def mp3_file
    object.mp3_file.presence && UrlHelpers.rails_blob_url(object.mp3_file)
  end

  def created_at
    object.formatted_created_at
  end
end
