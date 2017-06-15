class SearchOffline
    require 'will_paginate/array'

    attr_reader :searchResult, :company, :country

    def initialize(searchString = {})
        @company = searchString[:company]
        @country = searchString[:country]
    end

    def execute_search
        ######### offline search (working on local json files just to test)
        ocResult = search_open_corporates_offline
        atokaResult = search_atoka_offline
        @searchResult = merge_search_results(ocResult, atokaResult)
    end
    
    def search_atoka_offline
        file = File.read('atokaResult.json')
        atokaResult = JSON.parse(file) 
    end
    
    def search_open_corporates_offline
        file = File.read('ocResult.json')
        ocResult = JSON.parse(file) 
    end
    
    def search_company_oc_offline(companyID)
        file = File.read('ocResult.json')
        ocResult = JSON.parse(file) 
        company = {}

        ocResult.each do |ocCompany|
            if ocCompany["company"]["company_number"].to_s == companyID.to_s
                company = ocCompany["company"]
            end
        end

        company
    end
    
    def search_company_atoka_offline(companyID)
        file = File.read('atokaResult.json')
        atokaResult = JSON.parse(file) 
        company = {}

        atokaResult.each do |atokaCompany|
            if atokaCompany["id"].to_s == companyID.to_s
                company = atokaCompany
            end
        end

        company
    end
    
    def merge_search_results(ocResult, atokaResult)
        mergedResult = []

        ocResult.each do |ocCompany|

            atokaResult.each do |atokaCompany|

                if ocCompany["company"]["company_number"].to_s == atokaCompany["base"]["rea"].to_s
                    ocCompany["company"]["atoka_company_id"] = atokaCompany["id"].to_s
                end

            end
            mergedResult << ocCompany
        end

        mergedResult
    end
    
end