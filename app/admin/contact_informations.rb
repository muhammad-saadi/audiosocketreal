ActiveAdmin.register ContactInformation do
  config.remove_action_item(:new)
  actions :all, except: [:destroy]

  includes :artist_profile

  permit_params :name, :street, :postal_code, :city, :state, :country, :artist_profile_id, :phone

  filter :artist_profile, as: :searchable_select
  filter :name
  filter :country
  filter :state
  filter :city

  index do
    selectable_column
    id_column
    column :name
    column :phone
    column :street
    column :postal_code
    column :country do |contact_information|
      CountryStateSelect.countries_collection.find{|a| a[1].to_s == contact_information.country}.first
    end
    column :state
    column :city
    column :artist_profile
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :phone
      row :street
      row :postal_code
      row :country do
        CountryStateSelect.countries_collection.find{|a| a[1].to_s == contact_information.country}.first
      end
      row :state
      row :city
      row :artist_profile
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :phone
      f.input :street
      f.input :postal_code
      f.input :country, as: :select, collection: CountryStateSelect.countries_collection, include_blank: '(Select Country)'
      f.input :state
      f.input :city
      f.input :artist_profile, as: :select, collection: [f.object.artist_profile], include_blank: false
    end
    f.actions
  end
end
