'Properly parsing searched query results;
function ParseQueryResults(json as Object)as Object
    result = {
        totalItems: 0,
        childrenArr: []
    }
    
    if json <> invalid and json.search <> invalid and json.search.Count() > 0
        result.totalItems = json.totalResults
        
        for each item in json.search
            searchItem = {
                title: Utils_AsString(item.title)
                type: Utils_AsString(item.type)
                year: Utils_AsString(item.year)
                posterUri: Utils_AsString(item.poster)
                imdbID: Utils_AsString(item.imdbID)
            }
            
            result.childrenArr.Push(searchItem)
        end for
    end if
    
    resultsNode = Utils_AAToNodeTree(result)
    return resultsNode
end function