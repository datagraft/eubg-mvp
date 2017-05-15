class SearchController < ApplicationController
    
    def new
        @newSearch = Search.new({company: params[:search], country: params[:jurisdictionFilter]})
        @newSearch.execute_search
        self.result
    end
    
    def result
        @resultSet = @newSearch.companies.paginate(:page => params[:page], :per_page => 30)
    end
    
end
