class JsonPagination
  class << self
    def inject_pagination_entries(obj, responce_body = {})
      @obj = obj
      @responce = responce_body
    end
    
    
  end
end
