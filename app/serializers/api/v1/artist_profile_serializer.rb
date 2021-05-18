class Api::V1::ArtistProfileSerializer < ActiveModel::Serializer
  attributes :id, :name, :exclusive, :cover_image, :banner_image, :additional_images, :sounds_like, :bio, :key_facts, :social, :contact

  def cover_image
    object.cover_image.presence && UrlHelpers.rails_blob_url(object.cover_image)
  end

  def banner_image
    object.banner_image.presence && UrlHelpers.rails_blob_url(object.banner_image)
  end

  def additional_images
    object.additional_images.presence && object.additional_images.map{ |image| UrlHelpers.rails_blob_url(image) }
  end
end