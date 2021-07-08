ActiveAdmin.register ContactInformation do
  menu false

  actions :all, except: [:destroy]

  controller do
    def index
      redirect_to admin_artists_path
    end

    def show
      redirect_to admin_artist_path(ContactInformation.find(params[:id]).artist_profile.user)
    end
  end

  includes :artist_profile

  permit_params :name, :street, :postal_code, :city, :state, :country, :artist_profile_id, :phone, :email

  filter :artist_profile, as: :searchable_select
  filter :name
  filter :country
  filter :state
  filter :city

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column :street
    column :postal_code
    column :country
    column :state
    column :city
    column :artist_profile
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :phone
      f.input :street
      f.input :postal_code
      f.input :country, as: :searchable_select, collection: CountryStateSelect.countries_collection.map(&:first), include_blank: 'Select a Country'
      f.input :state
      f.input :city
      f.input :artist_profile, as: :select, collection: [f.object.artist_profile], include_blank: false
    end

    f.actions do
      f.action :submit
      f.cancel_link(admin_artist_profile_path(f.object.artist_profile_id))
    end
  end
end
