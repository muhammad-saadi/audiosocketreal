ActiveAdmin.register Agreement do
  permit_params :content, :agreement_type, :attachment

  index do
    selectable_column
    id_column
    column :agreement_type
    actions
  end

  show do
    attributes_table do
      row :agreement_type
      row :attachment do |agreement|
        link_to 'Preview', rails_blob_url(agreement.attachment), class: 'small button' if agreement.attachment.attached?
      end
      row :content do |agreement|
        agreement.content.to_s.html_safe
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :agreement_type, as: :select, collection: Agreement.agreement_types.keys.map { |key| [key.humanize, key] }, include_blank: false
      f.input :attachment, as: :file
      f.input :content, as: :ckeditor
    end
    f.actions
  end
end
