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
            end 
        else
            @resultSet = {}
        end
        
        if params[:companyNumber] && !params[:companyNumber].to_s.empty?
            response = searchOCompanyID(params[:companyNumber].to_s)
            
            @companyOC = response
        else
            @companyOC = {} 
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

end
