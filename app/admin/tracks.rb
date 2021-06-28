ActiveAdmin.register Track do
  config.remove_action_item(:new)
  permit_params :title, :file, :status, :album_id, :public_domain, :publisher_id, :artists_collaborator_id

  includes :album

  filter :title
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
    column :public_domain
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :file do |track|
        link_to 'Download', rails_blob_url(track.file), class: 'small button' if track.file.attached?
      end

      row :album
      row :status do |track|
        track.status&.titleize
      end

      row :public_domain
      row :publisher
      row :artists_collaborator
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    user = f.object.album.user
    f.inputs do
      f.input :title
      f.input :file, as: :file
      f.input :status, as: :select, collection: tracks_status_list, include_blank: false
      f.input :album, as: :searchable_select, collection: user.albums, include_blank: false
      f.input :public_domain
      f.input :publisher, as: :searchable_select, collection: user.publishers, include_blank: '(Select a Publisher)'
      f.input :artists_collaborator, as: :searchable_select, collection: collaborators_details_list(user),
                                     include_blank: '(Select a Collaborator)'
    end
    f.actions
  end
end
