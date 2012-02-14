require "thesilverspoon/version"
# Require the RAILS generators to be able to extend Rails:Generators::NamedBase
require 'rails/generators'
#sample module
module Everything
# If you use the NamedBase inheritance, a 'name' parameter has to follow the 'rails g integratedscaffold'. Won't work otherwise. If you don't want this, use ::Base
  class Scaffold < Rails::Generators::NamedBase

    # Method in the 'thor' library which gives you access to the accessor methods
    no_tasks { attr_accessor :model_attributes, :controller_actions }

    # This captures the arguments that the generator can take after "rails g integratedscaffold name"
    argument :g_parameters, :type => :array, :default => [], :banner => "field:type field:type"

    #     this sets the path where the code looks for templates within the gem
    def self.source_root
      File.expand_path("../templates", __FILE__)
    end

    def initialize(*args, &block)

      # This is a standard initializer

      super # Call parent class
      @model_attributes = [] # Initialize empty array for 'thor' attributes

      # This method splits the name:type arguments in the parameters list
      g_parameters.each do |arg|
        @model_attributes << Rails::Generators::GeneratedAttribute.new(*arg.split(':'))
      end

      # Creates a list of all the standard actions in the controller
      @controller_actions=all_actions

    end


    def create_model

      # creates the model using the 'model.rb' template and puts it into the rails app
      template 'model.rb', "app/models/#{model_path}.rb"

    end

    def create_controller

      # creates the controller using the 'controller.rb' template and puts it into the rails app
      template 'controller.rb', "app/controllers/#{plural_name}_controller.rb"
    end

    def create_migration

      # creates the migration file using the 'migration.rb' template and puts it into the rails app with a time stamp
      template 'migration.rb', "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_create_#{model_path.pluralize.gsub('/', '_')}.rb"

    end

    def create_helper

      # creates the helper using the 'helper.rb' template and puts it into the rails app
      template 'helper.rb', "app/helpers/#{plural_name}_helper.rb"
    end

    def create_routes

      # adds the routes for the gem into the routes file
      namespaces = plural_name.split('/')
      resource = namespaces.pop
      route namespaces.reverse.inject("resources :#{resource}") { |acc, namespace|
        "namespace(:#{namespace}){ #{acc} }"
      }

      s=%{match "#{resource}_integrated_view"=>"#{resource}#integrated_view"\n}

      inject_into_file "config/routes.rb", s, :after=>"resources :#{resource}\n"

    end


    def create_views

      # creates the standard views using the '[action].html.erb' templates and puts it into the rails app
      controller_actions.each do |action|
        if action!="create" and action!="update" and action!="destroy" and action!="parse_save_from_excel"
          template "views/erb/#{action}.html.erb", "app/views/#{plural_name}/#{action}.html.erb"
        end
      end
      if form_partial?
        template "views/erb/_form.html.erb", "app/views/#{plural_name}/_form.html.erb"
      end
    end

    private

    def class_name
      name.camelize
    end


    def model_path
      name.underscore
    end

    def controller_methods(dir_name)
      controller_actions.map do |action|
        read_template("#{dir_name}/#{action}.rb")
      end.join("\n").strip
    end

    def read_template(relative_path)
      ERB.new(File.read(find_in_source_paths(relative_path)), nil, '-').result(binding)
    end

    def instance_name
      if @namespace_model
        singular_name.gsub('/', '_')
      else
        singular_name.split('/').last
      end
    end

    def instances_name
      instance_name.pluralize
    end

    def all_actions
      %w[index show new create edit update destroy]
    end

    def item_resource
      name.underscore.gsub('/', '_')
    end

    def items_path
      if action? :index
        "#{item_resource.pluralize}_path"
      else
        "root_path"
      end
    end

    def item_path(options = {})
      name = options[:instance_variable] ? "@#{instance_name}" : instance_name
      suffix = options[:full_url] ? "url" : "path"
      if options[:action].to_s == "new"
        "new_#{item_resource}_#{suffix}"
      elsif options[:action].to_s == "edit"
        "edit_#{item_resource}_#{suffix}(#{name})"
      else
        if name.include?('::') && !@namespace_model
          namespace = singular_name.split('/')[0..-2]
          "[:#{namespace.join(', :')}, #{name}]"
        else
          name
        end
      end
    end

    def item_url
      if action? :show
        item_path(:full_url => true, :instance_variable => true)
      else
        items_url
      end
    end

    def items_url
      if action? :index
        item_resource.pluralize + '_url'
      else
        "root_url"
      end
    end


    def plural_name
      name.underscore.pluralize
    end

    def form_partial?
      actions? :new, :edit
    end

    def all_actions
      %w[index show new create edit update destroy parse_save_from_excel integrated_view]
    end

    def action?(name)
      controller_actions.include? name.to_s
    end

    def actions?(*names)
      names.all? { |name| action? name }
    end

    def add_gem(name, options = {})
      gemfile_content = File.read(destination_path("Gemfile"))
      File.open(destination_path("Gemfile"), 'a') { |f| f.write("\n") } unless gemfile_content =~ /\n\Z/
      gem name, options unless gemfile_content.include? name
    end

    def destination_path(path)
      File.join(destination_root, path)
    end


# If you use the NamedBase inheritance, a 'name' parameter has to follow the 'rails g integratedscaffold'. Won't work otherwise. If you don't want this, use ::Base


  end
#endd of class

