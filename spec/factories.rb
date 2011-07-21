FactoryGirl.define do
  factory :album do
    name 'testalbum'
  end

  factory :album_with_photos do
    name "Album with photos"
    photo
  end

  factory :photo do
    name "Photo"
  end
#  sequence :photos do |n|
#    ""
#  end

end
