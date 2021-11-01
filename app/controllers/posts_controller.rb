class PostsController < ApplicationController
  def index
    response = ''
    urls = get_tags.map { |tag| "https://api.hatchways.io/assessment/blog/posts?tag=#{tag}" }

    urls.map do |url| 
      response = RestClient.get(url)
    end
     
    render json: response
  end

  private

    def get_tags
      tags = params[:tags].split(',')      
    end
end
  