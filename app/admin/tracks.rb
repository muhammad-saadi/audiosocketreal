ActiveAdmin.register Track do
  config.remove_action_item(:new)
  permit_params :title, :status, :album_id, :public_domain, :publisher_id, :artists_collaborator_id

  index do
    selectable_column
    id_column
    column :title
    column :album
    column :status
    column :public_domain
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :album
      row :status
      row :public_domain
      row :publisher
      row :artists_collaborator
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    user = f.object.album.user
    f.inputs do
      f.input :title
      f.input :status, as: :select, collection: Track.statuses.keys
      f.input :album, as: :select, collection: user.albums
      f.input :public_domain
      f.input :publisher, as: :select, collection: user.publishers
      f.input :artists_collaborator, as: :select, collection: user.collaborators_details.map { |u| [u.collaborator.full_name, u.id] }
    end
    f.actions
  end
end
