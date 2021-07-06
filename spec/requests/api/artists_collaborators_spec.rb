require 'swagger_helper'

RSpec.describe 'api/artists_collaborators', type: :request do
  path '/api/v1/artists_collaborators/{id}/update_status' do
    patch 'Update status of artists collaborator' do
      tags 'Artists Collaborator'


      parameter name: :id, in: :path, type: :string
      parameter name: :status, in: :formData, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'Status Updated' do
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
                   status: { type: :string },
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/artists_collaborators/{id}/update_access' do
    patch 'Update access of artists collaborator' do
      tags 'Artists Collaborator'


      parameter name: :id, in: :path, type: :string
      parameter name: :access, in: :formData, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'Access Updated' do
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

  path '/api/v1/artists_collaborators/{id}' do
    patch 'Update artists collaborator' do
      tags 'Artists Collaborator'

      parameter name: :id, in: :path, type: :string
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
                   status: { type: :string }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/artists_collaborators/{id}' do
    delete 'Destroy artists collaborator' do
      tags 'Artists Collaborator'


      parameter name: :id, in: :path, type: :string

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
                   status: { type: :string }
                 }
               }

        run_test!
      end
    end
  end
end
