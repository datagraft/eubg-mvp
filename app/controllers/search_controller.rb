class SearchController < ApplicationController
    
    def new
        newSearch = Search.new({company: params[:search], country: params[:jurisdictionFilter]})
        @resultSet = newSearch.execute_search.paginate(:page => params[:page], :per_page => 30)
    end

end
