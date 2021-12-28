ActiveAdmin.register License do
  permit_params :name, :price, :description

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  filter :name

  index do
    selectable_column
    column :name
    column :price
    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :created_at, &:formatted_created_at
      row :updated_at, &:formatted_updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
    end

    f.actions do
      f.action :submit
    end
  end
end
