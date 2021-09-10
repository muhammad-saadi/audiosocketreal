require 'swagger_helper'

RSpec.describe 'api/consumer/consumers', type: :request do
  path '/api/v1/consumer/consumers/show_profile' do
    get 'Get' do
      tags 'Consumers'
      produces 'application/json'

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Consumer Profile' do
        schema type: :object,
               properties: {
                 fisrt_name: { type: :string },
                 last_name: { type: :string },
                 email_name: { type: :string },
                 content_type: { type: :string },
                 consumer_profile: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     phone: { type: :string },
                     organization: { type: :string },
                     address: { type: :string },
                     city: { type: :string },
                     country: { type: :string },
                     postal_code: { type: :string },
                     youtube_url: { type: :string },
                     white_listing_enabled: { type: :string }
                   }
                 }
               }
        run_test!
      end
    end
  end

  path '/api/v1/consumer/consumers/update_email' do
    patch 'Update email address' do
      tags 'Consumers'

      parameter name: :email, in: :formData, type: :string
      parameter name: :current_password, in: :formData, type: :string

      produces 'application/json'

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Email updated' do
        schema type: :object,
               properties: {
                 fisrt_name: { type: :string },
                 last_name: { type: :string },
                 email_name: { type: :string },
                 content_type: { type: :string },
                 consumer_profile: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     phone: { type: :string },
                     organization: { type: :string },
                     address: { type: :string },
                     city: { type: :string },
                     country: { type: :string },
                     postal_code: { type: :string },
                     youtube_url: { type: :string },
                     white_listing_enabled: { type: :string }
                   }
                 }
               }
        run_test!
      end
    end
  end

  path '/api/v1/consumer/consumers/update_password' do
    patch 'Update password' do
      tags 'Consumers'

      parameter name: :current_password, in: :formData, type: :string
      parameter name: :password, in: :formData, type: :string
      parameter name: :password_confirmation, in: :formData, type: :string

      produces 'application/json'

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Password updated' do
        schema type: :object,
               properties: {
                 fisrt_name: { type: :string },
                 last_name: { type: :string },
                 email_name: { type: :string },
                 content_type: { type: :string },
                 consumer_profile: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     phone: { type: :string },
                     organization: { type: :string },
                     address: { type: :string },
                     city: { type: :string },
                     country: { type: :string },
                     postal_code: { type: :string },
                     youtube_url: { type: :string },
                     white_listing_enabled: { type: :string }
                   }
                 }
               }
        run_test!
      end
    end
  end

  path '/api/v1/consumer/consumers/update_profile' do
    patch 'Update profile' do
      tags 'Consumers'

      parameter name: :first_name, in: :formData, type: :string
      parameter name: :last_name, in: :formData, type: :string
      parameter name: :password, in: :formData, type: :string
      parameter name: 'consumer_profile_attributes[id]', in: :formData, type: :string
      parameter name: 'consumer_profile_attributes[phone]', in: :formData, type: :string
      parameter name: 'consumer_profile_attributes[organization]', in: :formData, type: :string
      parameter name: 'consumer_profile_attributes[address]', in: :formData, type: :string
      parameter name: 'consumer_profile_attributes[city]', in: :formData, type: :string
      parameter name: 'consumer_profile_attributes[country]', in: :formData, type: :string
      parameter name: 'consumer_profile_attributes[postal_code]', in: :formData, type: :string
      parameter name: 'consumer_profile_attributes[youtube_url]', in: :formData, type: :string
      parameter name: 'consumer_profile_attributes[white_listing_enabled]', in: :formData, type: :boolean

      produces 'application/json'

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Profile updated' do
        schema type: :object,
               properties: {
                 fisrt_name: { type: :string },
                 last_name: { type: :string },
                 email_name: { type: :string },
                 content_type: { type: :string },
                 consumer_profile: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     phone: { type: :string },
                     organization: { type: :string },
                     address: { type: :string },
                     city: { type: :string },
                     country: { type: :string },
                     postal_code: { type: :string },
                     youtube_url: { type: :string },
                     white_listing_enabled: { type: :string }
                   }
                 }
               }
        run_test!
      end
    end
  end
end
