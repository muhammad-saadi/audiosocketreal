module Api::V1::Docs::ArtistProfilesDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_update_artist_profile do
      api :PATCH, "/v1/artist_profile", "Update status of an audition"
      param :id, :number, desc: 'Id of artist_profile', required: true
      param :cover_image, File,desc: 'Cover image for the artist profile'
      param :banner_image, File, desc: 'banner image for the artist profile'
      param :additional_images, Array, of: File, desc: 'Images for any additional purpose'
      param :bio, String, desc: 'Biography of the artist'
      param :sounds_like, String, desc: "How do artist's sounds looks alike?"
      param :key_facts, String, desc: 'Some key facts about artist'
      param :contact, String, desc: 'Contact info of artist'
      param :social, Array, of: String, desc: 'Social media account links'
    end
  end
end
