require 'swagger_helper'

RSpec.describe 'api/collaborator/albums', type: :request do
  path '/api/v1/collaborator/albums' do
    get 'Retrieves all albums of current artist' do
      tags 'Collaborator-Albums'

      produces 'application/json'

      parameter name: :artist_id, in: :query, type: :string
      parameter name: :page, in: :query, type: :string
      parameter name: :per_page, in: :query, type: :string
      parameter name: :pagination, in: :query, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Albums list' do
        schema type: :object,
               properties: {
                 albums: {
                   type: :array,
                   items: {
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
                       release_date: { type: :string, format: 'date' },
                       artwork: { type: :string },
                       tracks: {
                         type: :array,
                         items: {
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
                   }
                 }
               }
        run_test!
      end
    end
  end

  path '/api/v1/collaborator/albums' do
    post 'Create a new album' do
      tags 'Collaborator-Albums'

      parameter name: :artist_id, in: :query, type: :string
      parameter name: :name, in: :formData, type: :string
      parameter name: :release_date, in: :formData, type: :date

      security [{ api_auth: [] }, { user_auth: [] }]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'Album Created' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 release_date: { type: :string, format: 'date' },
                 artwork: { type: :string },
                 tracks: {
                   type: :array,
                   items: {
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

  path '/api/v1/collaborator/albums/{id}' do
    patch 'Update an album' do
      tags 'Collaborator-Albums'

      parameter name: :artist_id, in: :query, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :name, in: :formData, type: :string
      parameter name: :release_date, in: :formData, type: :date

      security [{ api_auth: [] }, { user_auth: [] }]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'Album Updated' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 release_date: { type: :string, format: 'date' },
                 artwork: { type: :string },
                 tracks: {
                   type: :array,
                   items: {
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

  path '/api/v1/collaborator/albums/{id}' do
    get 'Retrieves an album' do
      tags 'Collaborator-Albums'

      produces 'application/json'

      parameter name: :artist_id, in: :query, type: :string
      parameter name: :id, in: :path, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Album found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 release_date: { type: :string, format: 'date' },
                 artwork: { type: :string },
                 tracks: {
                   type: :array,
                   items: {
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

        let(:id) { Album.create(name: 'XYZ', release_date: Date.today).id }
        run_test!
      end

      response '404', 'album not found' do
        run_test!
      end
    end
  end

  path '/api/v1/collaborator/albums/{id}' do
    delete 'Delete an album' do
      tags 'Collaborator-Albums'

      produces 'application/json'

      parameter name: :artist_id, in: :query, type: :string
      parameter name: :id, in: :path, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Album Deleted' do
        schema type: :object,
               properties: {
                 albums: {
                   type: :array,
                   items: {
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
                       release_date: { type: :string, format: 'date' },
                       artwork: { type: :string },
                       tracks: {
                         type: :array,
                         items: {
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
                   }
                 }
               }

        run_test!
      end

      response '404', 'album not found' do
        run_test!
      end
    end
  end

  path '/api/v1/collaborator/albums/{id}/update_artwork' do
    patch 'Update artwork of an album' do
      tags 'Collaborator-Albums'

      parameter name: :artist_id, in: :query, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :artwork, in: :formData, type: :file

      security [{ api_auth: [] }, { user_auth: [] }]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'Album Updated' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 release_date: { type: :string, format: 'date' },
                 artwork: { type: :string },
                 tracks: {
                   type: :array,
                   items: {
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
end