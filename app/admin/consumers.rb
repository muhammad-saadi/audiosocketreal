ActiveAdmin.register Consumer do
  actions :all, except: :new

  permit_params :email, :first_name, :last_name

  filter :first_name_or_last_name_cont, as: :string, label: 'Name'
  filter :email, as: :string

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
    actions
  end

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :email
      row :content_type
      row :created_at, &:formatted_created_at
      row :updated_at, &:formatted_updated_at
    end

    panel 'Consumer Profile' do
      panel('', class: 'align-right') do
        if consumer.consumer_profile.present? && authorized?(:update, ConsumerProfile)
          link_to 'Edit consumer profile', edit_admin_consumer_profile_path(consumer.consumer_profile), class: 'medium button'
        elsif authorized?(:create, ConsumerProfile)
          link_to 'Add consumer profile', new_admin_consumer_profile_path(consumer_profile: { consumer_id: consumer.id }), class: 'medium button'
        end
      end

      attributes_table_for consumer.consumer_profile do
        if consumer.consumer_profile.blank?
          row 'No Record Found'
        else
          row :phone
          row :organization
          row :address
          row :city
          row :country
          row :postal_code
          row :youtube_url
          row :white_listing_enabled
          row :updated_at, &:formatted_updated_at
          row :created_at, &:formatted_created_at
        end
      end
    end

    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :first_name
      f.input :last_name
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_consumers_path)
    end
  end
end
