ActiveAdmin.register Filter do
  permit_params :name, :parent_filter_id, :max_levels_allowed, :featured
end
