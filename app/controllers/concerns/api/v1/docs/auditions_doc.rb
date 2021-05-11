module Api::V1::Docs::AuditionsDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_auditions do
      api :GET, '/v1/auditions', 'Audition listing with search, sorting and pagination'
      param :status, Audition.statuses.keys, desc: 'Status of audition for search by status', allow_blank: true
      param :page, :number, desc: 'Page number', allow_blank: true
      param :per_page, :number, desc: 'Maximum number of records per page', allow_blank: true
      param :pagination, ['true', 'false', true, false], desc: 'Send false to avoid default pagination', allow_blank: true
      param :search_key, String, desc: 'Attribute on which you want to search', allow_blank: true
      param :search_query, String, desc: 'Keyword to be search', allow_blank: true
    end

    def_param_group :doc_create_audition do
      api :POST, "/v1/auditions", "Create an audition"
      param :first_name, String, desc: 'First name of artist', required: true
      param :last_name, String, desc: 'Last name of artist', required: true
      param :email, String, desc: 'Email id of artist', required: true
      param :artist_name, String, desc: 'Artist name of artist', required: true
      param :reference_company, String, desc: 'Company name as a reference for which artist worked', required: true
      param :exclusive_artist, [true, false, 'true', 'false'], desc: 'If artist want to be an exclusive artist or not?', allow_blank: true
      param :how_you_know_us, String, desc: 'Where do you come to know us?', allow_blank: true
      param :sounds_like, String, desc: "How do artist's sounds looks alike?", allow_blank: true
      param :audition_musics, Array, desc: 'Array of track links' do
        param :track_link, String, desc: 'Link of sound track', allow_blank: true
      end
      param :genre_ids, Array, desc: 'Array of Genre ids', allow_blank: true
    end

    def_param_group :doc_update_status do
      api :PATCH, "/v1/auditions/update_status", "Update status of an audition"
      param :id, :number, desc: 'Id of audition', required: true
      param :status, Audition.statuses.keys, desc: 'New value of status', required: true
      param :content, String, desc: 'Content to be send in email', allow_blank: true
    end

    def_param_group :doc_bulk_update_status do
      api :PATCH, "/v1/auditions/bulk_update_status", "Update status of multiple auditions at one time"
      param :ids, Array, of: Fixnum, desc: 'Ids of audition', required: true
      param :status, Audition.statuses.keys, desc: 'New value of status', required: true
      param :content, String, desc: 'Content to be send in emails', allow_blank: true
    end

    def_param_group :doc_assign_manager do
      api :PATCH, "/v1/auditions/assign_manager", "Assign audition to another manager"
      param :id, :number, desc: 'Id of audition', required: true
      param :assignee_id, :number, desc: 'Id of manager to be assigned', required: true
      param :remarks, String, desc: 'Remarks about the audition', allow_blank: true
    end

    def_param_group :doc_bulk_assign_manager do
      api :PATCH, "/v1/auditions/bulk_assign_manager", "Assign multiple auditions to another manager"
      param :audition_ids, Array, of: Fixnum, desc: 'Ids of audition', required: true
      param :assignee_id, :number, desc: 'Id of manager to be assigned', required: true
      param :remarks, String, desc: 'Remarks about the audition', allow_blank: true
    end

    def_param_group :email_template do
      api :GET, "/v1/auditions/email_template", "Get email templates on basis of status"
      param :status, String, desc: 'Status whose template is required', allow_blank: true
    end
  end
end
