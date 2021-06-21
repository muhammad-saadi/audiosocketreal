ActiveAdmin.register Metadata do
  actions :all, except: [:destroy, :new, :create]
  permit_params :content

  form do |f|
    f.inputs do
      f.input :key, input_html: { disabled: true }
      f.input :content, as: :ckeditor
    end
    f.actions
  end
end
