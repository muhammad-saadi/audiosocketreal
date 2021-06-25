ActiveAdmin.register User, as: 'Artist' do
  config.remove_action_item(:new)
  permit_params :first_name, :last_name

  filter :first_name_or_last_name_cont, as: :string, label: 'Name'
  filter :email

  controller do
    def scoped_collection
      end_of_association_chain.artist
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :created_at
    column :updated_at
    column :roles do |artist|
      artist.roles.map.map(&:titleize)
    end
    actions
  end

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :created_at
      row :updated_at
      row :roles do
        artist.roles.map(&:titleize)
      end

      row :artist_profile do |artist|
        link_to 'Go to Artist Profile', admin_artist_profile_path(artist.artist_profile)
      end
    end

    panel 'Albums' do
      table_for artist.albums do
        if artist.albums.blank?
          column 'No Records Found'
        else
          column :id
          column :name
          column :actions do |album|
            link_to t('active_admin.view'), admin_album_path(album), class: 'small button'
          end
        end
      end
    end

    panel 'Agreements' do
      panel('', class: 'align-right') do
        link_to 'Add new Agreement', new_admin_users_agreement_path(users_agreement: { user_id: artist.id, role: 'artist' }), class: 'medium button'
      end

      table_for artist.users_agreements.artist do
        if artist.users_agreements.artist.blank?
          column 'No Records Found'
        else
          column :id
          column :agreement
          column 'Agreement Type' do |users_agreement|
            users_agreement.agreement.agreement_type&.titleize
          end

          column :status do |users_agreement|
            users_agreement.status&.titleize
          end

          column :actions do |users_agreement|
            link_to t('active_admin.view'), admin_users_agreement_path(users_agreement), class: 'small button'
          end
        end
      end
    end

    panel 'Publishers' do
      panel('', class: 'align-right') do
        link_to 'Add new Publisher', new_admin_publisher_path(publisher: { user_id: artist.id }), class: 'medium button'
      end

      table_for artist.publishers do
        if artist.publishers.blank?
          column 'No Records Found'
        else
          column :id
          column :name
          column :actions do |publisher|
            link_to t('active_admin.view'), admin_publisher_path(publisher), class: 'small button'
          end
        end
      end
    end

    panel 'Collaborators Details' do
      table_for artist.collaborators_details do
        if artist.collaborators_details.blank?
          column 'No Records Found'
        else
          column :id
          column :collaborator do |collaborators_detail|
            link_to collaborators_detail.collaborator.email, admin_collaborator_path(collaborators_detail.collaborator)
          end

          column :access do |collaborators_detail|
            collaborators_detail.access&.titleize
          end

          column :status do |collaborators_detail|
            collaborators_detail.status&.titleize
          end

          column :actions do |collaborator|
            link_to t('active_admin.view'), admin_artists_collaborator_path(collaborator), class: 'small button'
          end
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
    end
    f.actions
  end


end
