module Api::V1::Docs::ArtistsDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_update_profile do
      api :PATCH, "/v1/artists/update_profile", "Update artist profile of current user"
      param :cover_image, File,desc: 'Cover image for the artist profile'
      param :banner_image, File, desc: 'banner image for the artist profile'
      param :additional_images, Array, of: File, desc: 'Images for any additional purpose'
      param :bio, String, desc: 'Biography of the artist'
      param :sounds_like, String, desc: "How do artist's sounds looks alike?"
      param :key_facts, String, desc: 'Some key facts about artist'
      param :social, Array, of: String, desc: 'Social media account links'
      param :contact_information, Hash, desc: 'Contact Information', required: true do
        param :name, String, desc: "Name for contact", required: true
        param :street, String, desc: "Street number", required: true
        param :postal_code, String, desc: "Postal code of area", required: true
        param :city, String, desc: "City", required: true
        param :state, String, desc: "State", required: true
        param :country, String, desc: "Country", required: true
      end
    end

    def_param_group :doc_invite_collaborator do
      api :PATCH, '/v1/artists/invite_collaborator', 'Send invitation email to collaborator'
      param :name, String, desc: "Name of collaborator", required: true
      param :email, String, desc: "Email of collaborator", required: true
      param :agreements, [true, false], desc: "If attach agreements for collaborator", required: true
      param :access, ArtistsCollaborator.accesses.keys, desc: "Access wants to give to collaborator", required: true
    end

    def_param_group :doc_show_profile do
      api :GET, "/v1/artists/show_profile", 'Show artist profile of current user'
    end
  end
end
