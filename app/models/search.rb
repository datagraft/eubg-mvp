class Search 
    require 'will_paginate/array'
    
    attr_reader :searchResult, :company, :country
    
    def initialize(searchString = {})
        @company = searchString[:company]
        @country = searchString[:country]
    end
        
    def execute_search
        search_open_corporates
    end
    
    def search_atoka
        atokaToken = ENV['ATOKA_TOKEN']
        
        if company_defined? && !country_defined?
            url = "https://api.atoka.io/v2/companies?token=" + atokaToken.to_s + "&packages=*" + "&name=" + @company.to_s + "&limit=50" + "&offset=0"
            response = HTTParty.get(url)
            @searchResult = response.parsed_response["items"]
            totalItems = response.parsed_response["meta"]["count"].to_i
            
            #If number of items in the result is larger than the response limit, then request the next 50 until total items have been retrieved 
            if totalItems > 50
                currentRequest = 0
                offset = 50
                additionalRequests = totalItems / 50
                
                while currentRequest < additionalRequests do
                    nextPageURL = "https://api.atoka.io/v2/companies?token=" + atokaToken.to_s + "&packages=*" + "&name=" + @company.to_s + "&limit=50" + "&offset=" + offset.to_s
                    nextPageResponse = HTTParty.get(nextPageURL)
                    nextPageCompanies = nextPageResponse.parsed_response["items"]
                    @searchResult.concat(nextPageCompanies)
                    
                    offset += 50
                    currentRequest += 1
                end
                @searchResult
            else
                @searchResult
            end
    
        elsif company_defined? && country_defined?
            @country = "uk" if @country == "gb" #Atoka currently accepts 'it', 'uk', 'ru', or '*' as country value
            
            url = "https://api.atoka.io/v2/companies?token=" + atokaToken.to_s + "&packages=*" + "&name=" + @company.to_s + "&countries=" + @country.to_s + "&limit=50" + "&offset=0" 
            response = HTTParty.get(url)
            @searchResult = response.parsed_response["items"]
            totalItems = response.parsed_response["meta"]["count"].to_i
            
            if totalItems > 50
                currentRequest = 0
                offset = 50
                additionalRequests = totalItems / 50
                
                while currentRequest < additionalRequests do
                    nextPageURL = "https://api.atoka.io/v2/companies?token=" + atokaToken.to_s + "&packages=*" + "&name=" + @company.to_s + "&countries=" + @country.to_s + "&limit=50" + "&offset=" + offset.to_s
                    nextPageResponse = HTTParty.get(nextPageURL)
                    nextPageCompanies = nextPageResponse.parsed_response["items"]
                    @searchResult.concat(nextPageCompanies)
                    
                    offset += 50
                    currentRequest += 1
                end
                @searchResult
            else
                @searchResult
            end
            
        else
            @searchResult = []
        end
            
    end
    
    def search_open_corporates
        ocToken = ENV['OC_TOKEN']
        
        if company_defined? && !country_defined?
            url = "https://api.opencorporates.com/v0.4/companies/search?api_token=" + ocToken.to_s + "&q=" + @company.to_s
            response = HTTParty.get(url)
            @searchResult = response.parsed_response["results"]["companies"]
            totalPages = response.parsed_response["results"]["total_pages"].to_i
            
            #if totalPages > 20
            #    totalPages = 20
            #end
            
            if totalPages > 1
                (2..totalPages).each do |page|
                    nextPageURL = "https://api.opencorporates.com/v0.4/companies/search?api_token=" + ocToken.to_s + "&q=" + @company.to_s + "&page=#{page}"
                    nextPageResponse = HTTParty.get(nextPageURL)
                    nextPageCompanies = nextPageResponse.parsed_response["results"]["companies"]
                    @searchResult.concat(nextPageCompanies)
                end
                @searchResult
            else
                @searchResult
            end
        elsif company_defined? && country_defined?
            url = "https://api.opencorporates.com/v0.4/companies/search?api_token=" + ocToken.to_s + "&q=" + @company.to_s + "&jurisdiction_code=" + @country.to_s
            response = HTTParty.get(url)
            totalPages = response.parsed_response["results"]["total_pages"].to_i
            @searchResult = response.parsed_response["results"]["companies"]
            
            #if totalPages > 20
            #    totalPages = 20
            #end
            
            if totalPages > 1
                (2..totalPages).each do |page| 
                    nextPageURL = "https://api.opencorporates.com/v0.4/companies/search?api_token=" + ocToken.to_s + "&q=" + @company.to_s + "&jurisdiction_code=" + @country.to_s + "&page=#{page}" 
                    nextPageResponse = HTTParty.get(nextPageURL) 
                    nextPageCompanies = nextPageResponse.parsed_response["results"]["companies"] 
                    @searchResult.concat(nextPageCompanies) 
                end 
                @searchResult 
            else 
                @searchResult 
            end 
        else 
            @searchResult = [] 
        end 
    end 
    

    def company_defined?
        !@company.to_s.empty?
    end
    
    def country_defined?
        !@country.to_s.empty?
    end
    
end