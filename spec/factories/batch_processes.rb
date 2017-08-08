FactoryGirl.define do
  factory :batch_process do
    name "MyString"
    batch_process 1
    operation "MyText"
    repeat_time "2017-04-06 09:39:17"
    enable false
  end
end
