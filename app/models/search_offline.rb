class SearchOffline
    require 'will_paginate/array'
    require 'rest-client'

    attr_reader :searchResult, :company, :country, :searchResultLocal

    def initialize(searchString = {})
        @company = searchString[:company]
        @country = searchString[:country]
    end

    def execute_search
        ######### offline search (working on local json files just to test)
        @searchResultLocal = search_company_local
        #ocResult = search_open_corporates_offline
        #atokaResult = search_atoka_offline
        #@searchResult = merge_search_results(ocResult, atokaResult)
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
        url = ENV['EUBG_SPARQL_ENDPOINT']
        key = ENV['EUBG_APIKEY'] + ':' + ENV['EUBG_APISECRET']
        basicToken = Base64.strict_encode64(key)

        query_string = "PREFIX reorg: <http://www.w3.org/ns/regorg#>
PREFIX org: <http://www.w3.org/ns/org#>
PREFIX locn: <http://www.w3.org/ns/locn#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dbpedia: <http://dbpedia.org/ontology/>
PREFIX xmls: <http://schema.org/>
PREFIX eubg: <http://data.businessgraph.io/ontology#>
SELECT ?identifier ?legalName ?jurisdiction ?foundingDate ?dissolutionDate ?orgStatusText ?fullAddress
WHERE {
?company reorg:registration ?identifierURI .
?identifierURI skos:notation '" + companyID.to_s + "';
skos:notation ?identifier.
?company reorg:legalName ?legalName ;
dbpedia:jurisdiction ?jurisdiction ;
xmls:foundingDate ?foundingDate ;
xmls:dissolutionDate ?dissolutionDate ;
eubg:orgStatusText ?orgStatusText ;
org:hasRegisteredSite ?fullAddressURI .
?fullAddressURI locn:fullAddress ?fullAddress;
}"

        request = RestClient::Request.new(
            :method => :get,
            :url => url,
            :headers => {
                :params => {
                    'query' => query_string
                    },
                'Authorization' => 'Basic ' + basicToken,
                'Accept' => 'application/sparql-results+json'
                }
            )

        begin
            response = request.execute
            throw "Error querying RDF repository" unless response.code.between?(200, 299)

            puts response.inspect
        rescue Exception => e
            puts 'Error querying RDF repository'
            puts e.message
            puts e.backtrace.inspect    
        end

        search_result = JSON.parse(response.body)["results"]["bindings"]

        return search_result

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

    #This needs to be updated w.r.t. the euBG RDFS (needs data dump from different partners)
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

    def search_company_local
        url = ENV['EUBG_SPARQL_ENDPOINT']
        key = ENV['EUBG_APIKEY'] + ':' + ENV['EUBG_APISECRET']
        basicToken = Base64.strict_encode64(key)

        if company_defined?

            query_string = "PREFIX ns: <http://www.w3.org/ns/regorg#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dbpedia: <http://dbpedia.org/ontology/>
SELECT ?legalName ?jurisdiction ?identifier
WHERE { 
?company ns:legalName ?legalName ;
dbpedia:jurisdiction ?jurisdiction ;
ns:registration ?identifierURI .
?identifierURI skos:notation ?identifier .
}"

            request = RestClient::Request.new(
                :method => :get,
                :url => url,
                :headers => {
                    :params => {
                        'query' => query_string
                        },
                    'Authorization' => 'Basic ' + basicToken,
                    'Accept' => 'application/sparql-results+json'
                    }
                )

            begin
                response = request.execute
                throw "Error querying RDF repository" unless response.code.between?(200, 299)

                puts response.inspect
            rescue Exception => e
                puts 'Error querying RDF repository'
                puts e.message
                puts e.backtrace.inspect    
            end

            search_result = JSON.parse(response.body)["results"]["bindings"]
        else
            search_result = []
        end

        return search_result
    end

    def company_defined?
        !@company.to_s.empty?
    end

    def country_defined?
        !@country.to_s.empty?
    end

end