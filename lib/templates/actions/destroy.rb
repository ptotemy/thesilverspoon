def destroy
  @<%= instance_name %> = <%= class_name %>.find(params[:id])
@<%= instance_name %>.destroy
if !params[:integrated_view].nil?

 redirect_to <%= item_resource.pluralize %>_integrated_view_path, :notice => "Successfully destroyed <%= class_name.underscore.humanize.downcase %>."
else
  redirect_to <%= items_url %>, :notice => "Successfully destroyed <%= class_name.underscore.humanize.downcase %>."
end
end
