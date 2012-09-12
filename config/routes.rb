PassbookRailsExample::Application.routes.draw do

  PASS_TYPE_IDENTIFIER_REGEXP = /([\w\d]\.?)+/
  namespace :passbook, path: "passbook/v1" do
    constraints(pass_type_identifier: /([\w\d]\.?)+/) do
      get '/passes/:pass_type_identifier/:serial_number' => 'passes#show'

      get '/devices/:device_library_identifier/registrations/:pass_type_identifier' => 'registrations#index'
      post '/devices/:device_library_identifier/registrations/:pass_type_identifier/:serial_number' => 'registrations#create'
      delete '/devices/:device_library_identifier/registrations/:pass_type_identifier' => 'registrations#destroy'
    end
  end
end
