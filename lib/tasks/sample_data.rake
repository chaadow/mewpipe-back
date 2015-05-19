if Rails.env.development?

  require 'factory_girl'
  load 'spec/factories/factories.rb'

  # Initialization
  namespace :db do
    desc "Fill development database with sample data"
    task :populate => :environment do

      if Rails.env.development?
        Rake::Task['db:reset'].invoke   # Database reset
        # sites = make_sites              # Initialize website
        # sites.each do |site|
        #   make_admins(site)          # Fake users generation
        #   make_projects(site)        # Fake projects generation
        #   make_payments(site)        # Fake payments generation
        #   make_wall_messages(site)   # Fake wall messages generation
        # end
      end
    end
  end


  # Site & settings generation
  def make_sites
    sites = ['arizuka.com', 'localhost']

    sites.each do |s|
      print("Create #{s} site (site, settings, style, partners, homepage, pages, news, questions, users, grey_labels)...")
      FactoryGirl.create(:complete_site, :domain => s)
      puts(" Done.")
    end

    return Site.all
  end

  # User generation
  def make_admins(site)
    print("Create admin user for site #{site.domain}...")
    FactoryGirl.create(:confirmed_admin, :email => "admin@arizuka.com", :password => "password", :password_confirmation => "password", :site => site)
    puts(" Done.")
  end

  # Projects generation
  def make_projects(site)
    users = User.where(:site_id => site.id)
    print("Generate projects for site #{site.domain}...")
    30.times do
      FactoryGirl.create(:complete_project, :site => site, :user => users.random())
    end
    puts(" Done.")
  end

  # Payments generation
  def make_payments(site)
    projects = Project.where(:site_id => site.id)
    users = User.where(:site_id => site.id)

    print("Generate payments for site #{site.domain}")
    200.times do
      project  = projects.random()
      payer    = users.random()
      amount   = rand(200) + minimum_amount(project.currency)
      hidden_value = [true, false].sample
      type = ["PaypalPayment", "PayzenPayment"].sample
      payment = Payment.new(:amount => amount, :hidden_value => hidden_value)
      payment.payer = payer
      payment.receiver = project.user
      payment.type = type
      payment.project = project
      payment.currency = project.currency
      payment.maturity = project.maturity + 3.days
      payment.save
      payment.set_to_approved
    end
    puts(" Done.")

  end

  # Wall messages generation
  def make_wall_messages(site)
    projects = Project.where(:site_id => site.id)
    users = User.where(:site_id => site.id)

    print("Generate wall messages for site #{site.domain}")
    40.times do
      FactoryGirl.create(:wall_message, :project => projects.random(), :user => users.random())
    end
    puts(" Done.")
  end

  # Retrieve minimum amount
  def minimum_amount(currency)
    case currency
    when "JPY"
      min = 10000
    when "NOK"
      min = 1000
    when "DKK"
      min = 1000
    when "SKK"
      min = 1000
    else
      min = 10
    end
    return rand(49) + min
  end

end
