require 'swagger_helper'

RSpec.describe 'api/consumer/folders', type: :request do
  path '/api/v1/consumer/folders' do
    get 'Folders List' do
      tags 'Consumer Folders'
      produces 'application/json'

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Folders' do
      schema type: :object,
      properties: {
        id: { type: :integer },
        name: { type: :string }, 
        consumer_playlists: {
          type: :object,
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
        },
        sub_folders: { type: :object }
      }
      run_test!
      end
    end
  end

  path '/api/v1/consumer/folders/{id}' do
    get 'Show a Folder' do
      tags 'Consumer Folders'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Folders' do
      schema type: :object,
      properties: {
        id: { type: :integer },
        name: { type: :string }, 
        consumer_playlists: {
          type: :object,
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
        },
        sub_folders: { type: :object }
      }
      run_test!
      end
    end
  end

  path '/api/v1/consumer/folders/{id}' do
    delete 'Destroy a Folder' do
      tags 'Consumer Folders'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Folders' do
      schema type: :object,
      properties: {
        id: { type: :integer },
        name: { type: :string }, 
        consumer_playlists: {
          type: :object,
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
        },
        sub_folders: { type: :object }
      }
      run_test!
      end
    end
  end

  path '/api/v1/consumer/folders' do
    post 'Create a Folder' do
      tags 'Consumer Folders'
      produces 'application/json'

      parameter name: :name, in: :formData, type: :string
      parameter name: :parent_folder_id, in: :formData, type: :integer

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Folders' do
      schema type: :object,
      properties: {
        id: { type: :integer },
        name: { type: :string }, 
        consumer_playlists: {
          type: :object,
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
        },
        sub_folders: { type: :object }
      }
      run_test!
      end
    end
  end

  path '/api/v1/consumer/folders/{id}' do
    patch 'Update a Folder' do
      tags 'Consumer Folders'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer
      parameter name: :name, in: :formData, type: :string
      parameter name: :parent_folder_id, in: :formData, type: :integer

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Folders' do
      schema type: :object,
      properties: {
        id: { type: :integer },
        name: { type: :string }, 
        consumer_playlists: {
          type: :object,
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
        },
        sub_folders: { type: :object }
      }
      run_test!
      end
    end
  end
end
