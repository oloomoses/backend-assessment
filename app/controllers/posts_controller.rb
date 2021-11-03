class PostsController < ApplicationController
  def ping
    render json: { 'success': true }, status: :ok
  end

  def index
    sort_by = params[:sortBy]
    direction = params[:direction]

    

    if sort_by && direction
      response = sort_direction(sort_by, direction)
      if response.nil?
        render json: {'error': 'sortBy parameter is invalid'}, status: :bad_request
      else
        render json: response, status: :ok
      end
    elsif sort_by
      response = sort_posts(sort_by)
      if response.nil?
        render json: {'error': 'sortBy parameter is invalid'}, status: :bad_request
      else
        render json: response, status: :ok
      end
    else
      response = get_tags
      if response.nil?
        render json: {'error': 'Tags parameter is required'}, status: :bad_request
      else
        render json: response, status: :ok
      end
    end
  end

  private

    def get_tags
      data = ''
      tag_param = params[:tags]
      if tag_param.nil?
        return
      else        
        urls = tag_param.split(',').map { |tag| "https://api.hatchways.io/assessment/blog/posts?tag=#{tag}" }

        result = urls.map { |url| JSON.parse(RestClient.get(url)) }
        
        data = remove_duplicates(result)
        
      end     
      
      return data
    end

    def remove_duplicates(data)      
      data_arr = []
      posts = {}
      data.each do |items|
        items['posts'].each { |item| data_arr << item }
      end

      posts['posts'] = data_arr.uniq {|items| items }

      posts
    end

    def sort_posts(sort_param)
      sort_values = ['id', 'reads', 'likes', 'popularity', 'authorId']
      return nil if sort_values.none?(sort_param)

      sorted = get_tags['posts'].sort { |a, b| a[sort_param] <=> b[sort_param]}
      return sorted

    end

    def sort_direction(sort_param, direction_param)
      sort_values = ['id', 'reads', 'likes', 'popularity', 'authorId']
      direction_values = ['asc', 'desc']
      return nil if sort_values.none?(sort_param) || direction_values.none?(direction_param)
      return get_tags['posts'].sort { |a, b| a[sort_param] <=> b[sort_param]} if direction_param === 'asc'
      return get_tags['posts'].sort { |a, b| b[sort_param] <=> a[sort_param]} if direction_param === 'desc' 
    end
end
  