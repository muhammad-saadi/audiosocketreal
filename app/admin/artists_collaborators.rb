ActiveAdmin.register ArtistsCollaborator do
  config.remove_action_item(:new)

  permit_params :status, :access

  includes :artist, :collaborator

  filter :artist, as: :searchable_select, collection: User.artist
  filter :collaborator, as: :searchable_select, collection: User.collaborator
  filter :status, as: :select, collection: -> { collaborators_status_list }
  filter :access, as: :select, collection: -> { collaborators_access_list }
  filter :created_at

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

      row :created_at
      row :updated_at
    end

    panel 'Collaborator Profile' do
      panel('', class: 'align-right') do
        if artists_collaborator.collaborator_profile.present?
          link_to 'Edit collaborator profile', edit_admin_collaborator_profile_path(artists_collaborator.collaborator_profile), class: 'medium button'
        else
          link_to 'Add collaborator profile', new_admin_collaborator_profile_path(collaborator_profile: { artists_collaborator_id: artists_collaborator.id }), class: 'medium button'
        end
      end
      attributes_table_for artists_collaborator.collaborator_profile do
        if artists_collaborator.collaborator_profile.blank?
          row 'No Record Found'
        else
          row :pro
          row :ipi
          row :different_registered_name
          row :created_at
          row :updated_at
        end
      end
    end

    active_admin_comments
  end

  csv do
    column :id
    column (:artist) { |artists_collaborator| artists_collaborator.artist.email }
    column (:collaborator) { |artists_collaborator| artists_collaborator.collaborator.email }
    column (:status) { |artists_collaborator| artists_collaborator.status&.titleize }
    column (:access) { |artists_collaborator| artists_collaborator.access&.titleize }
    column (:created_at) { |object| formatted_datetime(object.created_at.localtime) }
    column (:updated_at) { |object| formatted_datetime(object.updated_at.localtime) }
  end

  form do |f|
    f.inputs do
      f.input :artist, input_html: { disabled: true }
      f.input :collaborator, input_html: { disabled: true }
      f.input :status, as: :select, collection: collaborators_status_list, include_blank: false
      f.input :access, as: :select, collection: collaborators_access_list, include_blank: false
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_collaborators_path)
    end
  end
end
