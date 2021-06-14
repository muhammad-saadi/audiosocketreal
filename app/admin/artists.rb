ActiveAdmin.register User, as: 'Artist' do
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
      row :publishers
      row :artist_profile do |artist|
        link_to artist.artist_profile.name, admin_artist_profile_path(artist.artist_profile)
      end
    end

    panel 'Albums' do
      table_for artist.albums do
        column :id
        column :name
        column :actions do |album|
          link_to t('active_admin.view'), admin_album_path(album)
        end
      end
    end

    panel 'Agreements' do
      table_for artist.users_agreements do
        column :id
        column :agreement do |users_agreement|
          link_to :agreement, admin_agreement_path(users_agreement.agreement)
        end
        column :status
        column :actions do |users_agreement|
          link_to t('active_admin.view'), admin_users_agreement_path(users_agreement)
        end
      end
    end

    panel 'Publishers' do
      table_for artist.publishers do
        column :id
        column :name
        column :actions do |publisher|
          link_to t('active_admin.view'), admin_publisher_path(publisher)
        end
      end
    end

    panel 'Collaborators' do
      table_for artist.collaborators do
        column :id
        column :first_name
        column :actions do |collaborator|
          link_to t('active_admin.view'), admin_user_path(collaborator)
        end
      end
    end
    active_admin_comments
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :first_name, :last_name, :reset_password_token, :reset_password_sent_at, :remember_created_at, :roles
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :first_name, :last_name, :reset_password_token, :reset_password_sent_at, :remember_created_at, :roles]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
