ActiveAdmin.register Publisher do
  config.remove_action_item(:new)
  permit_params :name, publisher_users_attributes: %i[pro ipi user_id]

  includes :users

  filter :created_at

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  index do
    selectable_column
    id_column
    column :name
    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
    column :system_generated
    actions
  end

  show do
    attributes_table do
      row :name
      row :created_at, &:formatted_created_at
      row :updated_at, &:formatted_updated_at

      panel 'Publisher_User' do
        @publisher = Publisher.find(params[:id])
        table_for @publisher.publisher_users do
          if @publisher.publisher_users.blank?
            column 'No Records Found'
          else
            column :pro
            column :ipi
            column :user_id do |publisher|
              publisher.user
            end
          end
        end
      end

    end

    active_admin_comments
  end

  csv do
    column :id
    column :name
    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
  end

  form do |f|
    f.inputs do
      f.input :name
      f.has_many :publisher_users do |p|
        p.input :ipi
        p.input :pro
        p.input :user_id , as: :select, collection: User.artist
      end
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_artist_path(f.object.user_id))
    end
  end
end
