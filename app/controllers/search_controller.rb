class SearchController < ApplicationController
    def new
        if params[:search] && !params[:search].to_s.empty?
            if params[:jurisdictionFilter] && !params[:jurisdictionFilter].to_s.empty?
                if params[:pageNo] && !params[:pageNo].to_s.empty?
                    response = searchOCGeneral(params[:search].to_s, params[:jurisdictionFilter].to_s, params[:pageNo].to_s)
                else
                    response = searchOCGeneral(params[:search].to_s, params[:jurisdictionFilter].to_s, "")
                end
                @resultSet = response
            elsif params[:pageNo] && !params[:pageNo].to_s.empty?
                response = searchOCGeneral(params[:search].to_s, "", params[:pageNo].to_s)
                @resultSet = response
            else
                response = searchOCGeneral(params[:search].to_s, "", "")
                @resultSet = response
                
                atokaResponse = searchAtoka(params[:search].to_s, "", "")
                @atokaResultSet = atokaResponse
            end 
        else
            @resultSet = {}
            @atokaResultSet = {}
        end
        
        if params[:companyNumber] && !params[:companyNumber].to_s.empty?
            response = searchOCompanyID(params[:companyNumber].to_s)
            @companyOC = response
        else
            @companyOC = {} 
        end
        
        if params[:atokaIds] && !params[:atokaIds].to_s.empty?
            response = searchAtokaCompanyID(params[:atokaIds].to_s) #for some reason, nothing is fetched... the params[:atokaIds] should contain the id captured from @atokaResultSet (see new.html.erb)
            @companyAtoka = response 
        else
            @companyAtoka = {} 
        end
        
    end
    
    def searchOCGeneral(companyName, jurisdictionCode="", pageNumber="")
        if pageNumber.empty? && jurisdictionCode.empty?
            url = "https://api.opencorporates.com/v0.4/companies/search?q=" + companyName
            response = HTTParty.get(url)
        elsif pageNumber.empty? && !jurisdictionCode.empty?
            url = "https://api.opencorporates.com/v0.4/companies/search?q=" + companyName + "&jurisdiction_code=" + jurisdictionCode
            response = HTTParty.get(url)
        elsif !pageNumber.empty? && jurisdictionCode.empty?
            url = "https://api.opencorporates.com/v0.4/companies/search?q=" + companyName + "&page=" + pageNumber
            response = HTTParty.get(url)
        else
            url = "https://api.opencorporates.com/v0.4/companies/search?q=" + companyName + "&jurisdiction_code=" + jurisdictionCode + "&page=" + pageNumber
            response = HTTParty.get(url)
        end
        response.parsed_response
    end
    
    def searchOCompanyID(companyID)
        url = "https://api.opencorporates.com/v0.4/companies/" + params[:jurisdictionCode].to_s + "/" + companyID
        response = HTTParty.get(url)
        response.parsed_response
    end
    
    def searchAtoka(companyName, countries="", offset="")
        atokaToken = ENV['ATOKA_TOKEN']
        url = "https://api.atoka.io/v2/companies?token=" + atokaToken.to_s + "&packages=*" + "&name=" + companyName
        response = HTTParty.get(url)
        response.parsed_response
    end
    
    def searchAtokaCompanyID(companyID) #Something wrong is happening here - just no response at all..
        atokaToken = ENV['ATOKA_TOKEN'] 
        url = "https://api.atoka.io/v2/companies?token=" + atokaToken.to_s + "&packages=*" + "&ids=" + companyID
        response = HTTParty.get(url) 
        response.parsed_response
    end

end
