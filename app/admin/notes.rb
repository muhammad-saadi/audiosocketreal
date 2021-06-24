ActiveAdmin.register Note do
  actions :all, except: [:new, :create]

  permit_params :description, :status, :user_id, :notable_type, :notable_id

  includes :user, :notable

  index do
    tabs do
      tab :pending do
        table_for notes.pending do
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
      end

      tab :completed do
        table_for notes.completed do
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
      end
    end
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

  form do |f|
    f.inputs do
      f.label "Note ##{f.object.id}"
      f.input :status, as: :select, collection: Note.statuses.keys.map { |key| [key.titleize, key] }, include_blank: false
    end
    f.actions
  end
end
