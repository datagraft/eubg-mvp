class SearchController < ApplicationController
    
    def new
        newSearch = Search.new({company: params[:search], country: params[:jurisdictionFilter]})   
        newSearch.execute_search
        @resultSet = newSearch.searchResult.paginate(:page => params[:page], :per_page => 30)
    end
    
    #def previous_search?
    #    !@previousSearch.nil?
    #end
    
    def company_info
        newSearch = Search.new()
        @companyInfo = newSearch.search_company_oc(params[:ocJurisdictionCode], params[:ocCompanyNumber])
    end
    
end
