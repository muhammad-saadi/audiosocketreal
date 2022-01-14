ActiveAdmin.register Publisher do
  permit_params :name
  config.remove_action_item(:new)

  filter :name_cont, as: :string, label: 'Name'
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
    column :default_publisher
    actions
  end

  show do
    attributes_table do
      row :name
      row :created_at, &:formatted_created_at
      row :updated_at, &:formatted_updated_at
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
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_publisher_path(f.object))
    end
  end
end