end
module Thesilverspoon
  class Install < Rails::Generators::Base

    def self.source_root
      File.expand_path("../templates", __FILE__)
    end


    def initialize(*args, &block)
      super
      #now we invokde generators off twitter boootstrap and gritter
      Rails::Generators.invoke('bootstrap:install')
      Rails::Generators.invoke('gritter:locale')
      Rails::Generators.invoke('devise:install')
      Rails::Generators.invoke('devise', ["user"])
      Rails::Generators.invoke('devise:views')
      Rails::Generators.invoke('cancan:ability')
      Rails::Generators.invoke('migration', ["add_role_to_user", ["admin:boolean"]])
      Rails::Generators.invoke('controller',["welcome",["index"]])
      Rails::Generators.invoke('rails_admin:install')	
    end

    def create_new_user
      s="\nUser.create!(:email=>'admin@tss.com',:password=>'secret',:password_confirmation=>'secret',:admin=>true)"
      append_to_file "db/seeds.rb", s
inject_into_file "app/models/user.rb",",:admin",:after=>"  attr_accessible :email, :password, :password_confirmation, :remember_me"

    end

    def create_root_route

      s="root"
      s=s+":to=>"
      s=s+"'welcome#index'\n"

    #  append_to_file "config/routes.rb",s
inject_into_file "config/routes.rb",s,:after=>"# root :to => 'welcome#index'\n"

    end

    def create_appplication_helper
      remove_file "app/helpers/application_helper.rb"
      template 'application_helper.rb', "app/helpers/application_helper.rb"
    end

    def create_uploader
      #creates the uploader ruby file using carrierwave
      template 'file_uploader.rb', "app/uploaders/file_uploader.rb"
    end

    def create_images

      # copies the standard images into the assets/images folder
      @images=Array.new
      @images= Dir.entries("#{Install.source_root}/assets/images")
      @images.each do |image|

        if image!=".." and image !="."
          copy_file "assets/images/#{image.to_s}", "app/assets/images/#{image}"
        end
      end


    end

    def create_javascripts

      # copies the standard javascripts into the assets/javascripts folder - Currently hard-coded
      #  : Remove the hardcoding for the javascripts inclusion

      copy_file "#{Install.source_root}/assets/javascripts/jquery.dataTables.min.js", "app/assets/javascripts/jquery.dataTables.min.js"

    end

    def create_stylesheet
      template "#{Install.source_root}/assets/stylesheets/silverspoon.css.scss", "app/assets/stylesheets/silverspoon.css.scss"
      template "#{Install.source_root}/assets/stylesheets/base_classes.css.scss", "app/assets/stylesheets/base_classes.css.scss"
      template "#{Install.source_root}/assets/stylesheets/silverspoon.css.scss", "app/assets/stylesheets/information_page.css.scss"
      template "#{Install.source_root}/assets/stylesheets/jquery-ui-1.8.17.custom.css", "app/assets/stylesheets/jquery-ui-1.8.17.custom.css"


    end

    def create_stylesheets_exclusions

      # copies the sequenced css into the assets/stylesheets/exclusions folder
      directory "#{Install.source_root}/assets/stylesheets/exclusions", "app/assets/stylesheets/exclusions"
    end

    def create_javascript_exclusions

      # copies the sequenced javascript into the assets/javascripts/exclusions folder
      directory "#{Install.source_root}/assets/javascripts/exclusions", "app/assets/javascripts/exclusions"
    end

    def create_stylesheet_images

      # copies the dependent css images into the assets/stylesheets/images folder
      directory "#{Install.source_root}/assets/stylesheets/images", "app/assets/stylesheets/images"

    end


    def create_layouts
=begin
      #remove hardcoding and make a loop for including all files in this folder
=end
      remove_file "app/views/layouts/application.html.erb"
      template "#{Install.source_root}/layouts/application.html.erb", "app/views/layouts/application.html.erb"
      template "#{Install.source_root}/layouts//scaffold.html.erb", "app/views/layouts/scaffold.html.erb"
      #template "#{Install.source_root}/layouts/information_page.html.erb", "app/views/layouts/information_page.html.erb"
#      template "#{Install.source_root}/layouts/pageslide_form_at.html.erb", "app/views/layouts/pageslide_form_at.html.erb"
 #     template "#{Install.source_root}/layouts/welcome.html.erb", "app/views/layouts/welcome.html.erb"

    end

    def insert_devise_code
      inject_into_file "config/application.rb", 'require "devise"', :after=>"require File.expand_path('../boot', __FILE__)\n"
    #  inject_into_file "config/application.rb", "require 'bootstrap-sass'\n", :after=>"require File.expand_path('../boot', __FILE__)\n"
      inject_into_file "config/application.rb", "require 'bootstrap-rails'\n", :after=>"require 'rails/all'\n"
      inject_into_file "config/application.rb", "require 'gritter'\n", :after=>"require 'rails/all'\n"
      inject_into_file "app/assets/stylesheets/application.css", "*=require_directory\n", :before=>"*/"
      inject_into_file "app/assets/stylesheets/application.css", "*=require bootstrap\n", :before=>"*/"
      append_to_file "app/assets/javascripts/application.js", '//= require bootstrap'
      inject_into_file "app/controllers/application_controller.rb", "before_filter :authenticate_user!\n", :after=>"  protect_from_forgery\n"


    end


  end
end


module Revert
# If you use the NamedBase inheritance, a 'name' parameter has to follow the 'rails g integratedscaffold'. Won't work otherwise. If you don't want this, use ::Base
  class Layout < Rails::Generators::Base

    def self.source_root
      File.expand_path("../templates", __FILE__)
    end
    def initialize(*args, &block)
      super
      remove_file "app/views/layouts/application.html.erb"
      template  "#{Layout.source_root}/layouts/general_layout.html.erb",'app/views/layouts/application.html.erb'

    end
  end
end

