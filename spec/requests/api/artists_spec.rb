require 'swagger_helper'

RSpec.describe 'api/artists', type: :request do
  path '/api/v1/artists/update_profile' do
    patch 'Update artist profile of current user' do
      tags 'Artists'

      parameter name: :email, in: :formData, type: :string
      parameter name: :profile_image, in: :formData, type: :file
      parameter name: :banner_image, in: :formData, type: :file
      parameter name: :'additional_images[]', in: :formData, type: :file
      parameter name: :bio, in: :formData, type: :string
      parameter name: :key_facts, in: :formData, type: :string
      parameter name: :country, in: :formData, type: :string
      parameter name: :sounds_like, in: :formData, type: :string
      parameter name: :social, in: :formData, type: :string
      parameter name: :website_link, in: :formData, type: :string
      parameter name: :'genre_ids[]', in: :formData, type: :string
      parameter name: :'contact_information[name]', in: :formData, type: :string
      parameter name: :'contact_information[phone]', in: :formData, type: :string
      parameter name: :'contact_information[email]', in: :formData, type: :string
      parameter name: :'contact_information[street]', in: :formData, type: :string
      parameter name: :'contact_information[postal_code]', in: :formData, type: :string
      parameter name: :'contact_information[city]', in: :formData, type: :string
      parameter name: :'contact_information[state]', in: :formData, type: :string
      parameter name: :'contact_information[country]', in: :formData, type: :string
      parameter name: :'payment_information[payee_name]', in: :formData, type: :string
      parameter name: :'payment_information[routing]', in: :formData, type: :string
      parameter name: :'payment_information[account_number]', in: :formData, type: :string
      parameter name: :'payment_information[bank_name]', in: :formData, type: :string
      parameter name: :'payment_information[paypal_email]', in: :formData, type: :string
      parameter name: :'tax_information[ssn]', in: :formData, type: :string


      security [{ api_auth: [] }, { user_auth: [] }]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'ArtistProfile Updated' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 email: { type: :string },
                 country: { type: :string },
                 exclusive: { type: :string },
                 profile_image: { type: :string },
                 banner_image: { type: :string },
                 additional_images: { type: :array, items: { type: :string } },
                 bio: { type: :string },
                 key_facts: { type: :string },
                 sounds_like: { type: :string },
                 website_link: { type: :string },
                 profile_image_status: { type: :string },
                 banner_image_status: { type: :string },
                 social: {
                   type: :array,
                   items: {
                     type: :string
                   }
                 },
                 genres: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string }
                     }
                   }
                 },
                 contact_information: {
                   type: :object,
                   properties: {
                     name: { type: :string },
                     phone: { type: :string },
                     email: { type: :string },
                     street: { type: :string },
                     postal_code: { type: :string },
                     city: { type: :string },
                     state: { type: :string },
                     country: { type: :string }
                   }
                 },
                 payment_information: {
                   type: :object,
                   properties: {
                     payee_name: { type: :string },
                     routing: { type: :string },
                     account_number: { type: :string },
                     bank_name: { type: :string },
                     paypal_email: { type: :string }
                   }
                 },
                 tax_information: {
                   type: :object,
                   properties: {
                     ssn: { type: :string }
                   }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/artists/show_profile' do
    get 'Show artist profile of current user' do
      tags 'Artists'


      security [{ api_auth: [] }, { user_auth: [] }]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'Artist Profile' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 email: { type: :string },
                 country: { type: :string },
                 exclusive: { type: :string },
                 profile_image: { type: :string },
                 banner_image: { type: :string },
                 additional_images: { type: :array, items: { type: :string } },
                 bio: { type: :string },
                 key_facts: { type: :string },
                 sounds_like: { type: :string },
                 website_link: { type: :string },
                 profile_image_status: { type: :string },
                 banner_image_status: { type: :string },
                 social: {
                   type: :array,
                   items: {
                     type: :string
                   }
                 },
                 genres: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string }
                     }
                   }
                 },
                 contact_information: {
                   type: :object,
                   properties: {
                     name: { type: :string },
                     phone: { type: :string },
                     email: { type: :string },
                     street: { type: :string },
                     postal_code: { type: :string },
                     city: { type: :string },
                     state: { type: :string },
                     country: { type: :string }
                   }
                 },
                 payment_information: {
                   type: :object,
                   properties: {
                     payee_name: { type: :string },
                     routing: { type: :string },
                     account_number: { type: :string },
                     bank_name: { type: :string },
                     paypal_email: { type: :string }
                   }
                 },
                 tax_information: {
                   type: :object,
                   properties: {
                     ssn: { type: :string }
                   }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/artists/invite_collaborator' do
    patch 'Invite collaborator' do
      tags 'Artists'

      parameter name: :name, in: :formData, type: :string
      parameter name: :email, in: :formData, type: :string
      parameter name: :access, in: :formData, type: :string
      parameter name: :'collaborator_profile_attributes[pro]', in: :formData, type: :string
      parameter name: :'collaborator_profile_attributes[ipi]', in: :formData, type: :string
      parameter name: :'collaborator_profile_attributes[different_registered_name]', in: :formData, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'Invitation sent' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   first_name: { type: :string },
                   last_name: { type: :string },
                   email: { type: :string },
                   access: { type: :string },
                   status: { type: :string }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/artists/resend_collaborator_invitation' do
    patch 'Re-invite collaborator' do
      tags 'Artists'

      parameter name: :artists_collaborator_id, in: :formData, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'Invitation re-sent' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   first_name: { type: :string },
                   last_name: { type: :string },
                   email: { type: :string },
                   access: { type: :string },
                   status: { type: :string }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/artists/collaborators' do
    get 'List collaborators of current user' do
      tags 'Artists'

      parameter name: :page, in: :query, type: :string
      parameter name: :per_page, in: :query, type: :string
      parameter name: :pagination, in: :query, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'Collaborators List' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   first_name: { type: :string },
                   last_name: { type: :string },
                   email: { type: :string },
                   access: { type: :string },
                   status: { type: :string }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/artists' do
    get 'List artists of current user' do
      tags 'Artists'

      parameter name: :page, in: :query, type: :string
      parameter name: :per_page, in: :query, type: :string
      parameter name: :pagination, in: :query, type: :string
      parameter name: :access, in: :query, type: :string
      parameter name: :search_key, in: :formData, type: :string
      parameter name: :search_query, in: :formData, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'Artists List' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   email: { type: :string },
                   first_name: { type: :string },
                   last_name: { type: :string },
                   agreements: { type: :boolean },
                   access: { type: :string },
                   status: { type: :string }
                 }
               }

        run_test!
      end
    end
  end
end
