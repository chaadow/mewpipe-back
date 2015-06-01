FactoryGirl.define do
  factory :user do
    pwd = Faker::Internet.password

    email { Faker::Internet.email }
    usernname { Faker::Name.name }
    password { pwd }
    password_confirmation { pwd }

    factory :admin do
      admin { true }
    end

    # factory :user_with_videos do
    #   transient do
    #     videos_count 5
    #   end
    #
    #   after(:create) do |user, evaluator|
    #     create_list(:video, evaluator.videos_count, user: user)
    #   end
    # end
  end
end
