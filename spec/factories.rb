FactoryGirl.define do
  factory :album do
    user
    name 'Test Album'
  end

  factory :photo do
    album
    name "Photo"
    after_build do |photo|
      exif_data = {
        :date_time_original => Time.parse("01/01/2011"), 
        :model => "Testcam", 
        :software => "MySoftware 1.2" 
      }
      photo.photo.stubs(:get_exif_data).with(:all).returns(exif_data)
      exif_data.each do |key, val|
        photo.photo.stubs(:get_exif_data).with(key).returns(val)
      end
      photo.photo.stubs(:path).returns(File.join("/","test.png"))
    end
  end

  factory :user do
    email "test@example.org"
    password "test123"
    nickname "Testuser"
  end

  factory :scan do
    album
    directory "MyTestDirectory"
  end

end
