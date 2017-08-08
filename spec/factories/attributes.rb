FactoryGirl.define do
  factory :attribute do
    name "MyString"
    association :entity, factory: :entity
  end
end
