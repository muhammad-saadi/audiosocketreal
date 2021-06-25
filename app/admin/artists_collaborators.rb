ActiveAdmin.register ArtistsCollaborator do
  config.remove_action_item(:new)

  permit_params :status, :access

  includes :artist, :collaborator

  filter :artist, as: :searchable_select, collection: User.artist
  filter :collaborator, as: :searchable_select, collection: User.collaborator
  filter :status, as: :select, collection: ArtistsCollaborator.statuses.keys.map { |key| [key.humanize, key] }
  filter :access, as: :select, collection: ArtistsCollaborator.accesses.keys.map { |key| [key.humanize, key] }

  index do
    selectable_column
    id_column
    column :artist do |artists_collaborator|
      link_to artists_collaborator.artist.email, admin_artist_path(artists_collaborator.artist)
    end

    column :collaborator do |artists_collaborator|
      link_to artists_collaborator.collaborator.email, admin_collaborator_path(artists_collaborator.collaborator)
    end

    column :status do |artists_collaborator|
      artists_collaborator.status&.titleize
    end

    column :access do |artists_collaborator|
      artists_collaborator.access&.titleize
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :artist do
        link_to artists_collaborator.artist.email, admin_artist_path(artists_collaborator.artist)
      end

      row :collaborator do
        link_to artists_collaborator.collaborator.email, admin_collaborator_path(artists_collaborator.collaborator)
      end

      row :status do
        artists_collaborator.status&.titleize
      end

      row :access do
        artists_collaborator.access&.titleize
      end

      row :collaborator_profile
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :artist, input_html: { disabled: true }
      f.input :collaborator, input_html: { disabled: true }
      f.input :status, as: :select, collection: collaborators_status_list, include_blank: false
      f.input :access, as: :select, collection: collaborators_access_list, include_blank: false
    end
    f.actions
  end
end
