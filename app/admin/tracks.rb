ActiveAdmin.register Track do
  config.remove_action_item(:new)
  permit_params :title, :file, :status, :album_id, :public_domain, :publisher_id, :artists_collaborator_id, :lyrics, :explicit

  includes :album

  filter :title_cont, as: :string, label: 'Title'
  filter :status, as: :select, collection: -> { tracks_status_list }
  filter :created_at

  scope :all, default: true
  scope :pending
  scope :unclassified
  scope :approved
  scope :rejected

  index do
    selectable_column
    id_column
    column :title
    column :album
    column :status do |track|
      track.status&.titleize
    end
    column :explicit
    column :public_domain
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :file do |track|
        audio_tag(url_for(track.file), controls: true) if track.file.attached?
      end

      row :album
      row :status do |track|
        track.status&.titleize
      end

      row :explicit
      row :lyrics
      row :public_domain
      row :publisher
      row :artists_collaborator
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  csv do
    column :id
    column :title
    column (:album) { |track| track.album.name }
    column (:status) { |track| track.status&.titleize }
    column (:explicit) { |object| formatted_boolean(object.explicit) }
    column (:public_domain) { |object| formatted_boolean(object.public_domain) }
    column (:created_at) { |object| formatted_datetime(object.created_at.localtime) }
    column (:updated_at) { |object| formatted_datetime(object.updated_at.localtime) }
  end

  form do |f|
    user = f.object.album.user
    f.inputs do
      f.input :title
      f.input :file, as: :file
      f.input :lyrics
      f.input :status, as: :select, collection: tracks_status_list, include_blank: false
      f.input :album, as: :searchable_select, collection: user.albums, include_blank: false
      f.input :public_domain
      f.input :explicit
      f.input :publisher, as: :searchable_select, collection: user.publishers, include_blank: '(Select a Publisher)'
      f.input :artists_collaborator, as: :searchable_select, collection: collaborators_details_list(user),
                                     include_blank: '(Select a Collaborator)'
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_album_path(f.object.album_id))
    end
  end
end
