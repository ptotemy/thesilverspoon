def integrated_view
  @<%= instances_name %> = <%= class_name %>.all
      @<%= instance_name %> = <%= class_name %>.new
render :layout=>'scaffold'

end