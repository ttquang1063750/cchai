FactoryGirl.define do
  factory :task do
    name "MyString"
    description "MyText"
    project nil
    dead_line "2017-02-15"
  end
end
