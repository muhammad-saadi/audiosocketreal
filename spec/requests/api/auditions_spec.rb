require 'swagger_helper'

RSpec.describe 'api/auditions', type: :request do
  path '/api/v1/auditions' do
    get 'List all auditions' do
      tags 'Auditions'

      parameter name: :page, in: :query, type: :string
      parameter name: :per_page, in: :query, type: :string
      parameter name: :pagination, in: :query, type: :string
      parameter name: :status, in: :query, type: :string
      parameter name: :search_key, in: :formData, type: :string
      parameter name: :search_query, in: :formData, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'Auditions List' do
        schema type: :object,
               properties: {
                 auditions: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       first_name: { type: :string },
                       last_name: { type: :string },
                       email: { type: :string },
                       artist_name: { type: :string },
                       reference_company: { type: :string },
                       exclusive_artist: { type: :string },
                       how_you_know_us: { type: :string },
                       status: { type: :string },
                       status_updated_at: { type: :string },
                       sounds_like: { type: :string },
                       remarks: { type: :string },
                       submitted_at: { type: :string },
                       audition_musics: {
                         type: :array,
                         items: {
                           type: :object,
                           properties: {
                             id: { type: :integer },
                             track_link: { type: :string }
                           }
                         }
                       },
                       genres: {
                         type: :array,
                         items: {
                           type: :object,
                           properties: {
                             id: { type: :integer },
                             name: { type: :string }
                           }
                         }
                       },
                       assignee: {
                         type: :object,
                         properties: {
                           id: { type: :integer },
                           email: { type: :string },
                           first_name: { type: :string },
                           last_name: { type: :string }
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

  path '/api/v1/auditions' do
    post 'Create a new audition' do
      tags 'Auditions'

      parameter name: :'audition[first_name]', in: :formData, type: :string
      parameter name: :'audition[last_name]', in: :formData, type: :string
      parameter name: :'audition[email]', in: :formData, type: :string
      parameter name: :'audition[artist_name]', in: :formData, type: :string
      parameter name: :'audition[reference_company]', in: :formData, type: :string
      parameter name: :'audition[exclusive_artist]', in: :formData, type: :boolean
      parameter name: :'audition[how_you_know_us]', in: :formData, type: :string
      parameter name: :'audition[sounds_like]', in: :formData, type: :string
      parameter name: :'audition[audition_musics][][track_link]', in: :formData, type: :string
      parameter name: :'audition[genre_ids][]', in: :formData, type: :string

      security [{ api_auth: [] }]

      produces 'application/json'

      response '200', 'Audition Created' do
        schema type: :object,
               properties: {
                 auditions: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       first_name: { type: :string },
                       last_name: { type: :string },
                       email: { type: :string },
                       artist_name: { type: :string },
                       reference_company: { type: :string },
                       exclusive_artist: { type: :string },
                       how_you_know_us: { type: :string },
                       status: { type: :string },
                       status_updated_at: { type: :string },
                       sounds_like: { type: :string },
                       remarks: { type: :string },
                       submitted_at: { type: :string },
                       audition_musics: {
                         type: :array,
                         items: {
                           type: :object,
                           properties: {
                             id: { type: :integer },
                             track_link: { type: :string }
                           }
                         }
                       },
                       genres: {
                         type: :array,
                         items: {
                           type: :object,
                           properties: {
                             id: { type: :integer },
                             name: { type: :string }
                           }
                         }
                       },
                       assignee: {
                         type: :object,
                         properties: {
                           id: { type: :integer },
                           email: { type: :string },
                           first_name: { type: :string },
                           last_name: { type: :string }
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

  path '/api/v1/auditions/{id}/update_status' do
    patch 'Update status of audition' do
      tags 'Auditions'

      parameter name: :id, in: :path, type: :integer
      parameter name: :status, in: :formData, type: :string
      parameter name: :content, in: :formData, type: :string
      parameter name: :exclusive, in: :formData, type: :boolean

      security [{ api_auth: [] }, { user_auth: [] }]

      produces 'application/json'

      response '200', 'Status Updated' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 first_name: { type: :string },
                 last_name: { type: :string },
                 email: { type: :string },
                 artist_name: { type: :string },
                 reference_company: { type: :string },
                 exclusive_artist: { type: :string },
                 how_you_know_us: { type: :string },
                 status: { type: :string },
                 status_updated_at: { type: :string },
                 sounds_like: { type: :string },
                 remarks: { type: :string },
                 submitted_at: { type: :string },
                 audition_musics: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       track_link: { type: :string }
                     }
                   }
                 },
                 genres: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string }
                     }
                   }
                 },
                 assignee: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string },
                     first_name: { type: :string },
                     last_name: { type: :string }
                   }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/auditions/bulk_update_status' do
    patch 'Update status of auditions in bulk' do
      tags 'Auditions'

      parameter name: :'ids[]', in: :formData, type: :string
      parameter name: :status, in: :formData, type: :string
      parameter name: :content, in: :formData, type: :string
      parameter name: :exclusive, in: :formData, type: :boolean

      security [{ api_auth: [] }, { user_auth: [] }]

      produces 'application/json'

      response '200', 'Statuses Updated' do
        schema type: :object,
               properties: {
                 auditions: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       first_name: { type: :string },
                       last_name: { type: :string },
                       email: { type: :string },
                       artist_name: { type: :string },
                       reference_company: { type: :string },
                       exclusive_artist: { type: :string },
                       how_you_know_us: { type: :string },
                       status: { type: :string },
                       status_updated_at: { type: :string },
                       sounds_like: { type: :string },
                       remarks: { type: :string },
                       submitted_at: { type: :string },
                       audition_musics: {
                         type: :array,
                         items: {
                           type: :object,
                           properties: {
                             id: { type: :integer },
                             track_link: { type: :string }
                           }
                         }
                       },
                       genres: {
                         type: :array,
                         items: {
                           type: :object,
                           properties: {
                             id: { type: :integer },
                             name: { type: :string }
                           }
                         }
                       },
                       assignee: {
                         type: :object,
                         properties: {
                           id: { type: :integer },
                           email: { type: :string },
                           first_name: { type: :string },
                           last_name: { type: :string }
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

  path '/api/v1/auditions/{id}/assign_manager' do
    patch 'Assign manager to auditions' do
      tags 'Auditions'

      parameter name: :id, in: :path, type: :integer
      parameter name: :assignee_id, in: :formData, type: :string
      parameter name: :remarks, in: :formData, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      produces 'application/json'

      response '200', 'Assigned Manager' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 first_name: { type: :string },
                 last_name: { type: :string },
                 email: { type: :string },
                 artist_name: { type: :string },
                 reference_company: { type: :string },
                 exclusive_artist: { type: :string },
                 how_you_know_us: { type: :string },
                 status: { type: :string },
                 status_updated_at: { type: :string },
                 sounds_like: { type: :string },
                 remarks: { type: :string },
                 submitted_at: { type: :string },
                 audition_musics: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       track_link: { type: :string }
                     }
                   }
                 },
                 genres: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string }
                     }
                   }
                 },
                 assignee: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string },
                     first_name: { type: :string },
                     last_name: { type: :string }
                   }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/auditions/bulk_assign_manager' do
    patch 'Assign manager to auditions in bulk' do
      tags 'Auditions'

      parameter name: :'audition_ids[]', in: :formData, type: :string
      parameter name: :assignee_id, in: :formData, type: :string
      parameter name: :remarks, in: :formData, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      produces 'application/json'

      response '200', 'Statuses Updated' do
        schema type: :object,
               properties: {
                 auditions: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       first_name: { type: :string },
                       last_name: { type: :string },
                       email: { type: :string },
                       artist_name: { type: :string },
                       reference_company: { type: :string },
                       exclusive_artist: { type: :string },
                       how_you_know_us: { type: :string },
                       status: { type: :string },
                       status_updated_at: { type: :string },
                       sounds_like: { type: :string },
                       remarks: { type: :string },
                       submitted_at: { type: :string },
                       audition_musics: {
                         type: :array,
                         items: {
                           type: :object,
                           properties: {
                             id: { type: :integer },
                             track_link: { type: :string }
                           }
                         }
                       },
                       genres: {
                         type: :array,
                         items: {
                           type: :object,
                           properties: {
                             id: { type: :integer },
                             name: { type: :string }
                           }
                         }
                       },
                       assignee: {
                         type: :object,
                         properties: {
                           id: { type: :integer },
                           email: { type: :string },
                           first_name: { type: :string },
                           last_name: { type: :string }
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

  path '/api/v1/auditions/email_template' do
    get 'Get email template on basis of status' do
      tags 'Auditions'

      parameter name: :status, in: :query, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      produces 'application/json'

      response '200', 'Template found' do
        schema type: :object,
               properties: {
                 status: { type: :string }
               }

        run_test!
      end
    end
  end
end
