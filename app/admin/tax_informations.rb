ActiveAdmin.register TaxInformation do
  config.remove_action_item(:new)
  actions :all, except: [:destroy]

  includes :artist_profile

  permit_params :ssn, :artist_profile_id

  filter :artist_profile, as: :searchable_select
  filter :ssn

  form do |f|
    f.inputs do
      f.input :ssn
      f.input :artist_profile, as: :select, collection: [f.object.artist_profile], include_blank: false
    end
    f.actions
  end
end
