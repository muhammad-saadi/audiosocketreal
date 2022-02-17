require 'swagger_helper'

RSpec.describe 'api/consumer/curated_playlists', type: :request do
  path '/api/v1/consumer/curated_playlists' do
    get 'Curated Playlists List' do
      tags 'Curated Playlists'
      produces 'application/json'

      parameter name: :query, in: :query, type: :string

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Curated Playlists' do
        schema type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  category: { type: :string },
                  order: { type: :integer },
                  keywords: { type: :string },
                  playlist_image: { type: :string },
                  banner_image: { type: :string },
                  playlist_tracks: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        id: { type: :integer },
                        note: { type: :string },
                        order: { type: :integer },
                        track: {
                          type: :object,
                          properties: {
                            id: { type: :integer },
                            title: { type: :string },
                            file: { type: :string },
                            status: { type: :string },
                            parent_track_id: { type: :integer },
                            public_domain: { type: :boolean },
                            created_at: { type: :string, format: :date },
                            lyrics: { type: :string },
                            explicit: { type: :boolean },
                            composer: { type: :string },
                            description: { type: :string },
                            language: { type: :string },
                            instrumental: { type: :boolean },
                            key: { type: :string },
                            bpm: { type: :integer },
                            admin_note: { type: :string },
                            filters: {
                              type: :array,
                              items: {
                                type: :object,
                                properties: {
                                  id: { type: :integer },
                                  name: { type: :string },
                                  sub_filters: {
                                    type: :array,
                                    items: {
                                      type: :object,
                                      properties: {
                                        id: { type: :integer },
                                        name: { type: :string },
                                        sub_filters: {
                                          type: :array,
                                          items: :object
                                        },
                                        track_count: { type: :integer }
                                      }
                                    }
                                  },
                                  track_count: { type: :integer }
                                }
                              }
                            },
                            moods: {
                              type: :array,
                              items: :object
                            },
                            genre: {
                              type: :array,
                              items: :object
                            },
                            instruments: {
                              type: :array,
                              items: :object
                            },
                            themes: {
                              type: :array,
                              items: :object
                            },
                            duration: { type: :number, format: :float },
                            alternate_versions: {
                              type: :array,
                              items: :object
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
