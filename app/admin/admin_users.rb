ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, roles: []

  filter :email
  filter :created_at

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  index do
    selectable_column
    id_column
    column :email
    column :roles
    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :roles
      row :created_at, &:formatted_created_at
      row :updated_at, &:formatted_updated_at
    end
  end

  csv do
    column :id
    column :email
    column :formatted_created_at
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :roles, as: :select, collection: admin_user_roles, include_blank: false, input_html: { name: 'admin_user[roles][]' }
      f.input :password
      f.input :password_confirmation
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_admin_users_path)
    end
  end
end
