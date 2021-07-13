ActiveAdmin.register Filter do
  permit_params :name, :filter_id, :max_levels_allowed
end
