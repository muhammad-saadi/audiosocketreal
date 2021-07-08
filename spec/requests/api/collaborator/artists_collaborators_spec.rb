require 'swagger_helper'

RSpec.describe 'api/collaborator/artists_collaborators', type: :request do
  path '/api/v1/collaborator/artists_collaborators/{id}' do
    patch 'Update artists collaborator' do
      tags 'Collaborator-Artists Collaborators'

      parameter name: :artist_id, in: :query, type: :string
      parameter name: :id, in: :path, type: :integer
      parameter name: :access, in: :formData, type: :string
      parameter name: :'collaborator_profile_attributes[pro]', in: :formData, type: :string
      parameter name: :'collaborator_profile_attributes[ipi]', in: :formData, type: :string
      parameter name: :'collaborator_profile_attributes[different_registered_name]', in: :formData, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'Collaborator Updated' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   first_name: { type: :string },
                   last_name: { type: :string },
                   email: { type: :string },
                   access: { type: :string },
                   status: { type: :string },
                   collaborator_profile: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       pro: { type: :string },
                       ipi: { type: :string },
                       different_registered_name: { type: :string }
                     }
                   }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/collaborator/artists_collaborators/{id}' do
    delete 'Destroy artists collaborator' do
      tags 'Collaborator-Artists Collaborators'


      parameter name: :artist_id, in: :query, type: :integer
      parameter name: :id, in: :path, type: :integer

      security [{ api_auth: [] }, { user_auth: [] }]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'Collaborator deleted' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   first_name: { type: :string },
                   last_name: { type: :string },
                   email: { type: :string },
                   access: { type: :string },
                   status: { type: :string },
                   collaborator_profile: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       pro: { type: :string },
                       ipi: { type: :string },
                       different_registered_name: { type: :string }
                     }
                   }
                 }
               }

        run_test!
      end
    end
  end
end
