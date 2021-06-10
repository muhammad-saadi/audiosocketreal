module Api::V1::Docs::Collaborator::ArtistsDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs::Collaborator

    def_param_group :doc_collaborator_show_profile do
      api :GET, "/v1/collaborator/artists/show_profile/", 'Show artist profile of current user'
      param :artist_id, :number, desc: "ID of the artist", required: true
    end

    def_param_group :doc_collaborator_update_profile do
      api :PATCH, "/v1/collaborator/artists/update_profile", "Update artist profile of current user"
      param :artist_id, :number, desc: "ID of the artist", required: true
      param :cover_image, File,desc: 'Cover image for the artist profile'
      param :banner_image, File, desc: 'banner image for the artist profile'
      param :additional_images, Array, of: File, desc: 'Images for any additional purpose'
      param :bio, String, desc: 'Biography of the artist'
      param :sounds_like, String, desc: "How do artist's sounds looks alike?"
      param :key_facts, String, desc: 'Some key facts about artist'
      param :social, Array, of: String, desc: 'Social media account links'
      param :contact_information, Hash, desc: 'Contact Information', required: true do
        param :name, String, desc: "Name for contact", required: true
        param :phone, String, desc: "Phone number", required: true
        param :street, String, desc: "Street number", required: true
        param :postal_code, String, desc: "Postal code of area", required: true
        param :city, String, desc: "City", required: true
        param :state, String, desc: "State", required: true
        param :country, String, desc: "Country", required: true
      end
      param :payment_information, Hash, desc: 'Payment Information', required: true do
        param :payee_name, String, desc: "Name for payee", required: true
        param :routing, String, desc: "Routing", required: true
        param :account_number, String, desc: "Bank account number", required: true
        param :bank_name, String, desc: "Name of bank", required: true
        param :paypal_email, String, desc: "Email adress of paypal", required: true
      end
      param :tax_information, Hash, desc: 'tax Information', required: true do
        param :ssn, String, desc: "Social Security Number", required: true
      end
    end
  end
end
