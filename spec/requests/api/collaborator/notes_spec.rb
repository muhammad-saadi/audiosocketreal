require 'swagger_helper'

RSpec.describe 'api/collaborator/notes', type: :request do
  path '/api/v1/collaborator/notes' do
    get 'Get notes associated with an object' do
      tags 'Collaborator-Notes'

      parameter name: :artist_id, in: :query, type: :string
      parameter name: :notable_type, in: :query, type: :string
      parameter name: :notable_id, in: :query, type: :integer

      security [{ api_auth: [] }, { user_auth: [] }]

      produces 'application/json'

      response '200', 'Notes List' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   description: { type: :string },
                   files: {
                     type: :array,
                     items: {
                       type: :string
                     }
                   },
                   notable_type: { type: :string },
                   notable_id: { type: :integer },
                   status: { type: :string }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/collaborator/notes' do
    post 'Create note for an object' do
      tags 'Collaborator-Notes'

      parameter name: :artist_id, in: :query, type: :string
      parameter name: :notable_type, in: :formData, type: :string
      parameter name: :notable_id, in: :formData, type: :string
      parameter name: :description, in: :formData, type: :string
      parameter name: :'files[]', in: :formData, type: :file

      security [{ api_auth: [] }, { user_auth: [] }]

      produces 'application/json'

      response '200', 'Notes List' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   description: { type: :string },
                   files: {
                     type: :array,
                     items: {
                       type: :string
                     }
                   },
                   notable_type: { type: :string },
                   notable_id: { type: :integer },
                   status: { type: :string }
                 }
               }

        run_test!
      end
    end
  end
end
