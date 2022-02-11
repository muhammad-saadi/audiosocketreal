ActiveAdmin.register Collection do
  permit_params :name

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  filter :name

  index do
    selectable_column
    id_column
    column :name
    actions name: "Actions"
  end

  show do
    attributes_table do
      row :name
      row :created_at, &:formatted_created_at
      row :updated_at, &:formatted_updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :name
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_collections_path)
    end
  end
end
