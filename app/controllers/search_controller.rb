class SearchController < ApplicationController
    
    def new
    end
    
    def result
        @newSearch = Search.new({company: params[:search], country: params[:jurisdictionFilter]})
        @newSearch.execute_search
        #@resultSet = newSearch.companies.paginate(:page => params[:page], :per_page => 30)
    end
    
end
