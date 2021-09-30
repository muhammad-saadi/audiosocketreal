require 'swagger_helper'

RSpec.describe 'api/consumer/consumers_playlists', type: :request do
  path '/api/v1/consumer/consumers_playlists' do
    get 'Consumer Playlists List' do
      tags 'Consumer Playlists'
      produces 'application/json'

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Consumer Playlists' do
        schema type: :object,
                properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 folder_id: {type: :integer},
                 playlist_image: { type: :string },
                 banner_image: { type: :string },
                 playlist_tracks: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     note: { type: :string },
                     track: {
                       type: :object,
                       properties: {
                        id: { type: :integer },
                        title: { type: :string },
                        file: { type: :string },
                        status: { type: :string },
                        public_domain: { type: :boolean },
                        created_at: { type: :string, format: :date },
                        lyrics: { type: :string },
                        explicit: { type: :boolean },
                        composer: { type: :string },
                        description: { type: :string },
                        language: { type: :string },
                        instrumental: { type: :string },
                        key: { type: :string },
                        bpm: { type: :integer },
                        admin_note: { type: :string },
                        filter: {
                          type: :object,
                          properties: {
                           id: { type: :integer },
                           name: { type: :string },
                           max_levels_allowed: { type: :integer },
                           featured: { type: :string },
                           parent_filter_id: { type: :integer },
                           created_at: { type: :string, format: :date },
                           updated_at: { type: :string, format: :date }
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

  path '/api/v1/consumer/consumers_playlists/{id}' do
    get 'Show a Consumer Playlist' do
      tags 'Consumer Playlists'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Consumer Playlist' do
        schema type: :object,
                properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 folder_id: {type: :integer},
                 playlist_image: { type: :string },
                 banner_image: { type: :string },
                 playlist_tracks: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     note: { type: :string },
                     track: {
                       type: :object,
                       properties: {
                        id: { type: :integer },
                        title: { type: :string },
                        file: { type: :string },
                        status: { type: :string },
                        public_domain: { type: :boolean },
                        created_at: { type: :string, format: :date },
                        lyrics: { type: :string },
                        explicit: { type: :boolean },
                        composer: { type: :string },
                        description: { type: :string },
                        language: { type: :string },
                        instrumental: { type: :string },
                        key: { type: :string },
                        bpm: { type: :integer },
                        admin_note: { type: :string },
                        filter: {
                          type: :object,
                          properties: {
                           id: { type: :integer },
                           name: { type: :string },
                           max_levels_allowed: { type: :integer },
                           featured: { type: :string },
                           parent_filter_id: { type: :integer },
                           created_at: { type: :string, format: :date },
                           updated_at: { type: :string, format: :date }
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

  path '/api/v1/consumer/consumers_playlists/{id}' do
    delete 'Destroy a Consumer Playlist' do
      tags 'Consumer Playlists'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Consumer Playlist Destroyed' do
        schema type: :object,
                properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 folder_id: {type: :integer},
                 playlist_image: { type: :string },
                 banner_image: { type: :string },
                 playlist_tracks: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     note: { type: :string },
                     track: {
                       type: :object,
                       properties: {
                        id: { type: :integer },
                        title: { type: :string },
                        file: { type: :string },
                        status: { type: :string },
                        public_domain: { type: :boolean },
                        created_at: { type: :string, format: :date },
                        lyrics: { type: :string },
                        explicit: { type: :boolean },
                        composer: { type: :string },
                        description: { type: :string },
                        language: { type: :string },
                        instrumental: { type: :string },
                        key: { type: :string },
                        bpm: { type: :integer },
                        admin_note: { type: :string },
                        filter: {
                          type: :object,
                          properties: {
                           id: { type: :integer },
                           name: { type: :string },
                           max_levels_allowed: { type: :integer },
                           featured: { type: :string },
                           parent_filter_id: { type: :integer },
                           created_at: { type: :string, format: :date },
                           updated_at: { type: :string, format: :date }
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

  path '/api/v1/consumer/consumers_playlists' do
    post 'Create a Consumer Playlist' do
      tags 'Consumer Playlists'
      produces 'application/json'

      parameter name: :name, in: :formData, type: :string
      parameter name: :folder_id, in: :formData, type: :integer

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Consumer Playlist Created' do
        schema type: :object,
                properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 folder_id: {type: :integer},
                 playlist_image: { type: :string },
                 banner_image: { type: :string },
                 playlist_tracks: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     note: { type: :string },
                     track: {
                       type: :object,
                       properties: {
                        id: { type: :integer },
                        title: { type: :string },
                        file: { type: :string },
                        status: { type: :string },
                        public_domain: { type: :boolean },
                        created_at: { type: :string, format: :date },
                        lyrics: { type: :string },
                        explicit: { type: :boolean },
                        composer: { type: :string },
                        description: { type: :string },
                        language: { type: :string },
                        instrumental: { type: :string },
                        key: { type: :string },
                        bpm: { type: :integer },
                        admin_note: { type: :string },
                        filter: {
                          type: :object,
                          properties: {
                           id: { type: :integer },
                           name: { type: :string },
                           max_levels_allowed: { type: :integer },
                           featured: { type: :string },
                           parent_filter_id: { type: :integer },
                           created_at: { type: :string, format: :date },
                           updated_at: { type: :string, format: :date }
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

  path '/api/v1/consumer/consumers_playlists/{id}' do
    patch 'Update a Consumer Playlist' do
      tags 'Consumer Playlists'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer
      parameter name: :name, in: :formData, type: :string
      parameter name: :folder_id, in: :formData, type: :integer
      parameter name: :playlist_image, in: :formData, type: :string
      parameter name: :banner_image, in: :formData, type: :string
      parameter name: 'playlist_tracks_attributes[][id]', in: :formData, type: :integer
      parameter name: 'playlist_tracks_attributes[][_destroy]', in: :formData, type: :string
      parameter name: 'playlist_tracks_attributes[][track_id]', in: :formData, type: :integer
      parameter name: 'playlist_tracks_attributes[][note]', in: :formData, type: :string

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Consumer Playlist Updated' do
        schema type: :object,
                properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 folder_id: {type: :integer},
                 playlist_image: { type: :string },
                 banner_image: { type: :string },
                 playlist_tracks: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     note: { type: :string },
                     track: {
                       type: :object,
                       properties: {
                        id: { type: :integer },
                        title: { type: :string },
                        file: { type: :string },
                        status: { type: :string },
                        public_domain: { type: :boolean },
                        created_at: { type: :string, format: :date },
                        lyrics: { type: :string },
                        explicit: { type: :boolean },
                        composer: { type: :string },
                        description: { type: :string },
                        language: { type: :string },
                        instrumental: { type: :string },
                        key: { type: :string },
                        bpm: { type: :integer },
                        admin_note: { type: :string },
                        filter: {
                          type: :object,
                          properties: {
                           id: { type: :integer },
                           name: { type: :string },
                           max_levels_allowed: { type: :integer },
                           featured: { type: :string },
                           parent_filter_id: { type: :integer },
                           created_at: { type: :string, format: :date },
                           updated_at: { type: :string, format: :date }
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

  path '/api/v1/consumer/consumers_playlists/{id}/rename' do
    patch 'Rename a Consumer Playlist' do
      tags 'Consumer Playlists'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer
      parameter name: :name, in: :formData, type: :string

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Consumer Playlist Renamed' do
        schema type: :object,
                properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 folder_id: {type: :integer},
                 playlist_image: { type: :string },
                 banner_image: { type: :string },
                 playlist_tracks: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     note: { type: :string },
                     track: {
                       type: :object,
                       properties: {
                        id: { type: :integer },
                        title: { type: :string },
                        file: { type: :string },
                        status: { type: :string },
                        public_domain: { type: :boolean },
                        created_at: { type: :string, format: :date },
                        lyrics: { type: :string },
                        explicit: { type: :boolean },
                        composer: { type: :string },
                        description: { type: :string },
                        language: { type: :string },
                        instrumental: { type: :string },
                        key: { type: :string },
                        bpm: { type: :integer },
                        admin_note: { type: :string },
                        filter: {
                          type: :object,
                          properties: {
                           id: { type: :integer },
                           name: { type: :string },
                           max_levels_allowed: { type: :integer },
                           featured: { type: :string },
                           parent_filter_id: { type: :integer },
                           created_at: { type: :string, format: :date },
                           updated_at: { type: :string, format: :date }
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

  path '/api/v1/consumer/consumers_playlists/{id}/add_track' do
    post 'Add a track to Consumer Playlist' do
      tags 'Consumer Playlists'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer
      parameter name: :track_id, in: :formData, type: :integer

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Consumer Playlist Renamed' do
        schema type: :object,
                properties: {
                 status: { type: :string }
               }
        run_test!
      end
    end
  end
end
