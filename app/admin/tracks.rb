ActiveAdmin.register Track do
  config.remove_action_item(:new)

  permit_params :title, :file, :status, :album_id, :public_domain, :lyrics, :explicit, :composer, :description, :language, :duration, :featured, :instrumental, :key, :bpm, :admin_note, :parent_track_id, filter_ids: [], collection_ids: [], license_ids: [], track_publishers_attributes: %i[id publisher_id percentage _destroy], track_writers_attributes: %i[id artists_collaborator_id percentage _destroy]

  includes :publishers, file_attachment: :blob, album: [:user], track_writers: [:collaborator], filters: %i[parent_filter sub_filters]

  filter :title_or_album_name_or_filters_name_cont, as: :string, label: 'Search'
  filter :title_cont, as: :string, label: 'Title'
  filter :status, as: :select, collection: -> { tracks_status_list }
  filter :filters_id, as: :searchable_select, multiple: true, collection: -> { filters_list }
  filter :created_at

  scope :all, default: true
  scope :approved
  scope :unclassified
  scope :pending
  scope :rejected

  controller do
    def scoped_collection
      return end_of_association_chain.distinct if params[:action] == 'index'

      super
    end
  end

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  batch_action :download do |ids|
    zipline(batch_action_collection.where(id: ids).to_zip, 'tracks.zip')
  end

  batch_action :download_xlsx do |ids|
    xlsx_sheet = batch_action_collection.where(id: ids).track_detail_sheet
    send_data xlsx_sheet, filename: "tracks_data.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  member_action :remove_file, method: :delete do
    blob = Track.find(params[:id]).file.blob
    return if blob.blank?

    blob.attachments.first.purge
  end

  index do
    selectable_column
    id_column
    column :title do |track|
      link_to track.title, admin_track_path(track)
    end
    column :album
    column :status do |track|
      track.status&.titleize
    end
    column :explicit
    column :public_domain
    column :featured
    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
    column :file do |track|
      audio_tag(url_for(track.file), controls: true) if track.file.attached?
    end
    actions defaults: false do |track|
      item 'View', admin_track_path(track), class: 'member_link'
      item 'Edit', edit_admin_track_path(track, index: true), class: 'member_link'
      item 'Delete', admin_track_path(track), method: :delete, class: 'member_link'
    end
  end

  show do
    attributes_table do
      row :title
      row "Music File" do |track|
        audio_tag(url_for(track.file), controls: true) if track.file.attached?
      end

      row :duration
      row :album
      row :status do |track|
        track.status&.titleize
      end

      row :publish_date, &:formatted_publish_date
      row :parent_track
      row :explicit
      row :featured
      row :public_domain
      row :composer
      row :description
      row :language
      row :instrumental
      row :key
      row :bpm
      row :lyrics
      row :admin_note
      row :created_at, &:formatted_created_at
      row :updated_at, &:formatted_updated_at
    end

    panel 'Alternate Versions' do
      @track = Track.find(params[:id])
      table_for @track.alternate_versions do
        if @track.alternate_versions.blank?
          column 'No Records Found'
        else
          column :title do |track|
            link_to track.title, admin_track_path(track)
          end
          column :album
          column :file do |track|
            audio_tag(url_for(track.file), controls: true) if track.file.attached?
          end
        end
      end
    end

    panel 'Writers' do
      @track = Track.find(params[:id])
      table_for @track.track_writers do
        if @track.track_writers.blank?
          column 'No Records Found'
        else
          column :collaborator do |writer|
            link_to writer.collaborator_email, admin_artists_collaborator_path(writer.artists_collaborator)
          end
          column :percentage
        end
      end
    end

    panel 'Publishers' do
      @track = Track.find(params[:id])
      table_for @track.track_publishers do
        if @track.track_publishers.blank?
          column 'No Records Found'
        else
          column :publisher
          column :percentage
        end
      end
    end

    panel 'Filters' do
      @track = Track.find(params[:id])

      table_for @track.filters do
        if @track.filters.blank?
          column 'No Records Found'
        else
          column :id
          column :name
          column :actions do |filter|
            link_to t('active_admin.view'), admin_track_filter_path(filter), class: 'small button'
          end
        end
      end
    end

    panel 'Notes' do
      @track = Track.find(params[:id])
      table_for @track.notes do
        if @track.notes.blank?
          column 'No Records Found'
        else
          column :id
          column :status
          column :actions do |note|
            link_to 'view', admin_note_path(note), class: 'small button'
          end
        end
      end
    end

    active_admin_comments
  end

  csv do
    column :id
    column :title
    column(:album) { |track| track.album.name }
    column(:status) { |track| track.status&.titleize }
    column(:explicit) { |object| formatted_boolean(object.explicit) }
    column(:public_domain) { |object| formatted_boolean(object.public_domain) }
    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
  end

  form do |f|
    user = f.object.album.user
    f.inputs do
      panel '', class: 'align-right-button' do
        link_to 'Show Artist', admin_artist_path(user), class: 'medium button', target: :blank
      end
      f.input :title
      f.input :file, as: :file , label: "Music File"

      div class: 'file-hint' do
        span 'Existing File: ' + file_hint(f.object), id: 'hint'
        span link_to 'x', remove_file_admin_track_path(f.object), class: 'remove-file', data: { confirm: 'Are you sure you want to remove this audio?' }, method: :delete, remote: true if f.object.file.blob&.persisted?
      end
      
      f.input :description, input_html: { class: 'autogrow', rows: 4, cols: 20 }
      f.input :status, as: :select, collection: tracks_status_list, include_blank: false
      f.input :parent_track, as: :searchable_select, collection: user.tracks, input_html: { data: { placeholder: 'Select a Parent Track' } }
      f.input :album, as: :searchable_select, collection: user.albums, include_blank: false
      f.input :public_domain
      f.input :explicit
      f.input :instrumental
      f.input :featured
      f.has_many :track_publishers, heading: 'Publishers', allow_destroy: true do |p|
        p.input :publisher, as: :searchable_select, collection: user.publishers, input_html: { data: { placeholder: 'Select Publisher' } }
        p.input :percentage
      end

      f.semantic_errors :track_publishers

      br

      f.has_many :track_writers, heading: 'Writers', allow_destroy: true do |p|
        p.input :artists_collaborator, as: :searchable_select, collection: collaborators_details_list(user), disabled: disabled_collaborators(user),
                                       input_html: { data: { placeholder: 'Select Collaborator' } }
        p.input :percentage
      end

      f.semantic_errors :track_writers

      br

      Filter.parent_filters.track.includes(sub_filters: [sub_filters: :sub_filters]).each do |filter|
        next unless filter.sub_filters.size.positive?

        f.input :filter_ids, as: :searchable_select, collection: filter.sub_filters, label: filter.name, multiple: true,
                             input_html: { data: { placeholder: "Select #{filter.name}" }, name: '[track][filter_ids][]',
                                           id: filter.id.to_s, class: 'filter_select' }
        next unless filter.max_levels_allowed == 2

        div(class: "#{filter.id}-children") do
          f.input :filter_ids, as: :searchable_select, collection: sub_filter_options(filter, f.object), label: "Sub-#{filter.name}", multiple: true,
                               input_html: { data: { placeholder: "Select Sub-#{filter.name}" }, name: '[track][filter_ids][]',
                                             id: "#{filter.id}-children" }
        end
      end

      f.input :composer
      f.input :language
      f.input :key, as: :searchable_select, collection: key_signatures_list, include_blank: 'Select a Key Signature', label: "Key Signature"
      f.input :bpm
      f.input :lyrics, input_html: { class: 'autogrow', rows: 4, cols: 20 }
      f.input :collections, as: :searchable_select, collection: Collection.pluck(:name, :id), input_html: { multiple: true, data: { placeholder: 'Select Collections' }, class: 'collection_select' }
      f.input :licenses, as: :searchable_select, collection: license_options, input_html: { data: { placeholder: 'Select Associated Licenses' } }
      f.input :admin_note, label: "Notes", input_html: { class: 'autogrow', rows: 4, cols: 20 }
    end

    f.actions do
      f.action :submit
      f.cancel_link(if params[:index].present?
                      { action: 'index' }
                    else
                      f.object.persisted? ? { action: 'show' } : admin_album_path(f.object.album_id)
                    end)
    end
  end
end
