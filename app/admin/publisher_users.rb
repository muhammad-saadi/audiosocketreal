ActiveAdmin.register PublisherUser do
  config.sort_order = 'pro'
  config.order_clause = false
  config.remove_action_item(:new)
  permit_params :user_id, :pro, :ipi

  includes :publisher, :user

  filter :user, as: :searchable_select, collection: User.artist
  filter :pro_cont, as: :string, label: 'PRO'
  filter :created_at

  controller do
    def scoped_collection
      end_of_association_chain.ordered_by_pro
    end
  end

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  index do
    selectable_column
    id_column
    column :user
    column 'Publisher Name', :name do |publisher_user|
      publisher_user.publisher.name
    end
    column :pro
    column :ipi
    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
    actions
  end

  show do
    attributes_table do
      row :pro
      row :ipi
      row 'Publisher Name', :name do |publisher_user|
        publisher_user.publisher.name
      end
      row :user
      row :created_at, &:formatted_created_at
      row :updated_at, &:formatted_updated_at
    end

    active_admin_comments
  end

  csv do
    column :id
    column (:user) { |publisher| publisher.user.full_name }
    column :pro
    column :ipi
    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
  end

  form do |f|
    f.inputs do
      #f.input :user, as: :select, collection: publisher_options, include_blank: false
      #f.input :publisher, as: :select, collection: Publisher.pluck(:name, :id), include_blank: false
      f.input :pro, as: :searchable_select, collection: pro_list, include_blank: 'Select a PRO'
      f.input :ipi
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_publisher_user_path(f.object))
    end
  end
end
