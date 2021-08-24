require 'swagger_helper'

RSpec.describe 'api/tracks', type: :request do
  path '/api/v1/albums/{album_id}/tracks' do
    get 'Retrieves all tracks of album' do
      tags 'Tracks'

      produces 'application/json'

      parameter name: :album_id, in: :path, type: :string
      parameter name: :page, in: :query, type: :string
      parameter name: :per_page, in: :query, type: :string
      parameter name: :pagination, in: :query, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Tracks list' do
        schema type: :object,
               properties: {
                 tracks: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       title: { type: :string },
                       file: { type: :string },
                       status: { type: :string },
                       public_domain: { type: :boolean },
                       created_at: { type: :string, format: :date },
                       publisher: { type: :object },
                       collaborator: { type: :object },
                       lyrics: { type: :string },
                       explicit: { type: :boolean }
                     }
                   }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/albums/{album_id}/tracks' do
    post 'Create a new track of album' do
      tags 'Tracks'

      produces 'application/json'

      parameter name: :album_id, in: :path, type: :string
      parameter name: :title, in: :formData, type: :string
      parameter name: :public_domain, in: :formData, type: :boolean
      parameter name: :file, in: :formData, type: :file
      parameter name: 'collaborator_ids[]', in: :formData, type: :integer
      parameter name: 'publisher_ids[]', in: :formData, type: :integer
      parameter name: :status, in: :formData, type: :string
      parameter name: :lyrics, in: :formData, type: :string
      parameter name: :explicit, in: :formData, type: :boolean

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Track Created' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 file: { type: :string },
                 status: { type: :string },
                 public_domain: { type: :boolean },
                 created_at: { type: :string, format: :date },
                 publisher: { type: :object },
                 collaborator: { type: :object },
                 lyrics: { type: :string },
                 explicit: { type: :boolean }
               }

        run_test!
      end
    end
  end

  path '/api/v1/albums/{album_id}/tracks/{id}' do
    patch 'Update a track' do
      tags 'Tracks'

      produces 'application/json'

      parameter name: :album_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :title, in: :formData, type: :string
      parameter name: :public_domain, in: :formData, type: :boolean
      parameter name: :file, in: :formData, type: :file
      parameter name: 'collaborator_ids[]', in: :formData, type: :integer
      parameter name: 'publisher_ids[]', in: :formData, type: :integer
      parameter name: :status, in: :formData, type: :string
      parameter name: :lyrics, in: :formData, type: :string
      parameter name: :explicit, in: :formData, type: :boolean

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Track Updated' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 file: { type: :string },
                 status: { type: :string },
                 public_domain: { type: :boolean },
                 created_at: { type: :string, format: :date },
                 publisher: { type: :object },
                 collaborator: { type: :object },
                 lyrics: { type: :string },
                 explicit: { type: :boolean }
               }

        run_test!
      end
    end
  end

  path '/api/v1/albums/{album_id}/tracks/{id}' do
    get 'Show a track' do
      tags 'Tracks'

      produces 'application/json'

      parameter name: :album_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Track' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 file: { type: :string },
                 status: { type: :string },
                 public_domain: { type: :boolean },
                 created_at: { type: :string, format: :date },
                 publisher: { type: :object },
                 collaborator: { type: :object },
                 lyrics: { type: :string },
                 explicit: { type: :boolean }
               }

        run_test!
      end
    end
  end

  path '/api/v1/albums/{album_id}/tracks/{id}' do
    delete 'Destroy a track' do
      tags 'Tracks'

      produces 'application/json'

      parameter name: :album_id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Track Destroyed' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   title: { type: :string },
                   file: { type: :string },
                   status: { type: :string },
                   public_domain: { type: :boolean },
                   created_at: { type: :string, format: :date },
                   publisher: { type: :object },
                   collaborator: { type: :object },
                   lyrics: { type: :string },
                   explicit: { type: :boolean }
                 }
               }

        run_test!
      end
    end
  end
end
