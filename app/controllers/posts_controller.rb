class PostsController < ApplicationController
  def index
    sort_values = ['id', 'reads', 'likes', 'popularity', 'authorId']
    direction_values = ['asc', 'desc']
    # tags = params[:tags]
    sort_by = params[:sortBy]
    direction = params[:direction]

    

    if sort_by && direction
      # do something
    elsif sort_by
      # do something
      response = sort_posts(sort_by)
      if sort_posts(sort_by).nil?
        render json: {'error': 'sortBy parameter is invalid'}, status: :bad_request
      else
        render json: response
      end
    else
      response = get_tags
      if response.nil?
        render json: {'error': 'Tags parameter is required'}, status: :bad_request
      else
        render json: response
      end
    end

    # if get_tags
    #   data = ''
      

    #   sort_param = params[:sortBy]
    #   direction = params[:direction]
    #   to_json = JSON.parse(data)

    #   if !sort_param.nil?
    #     if sort_values.none?(sort_param)
    #       response = { 'error': 'sortBy parameter is invalid' }
    #     else

          

    #       if direction.nil?
    #         response = to_json['posts'].sort { |a, b| a[sort_param] <=> b[sort_param]}
    #       else
    #         if direction_values.none?(direction)
    #           response = { 'error': 'sortBy parameter is invalid' }
    #         else
    #           if direction === 'asc'
    #             response = to_json['posts'].sort { |a, b| a[sort_param] <=> b[sort_param]}
    #           else
    #             response = to_json['posts'].sort { |a, b| b[sort_param] <=> a[sort_param]}
    #           end
    #         end
    #       end
    #     end

        
    #   end
      
    # else
    #   render json: { 'error': 'Tags parameter is required' }, status: :bad_request
    #   return
    # end
    
    # render json: response
    
    
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
end
  