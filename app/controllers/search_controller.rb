class SearchController < ApplicationController

    def new
        newSearch = Search.new({company: params[:search], country: params[:jurisdictionFilter]})   
        newSearch.execute_search
        @resultSet = newSearch.searchResult.paginate(:page => params[:page], :per_page => 30)
        @MVPMode = "online"
    end

    def search_offline
        newSearch = SearchOffline.new({company: params[:search], country: params[:jurisdictionFilter]})   
        newSearch.execute_search
        @searchResultSetLocal = newSearch.searchResultLocal.paginate(:page => params[:page], :per_page => 30)
        @MVPMode = "offline"
    end

    def company_info
        if params[:MVPMode] == "online" 
            newSearch = Search.new()
            ocCompany = newSearch.search_company_oc(params[:ocJurisdictionCode], params[:ocCompanyNumber]) 
            atokaCompany = newSearch.search_company_atoka(params[:atokaCompanyNumber]) 
            @companyInfo = [ocCompany, atokaCompany]
        end
    end

    def company_info_offline
        if params[:MVPMode] == "offline" 
            newSearch = SearchOffline.new()
            ocCompany = newSearch.search_company_oc_offline(params[:ocCompanyNumber]) 
            @ocCompanyInfoOffline = ocCompany
            
            #atokaCompany = newSearch.search_company_atoka_offline(params[:atokaCompanyNumber]) 
            #@companyInfo = [ocCompany, atokaCompany]
        end
    end

end
