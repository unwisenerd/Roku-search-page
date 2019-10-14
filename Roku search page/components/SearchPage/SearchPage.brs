sub Init()
    m.background = m.top.FindNode("background")
    m.searchQueryTimeout = m.top.FindNode("searchQueryTimeout")
    m.searchQueryTimeout.ObserveField("fire", "OnSearchQueryTimeoutFired")
        
    m.keyboard = m.top.FindNode("keyboard")
    m.keyboard.SetFocus(true)
    
    m.top.ObserveField("focusedChild", "OnFocusedChildChanged")
    m.keyboard.ObserveField("text", "OnKeyboardInputsTextChanged")
end sub

sub OnFocusedChildChanged(event as Object)
    focusedChild = event.GetData()
end sub

sub OnKeyboardInputsTextChanged(event as Object)
    m.searchQueryTimeout.control = "stop"
    searchQuery = event.GetData()
    
    if not Utils_IsNullOrEmpty(searchQuery)
        ?"OnKeyboardInputsTextChanged-------searchQuery------",searchQuery
        m.searchQuery = searchQuery
        m.searchQueryTimeout.control = "start"
    end if
end sub

sub OnSearchQueryTimeoutFired()
    if not Utils_IsNullOrEmpty(m.searchQuery)
        Utils_CreateDataRequest("GetSearchQueryData", "OnSearchQueryResultsCome", {searchQuery: m.searchQuery})
    end if
end sub

sub OnSearchQueryResultsCome(data as Object)
    data = data.GetData()
    
    if data <> invalid and not Utils_IsNullOrEmpty(data.totalItems)
        
    end if
end sub
