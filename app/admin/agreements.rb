ActiveAdmin.register Agreement do
  permit_params :content, :agreement_type, :attachment

  filter :agreement_type, as: :select, collection: -> { agreement_types }
  filter :created_at

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  index do
    selectable_column
    id_column
    column :agreement_type do |agreement|
      agreement.agreement_type&.titleize
    end
    actions
  end

  show do
    attributes_table do
      row :agreement_type do
        agreement.agreement_type&.titleize
      end

      row :attachment do |agreement|
        link_to 'Preview', rails_blob_url(agreement.attachment), class: 'small button' if agreement.attachment.attached?
      end

      row :content do |agreement|
        agreement.content.to_s.html_safe
      end
    end
  end

  csv do
    column :id
    column (:agreement_type) { |agreement| agreement.agreement_type&.titleize }
  end

  form do |f|
    f.inputs do
      f.input :agreement_type, as: :select, collection: agreement_types, include_blank: false
      f.input :attachment, as: :file
      div do
        f.label :content
        f.cktext_area :content
      end
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_agreements_path)
    end
  end
end
