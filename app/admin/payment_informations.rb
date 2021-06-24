ActiveAdmin.register PaymentInformation do
  config.remove_action_item(:new)
  actions :all, except: [:destroy]

  includes :artist_profile

  permit_params :payee_name, :bank_name, :routing, :account_number, :paypal_email, :artist_profile_id

  form do |f|
    f.inputs do
      f.input :payee_name
      f.input :bank_name
      f.input :routing
      f.input :account_number
      f.input :paypal_email
      f.input :artist_profile, as: :select, collection: [f.object.artist_profile], include_blank: false
    end
    f.actions
  end
end
