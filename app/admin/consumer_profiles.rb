ActiveAdmin.register ConsumerProfile do
  menu false

  permit_params :phone, :organization, :address, :city, :country, :postal_code, :youtube_url, :white_listing_enabled, :consumer_id

  controller do
    def index
      redirect_to admin_consumers_path
    end

    def show
      redirect_to admin_consumer_path(resource.consumer)
    end
  end

  form do |f|
    f.inputs do
      f.input :phone
      f.input :organization
      f.input :address
      f.input :city
      f.input :country, as: :searchable_select, collection: CountryStateSelect.countries_collection.map(&:first), include_blank: 'Select a Country'
      f.input :postal_code
      f.input :youtube_url
      f.input :white_listing_enabled
      f.input :consumer, as: :select, collection: [f.object.consumer], include_blank: false
    end

    f.actions do
      f.action :submit
      f.cancel_link(admin_consumer_path(f.object.consumer))
    end
  end
end
