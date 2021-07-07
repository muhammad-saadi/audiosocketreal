ActiveAdmin.register Publisher do
  config.remove_action_item(:new)

  permit_params :name, :user_id, :pro, :ipi

  includes :user

  filter :user, as: :searchable_select, collection: User.artist
  filter :name_cont, as: :string, label: 'Name'
  filter :created_at

  index do
    selectable_column
    id_column
    column :user
    column :name
    column :pro
    column :ipi
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :pro
      row :ipi
      row :user
      row :created_at
      row :updated_at
    end

    panel 'Tracks' do
      table_for publisher.tracks do
        if publisher.tracks.blank?
          column 'No Records Found'
        else
          column :id
          column :title
          column :actions do |track|
            link_to 'view', admin_track_path(track), class: 'small button'
          end
        end
      end
    end

    active_admin_comments
  end

  csv do
    column :id
    column (:user) { |publisher| publisher.user.full_name }
    column :name
    column :pro
    column :ipi
    column (:created_at) { |object| formatted_datetime(object.created_at.localtime) }
    column (:updated_at) { |object| formatted_datetime(object.updated_at.localtime) }
  end

  form do |f|
    f.inputs do
      f.input :user, as: :select, collection: [f.object.user], include_blank: false
      f.input :name
      f.input :pro, as: :select, collection: pro_list, include_blank: '(Select a PRO)'
      f.input :ipi
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_artist_path(f.object.user_id))
    end
  end
end
