
# The Silver Spoon

Let your Rails App be born with a silver spoon in its mouth. 

This gem preps a new Rails app with some of the best Rails gems and Jquery sweetness available:

* <b>Rails Admin</b> for System Management : https://github.com/sferik/rails_admin 
* <b>Devise</b> for Authentication : https://github.com/plataformatec/devise
* <b>Cancan</b> for Authorization : https://github.com/ryanb/cancan
* <b>NiftyGenerators</b> for Form Design : https://github.com/ryanb/nifty-generators
* <b>Gritter</b> for Notifications : https://github.com/RobinBrouwer/gritter
* <b>Carrierwave</b> for File Uploading : https://github.com/jnicklas/carrierwave
* <b>Spreadsheet</b> for Excel File Handling : http://spreadsheet.rubyforge.org/

The Silver Spoon takes care of the installation of these gems, and basic implementations of the functionalities. As long as you can live with the conventional defaults specified for these gems, you will be ready to go. If you need customization, you would need to understand the usage of each of these gems individually, which you will find at the respective gem homepages. 

Apart from this, The Silver Spoon also extends the scaffolding in your app. 
* It uses a combination of the Twitter-Bootstrap and Nifty-Generators to give aesthetically improved and more usable view templates. 
* Apart from the standard scaffold views, it also creates an AJAX driven integrated view which combines all the standard views into one.
* It also adds schema stubs and standard validation options (uncomment these to use) to your models. 

##Note
"Updated to use Bootstrap 2.0"


## Installation


The Silver Spoon works best if you use it in a new empty Rails App. It requires anything Rails 3.1.3 onwards. 

You can install it by simply adding the following lines to your Gemfile:

```console
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'
gem 'thesilverspoon'
```

Now run bundle install. After you have installed The Silver Spoon, you need to run the generator:

```console
rails generate thesilverspoon:install
```

Rails Admin will ask two questions, just press Enter to accept the defaults.
Run <b>rake db:migrate</b> <u>and</u> <b>rake db:seed</b> to finish the installation.

<b>N.B.</b> The db/seeds.rb file contains the creation code for the admin user. You can edit this before 'rake db:seed' to create your own admin credentials instead.  

## Setup

Post installation, your app will have the following:

* All the gems mentioned above with standard configurations initialized. 
* A model called _'User'_ and views (in the devise directory) for you to customize
* An Ability model to enable *Cancan* for your authorization. You also get a admin user (email:admin@tss.com | password: secret) with administrative rights to the system. Remember to change the password before you deploy the app.
* An Uploader Model in a uploaders directory and an uploading repository in /public to enable CarrierWave.  
* A Rails Admin interface at /admin. Login with the admin user credentials to use this section
* A set of basic image assets which you can use or replace to quickly start off your app.

The root location would have been mapped to welcome#index and the relevant controller-action would have been created. Delete public/index.html to access the root location.

## Usage

Naturally, you have access all the features that are available in each of the included gems. We recommend that you go through the documentation of the included gems to fully realize the amazing power these put into your hands.   

### Layouts
The app has been started off with the standard Rails layout. The Silver Spoon allows you to manipulate layouts with the following commands:

* To use the Nifty Generators style layout
 
```console
rails generate nifty:layout
```



* To revert back to the default Rails layout

```console
rails generate revert:layout
```

### Scaffolds

The Silver Spoon gives you the option of four scaffold styles:

* To use The Silver Spoon scaffold
 
```console
rails generate everything:scaffold Model [parameters]
```

This creates a special layout for the scaffold, over-riding your application layout. Besides the standard views, you can also use an integrated view at '/tablename_integrated_view'

* To use the Nifty Generators scaffold
 
```console
rails generate nifty:scaffold Model [parameters]
```



* To use the default Rails scaffold

```console
rails generate scaffold Model [parameters]
```


## Additional Information

### Bug reports

If you discover a problem with The Silver Spoon, we would like to know about it. However, please do *NOT* use the GitHub issue tracker. Send an email to the maintainers listed at the bottom of the README.

### Starting with Rails?

If you are building your first Rails application, we recommend you to *not* use The Silver Spoon. The Silver Spoon is an aggregation of a set of gems which require a good understanding of the Rails Framework. In such cases, we advise you to build everything from scratch, using the constituent gems of The Silver Spoon one at a time, to better understand their functions and super-powers.

Once you have solidified your understanding of Rails and the Gems included here, we believe you will find that The Silver Spoon is a good starting point for new apps.

### Ackowledgement and Disclaimer

We stake no claim to having built or modified any of the Gems included in this package. They are included on an as-is-where-is basis and are subject to their own individual licenses, terms of usage, copyrights and disclaimers. We are not legal experts, so if we are treading on anybody's toes, please let us know and we will remove any components you have an objection to.

Moreover, if you like The Silver Spoon, please consider leaving comments and compliments at the co-ordinates of the original Gem authors, for as they say, if we appear tall it is because we are standing on the shoulder of giants.

Also, wanted to recommend the JetBrains RubyMine IDE, which we are in no way affiliated to, but which has been critical in our Rails learning path.   

### Maintainers

* Rushabh Hathi (rushabh@ptotem.com)
* Arijit Lahiri (arijit@ptotem.com)


## License

MIT License. Copyright 2012 Ptotem Learning Projects LLP. http://www.ptotem.com

