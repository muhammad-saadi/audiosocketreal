ActiveAdmin.register User, as: 'Artist' do
  config.remove_action_item(:new)

  permit_params :first_name, :last_name

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
    column :roles
    actions
  end

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :created_at
      row :updated_at
      row :roles
      row :artist_profile do |artist|
        artist.artist_profile
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
      table_for artist.users_agreements.artist do
        if artist.users_agreements.artist.blank?
          column 'No Records Found'
        else
          column :id
          column 'Agreement Type' do |users_agreement|
            link_to users_agreement.agreement.agreement_type
          end
          column :status
          column :actions do |users_agreement|
            link_to t('active_admin.view'), '#',class: 'small button'
          end
        end
      end
    end

    panel 'Publishers' do
      table_for artist.publishers do
        if artist.publishers.blank?
          column 'No Records Found'
        else
          column :id
          column :name
          column :actions do |publisher|
            link_to t('active_admin.view'), '#', class: 'small button'
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
          column :access
          column :status
          column :actions do |collaborator|
            link_to t('active_admin.view'), '#', class: 'small button'
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
