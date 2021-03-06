require 'swagger_helper'

describe 'Albums API' do
  path '/api/v1/albums' do
    get 'Retrieves all albums of current user' do
      tags 'Albums'

      produces 'application/json'

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
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
                       release_date: { type: :string, format: 'date' },
                       artwork: { type: :string },
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
                   }
                 }
               }
        run_test!
      end
    end
  end

  path '/api/v1/albums' do
    post 'Create a new album' do
      tags 'Albums'

      parameter name: :name, in: :formData, type: :string
      parameter name: :release_date, in: :formData, type: :string, format: :date

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

  path '/api/v1/albums/{id}' do
    patch 'Update an album' do
      tags 'Albums'

      parameter name: :id, in: :path, type: :string
      parameter name: :name, in: :formData, type: :string
      parameter name: :release_date, in: :formData, type: :string, format: :date

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

  path '/api/v1/albums/{id}' do
    get 'Retrieves an album' do
      tags 'Albums'

      produces 'application/json'

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

        let(:id) { Album.create(name: 'XYZ', release_date: Date.today).id }
        run_test!
      end

      response '404', 'album not found' do
        run_test!
      end
    end
  end

  path '/api/v1/albums/{id}' do
    delete 'Delete an album' do
      tags 'Albums'

      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Album Deleted' do
        schema type: :object,
               properties: {
                 albums: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
                       release_date: { type: :string, format: 'date' },
                       artwork: { type: :string },
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

  path '/api/v1/albums/{id}/update_artwork' do
    patch 'Update artwork of an album' do
      tags 'Albums'

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

  path '/api/v1/albums/{id}/bulk_upload_tracks' do
    post 'Upload multiple tracks at once' do
      tags 'Albums'

      parameter name: :'files[]', in: :formData, type: :file
      parameter name: :id, in: :path, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'Tracks Uploaded' do
        schema type: :object,
               properties: {
                 album: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string },
                     release_date: { type: :string, format: 'date' },
                     artwork: { type: :string },
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
                 },
                 metadata: {
                   type: :object,
                   properties: {
                     total: { type: :integer },
                     uploaded: { type: :integer },
                     messages: {
                       type: :array,
                       items: {
                         type: :object,
                         properties: {
                           file: { type: :string },
                           errors: {
                             type: :array,
                             items: {
                               type: :string
                             }
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
end
