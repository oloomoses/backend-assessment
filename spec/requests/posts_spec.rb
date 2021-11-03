require 'rails_helper'

describe 'Posts API', type: :request do
  it 'Pings successfully' do
    get '/api/ping'

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('success')
  end

  it 'gets posts with tags' do
    get '/api/posts?tags=tech'

    expect(response).to have_http_status(:ok)
  end

  it 'return an error if tags param is nil' do
    get '/api/posts'

    expect(response).to have_http_status(:bad_request)
    expect(response.body).to include('Tags parameter is required')
  end

  it 'return an error if sortBy param is invalid' do
    get '/api/posts?tags=tech&sortBy=gdsds'

    expect(response).to have_http_status(:bad_request)
    expect(response.body).to include('sortBy parameter is invalid')
  end

  it 'return the sorted posts if sortBy param is valid' do
    get '/api/posts?tags=tech&sortBy=id'

    expect(response).to have_http_status(:ok)
  end

  it 'return an error if direction param is invalid' do
    get '/api/posts?tags=tech&sortBy=id&direction=both'

    expect(response).to have_http_status(:bad_request)
    expect(response.body).to include('sortBy parameter is invalid')
  end

  it 'return the sorted posts if direction param is valid' do
    get '/api/posts?tags=tech&sortBy=id&direction=asc'

    expect(response).to have_http_status(:ok)
  end
end