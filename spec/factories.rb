FactoryGirl.define do
  factory :album do
    name 'Test Album'
  end

  factory :photo do
    name "Photo"
    after_build do |photo|
      photo.photo.stubs(:get_exif_data).returns({
        :date_time_original => Time.now, 
        :model => "Testcam", 
        :software => "MySoftware 1.2" 
      })
      photo.photo.stubs(:path).returns(File.join("/","test.png"))
    end
  end

  factory :user do
    email "test@example.org"
    password "test123"
    nickname "Testuser"
  end

end
