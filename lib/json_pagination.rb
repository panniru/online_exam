class JsonPagination
  class << self
    def inject_pagination_entries(obj, data_hash = {})
      data_hash[:total_entries] = obj.total_entries
      previous_page = obj.previous_page.present? ? obj.previous_page : 0
      data_hash[:current_page] = previous_page+1
      data_hash[:to_index] = (data_hash[:current_page] * obj.per_page) > obj.total_entries ? obj.total_entries : (data_hash[:current_page] * obj.per_page)
      data_hash[:from_index] = (previous_page * obj.per_page)+1
      data_hash
    end
  end
end
