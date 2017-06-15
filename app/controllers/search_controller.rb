class SearchController < ApplicationController

    def search_offline
        @searchOnline = false
        newSearch = SearchOffline.new({})   
        newSearch.execute_search
        @resultSet = newSearch.searchResult.paginate(:page => params[:page], :per_page => 30)
    end

    def new
        @searchOnline = true
        newSearch = Search.new({company: params[:search], country: params[:jurisdictionFilter]})   
        newSearch.execute_search
        @resultSet = newSearch.searchResult.paginate(:page => params[:page], :per_page => 30)
    end

    #def previous_search?
    #    !@previousSearch.nil?
    #end

    def company_info
        #if @searchOnline
            newSearch = Search.new()
            #@companyInfo = newSearch.search_company_oc(params[:ocJurisdictionCode], params[:ocCompanyNumber]) #Online sarch

            ocCompany = newSearch.search_company_oc(params[:jurisdictionFilter], params[:ocCompanyNumber]) #offline search 
            atokaCompany = newSearch.search_company_atoka(params[:atokaCompanyNumber]) #offline search 


            @companyInfo = [ocCompany, atokaCompany]
        #else
        #    newSearch = SearchOffline.new()
            #@companyInfo = newSearch.search_company_oc(params[:ocJurisdictionCode], params[:ocCompanyNumber]) #Online sarch

        #    ocCompany = newSearch.search_company_oc_offline(params[:ocCompanyNumber]) #offline search 
         #   atokaCompany = newSearch.search_company_atoka_offline(params[:atokaCompanyNumber]) #offline search 


         #   @companyInfo = [ocCompany, atokaCompany]
        #end
    end

end
