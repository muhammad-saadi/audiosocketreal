ActiveAdmin.register Collection do
  permit_params license_ids: []

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  index do
    selectable_column
    id_column
    column :licenses
    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
    actions
  end

  show do
    attributes_table do
      row :license_ids
      row :created_at, &:formatted_created_at
      row :updated_at, &:formatted_updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :license_ids, as: :select, collection: License.all, multiple: true
    end

    f.actions do
      f.action :submit
    end
  end
end
