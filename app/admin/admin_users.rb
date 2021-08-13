ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :roles_raw

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  index do
    selectable_column
    id_column
    column :email
    column :roles
    column :created_at
    actions
  end

  filter :email
  filter :created_at

  csv do
    column :id
    column :email
    column (:created_at) { |object| formatted_datetime(object.created_at.localtime) }
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :roles_raw, as: :text, label: 'Roles'
      f.input :password
      f.input :password_confirmation
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_admin_users_path)
    end
  end
end
