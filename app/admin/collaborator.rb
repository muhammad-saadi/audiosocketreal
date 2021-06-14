ActiveAdmin.register User, as: 'Collaborator' do
  controller do
    def scoped_collection
      end_of_association_chain.collaborator
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
    end

    panel 'Artists' do
      table_for collaborator.artists do
        column :id
        column :name do |artist|
          artist.full_name
        end
        column :actions do |artist|
          link_to t('active_admin.view'), admin_artist_path(artist)
        end
      end
    end
  end
end
