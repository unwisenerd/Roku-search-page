function InitApiConsumer() as Object
    this = {
        apikey                    :   "409bf432"
        dataRequestUrl            :   "http://www.omdbapi.com/"
        GetSearchQueryData        :   ApiConsumer_GetSearchQueryData
    }
    return this
end function

function ApiConsumer_GetSearchQueryData(event as Object)
    params = event.params
    query = Utils_AsString(params.searchQuery)
    contentType = Utils_AsString(params.type)
    url = m.dataRequestUrl + "?apikey=" + m.apikey + "&s=" + query
    if not Utils_IsNullOrEmpty(contentType) then url += "&type=" + contentType
    
    response = ApiConnsumer_RequestData(url)
    if response <> invalid
        json = ParseJson(response)
        parsedResult = ParseQueryResults(json)
        
        if parsedResult <> invalid
            event.result = parsedResult
        end if
    end if
end function

'Requesting data synchronously;
function ApiConnsumer_RequestData(url as String) as Object
    result = invalid
    if not Utils_IsNullOrEmpty(url)
        request = CreateObject("rourltransfer")
        request.setCertificatesFile("common:/certs/ca-bundle.crt")
        request.initClientCertificates()
        request.setUrl(url)

        result = request.GetToString()
    end if
    return result
end function
