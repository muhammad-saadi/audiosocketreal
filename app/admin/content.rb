ActiveAdmin.register Content do
  actions :all, except: [:destroy, :new, :create]
  permit_params :content

  filter :key

  index do
    selectable_column
    id_column
    column :key do |content|
      content.key.titleize
    end
    actions
  end

  show do
    attributes_table do
      row :key do |content|
        content.key.titleize
      end

      row :content do |content|
        content.content.to_s.html_safe
      end
    end

    active_admin_comments
  end

  csv do
    column :id
    column (:key) { |content| content.key.titleize }
  end

  form do |f|
    h2 do
      f.object.key.titleize
    end

    f.inputs do
      f.label 'Content:'
      f.cktext_area :content
    end

    f.actions do
      f.action :submit
      f.cancel_link({ action: 'show' })
    end
  end
end
