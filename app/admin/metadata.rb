ActiveAdmin.register Metadata do
  actions :all, except: [:destroy, :new, :create]
  permit_params :content

  index do
    selectable_column
    id_column
    column :key
    actions
  end

  show do
    attributes_table do
      row :key
      row :content do |metadata|
        metadata.content.to_s.html_safe
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :key, input_html: { disabled: true }
      f.input :content, as: :ckeditor
    end
    f.actions
  end
end
