ActiveAdmin.register License do
  permit_params :name, :description, :price, :license_html, :subscription

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :description
    column :subscription
    actions
  end

  show do
    attributes_table do
      row :name
      row :price
      row :description
      row :subscription
      row :license_html
      row :created_at, &:formatted_created_at
      row :updated_at, &:formatted_updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :subscription
      tabs do
        tab 'License Template Values' do
         "<div>
           <p>You can dynamically include unknown information within the license. The following template values are supported.</p>
          <p>{replace_with_business_name} The business name of the licensee.</p>
          <p>{replace_with_licensee_name} The name of the licensee.</p>
          <p>{replace_with_licensee_email} The email of the licensee.</p>
          <p>{replace_with_basket_item_id} The id of the Basket Item.</p>
          <p>{replace_with_entity_type} The entity type of the licensee.</p>
          <p>{replace_with_project_name} The project name of the licensee.</p>
          <p>{replace_with_licensed_item} The name of the licensed item.</p>
          <p>{replace_with_date} The date the license was purchased.</p>
          <p>{replace_with_license_term} The term of the license.</p>
          <p>{replace_with_license_territory} The territory of the license.</p>
          <p>{replace_with_license_price} The currency and price of the license.</p>
         </div>".html_safe
        end
      end

      div do
        br
        f.label :license
        li do
          br
        end
        f.cktext_area :license_html
      end
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_licenses_path)
    end
  end
end
