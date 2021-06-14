ActiveAdmin.register User, as: 'Artist' do
  permit_params :email, :password, :password_confirmation, :first_name, :last_name

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
        column :id
        column :name
        column :actions do |album|
          link_to t('active_admin.view')
        end
      end
    end

    panel 'Agreement' do
      table_for artist.users_agreements do
        column :id
        column 'Agreement ID' do |users_agreement|
          link_to users_agreement.agreement.id
        end
        column :status
        column :actions do |users_agreement|
          link_to t('active_admin.view')
        end
      end
    end

    panel 'Publishers' do
      table_for artist.publishers do
        column :id
        column :name
        column :actions do |publisher|
          link_to t('active_admin.view')
        end
      end
    end

    panel 'Collaborators' do
      table_for artist.collaborators do
        column :id
        column :first_name
        column :actions do |collaborator|
          link_to t('active_admin.view')
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
    end
    f.actions
  end


end
