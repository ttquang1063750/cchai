FactoryGirl.define do
  factory :entity do
    name "MyString"
    association :project, factory: :project
  end
end
