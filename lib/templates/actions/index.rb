 def index
    @<%= instances_name %> = <%= class_name %>.all
    @<%= instance_name %> = <%= class_name %>.new

  end