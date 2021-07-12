ActiveAdmin.register Note do
  actions :all, except: [:new, :create]

  permit_params :description, :status, :user_id, :notable_type, :notable_id

  includes :user, :notable

  filter :notable_type
  filter :created_at

  scope :all, default: true
  scope :pending
  scope :completed

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  index do
    selectable_column
    id_column
    column :status do |note|
      note.status&.titleize
    end
    column :notable_type
    column :notable
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :description
      row :files do
        ul do
          note.files.each do |file|
            li do
              link_to 'Download', rails_blob_url(file), class: 'small button'
            end
            br do
            end
          end
        end
      end

      row :status do
        note.status&.titleize
      end
      row :notable_type
      row :notable
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  csv do
    column :id
    column (:status) { |note| note.status&.titleize }
    column :notable_type
    column :notable, &:notable_name
    column (:created_at) { |object| formatted_datetime(object.created_at.localtime) }
    column (:updated_at) { |object| formatted_datetime(object.updated_at.localtime) }
  end

  form do |f|
    f.inputs do
      f.label "Note ##{f.object.id}"
      f.input :status, as: :select, collection: notes_status_list, include_blank: false
    end

    f.actions do
      f.action :submit
      f.cancel_link({ action: 'show' })
    end
  end
end
