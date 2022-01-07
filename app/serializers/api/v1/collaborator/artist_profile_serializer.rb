class Api::V1::Collaborator::ArtistProfileSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :exclusive, :profile_image, :banner_image, :additional_images, :country, :pro,
             :ipi, :sounds_like, :bio, :key_facts, :social, :website_link, :profile_image_status, :banner_image_status

  has_many :genres
  has_one :contact_information, serializer: Api::V1::ContactInformationSerializer

  def profile_image
    object.profile_image.presence && UrlHelpers.rails_blob_url(object.profile_image)
  end

  def banner_image
    object.banner_image.presence && UrlHelpers.rails_blob_url(object.banner_image)
  end

  def additional_images
    object.additional_images.map{ |image| UrlHelpers.rails_blob_url(image) }
  end
end
