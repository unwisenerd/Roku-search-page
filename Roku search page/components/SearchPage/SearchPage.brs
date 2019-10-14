sub Init()
    m.background = m.top.FindNode("background")
    m.searchInfoLabel = m.top.FindNode("searchInfoLabel")
    font  = CreateObject("roSGNode", "Font")
    font.uri = "pkg:/fonts/regular.ttf"
    font.size = 32
    m.searchInfoLabel.font = font
    
    m.viewContainer = m.top.FindNode("viewContainer")
    m.filtersList = m.top.FindNode("filtersList")
    m.resultsGrid = m.top.FindNode("resultsGrid")
        
    m.keyboard = m.top.FindNode("keyboard")
    m.keyboard.SetFocus(true)
    
    m.slideViewAnimation = m.top.FindNode("slideViewAnimation")
    m.slideViewAnimationInterpolator = m.top.FindNode("slideViewAnimationInterpolator")
        
    m.keyboard.ObserveField("text", "OnKeyboardInputsTextChanged")
    m.filtersList.content = InitFiltersList()
    m.filtersList.ObserveField("itemSelected", "OnFiltersListItemSelectedChanged")
end sub

'saving to object's scope search query for further usage;
sub OnKeyboardInputsTextChanged(event as Object)
    m.searchQuery = event.GetData()
end sub

sub OnFiltersListItemSelectedChanged(event as Object)
    selectedItemIndex = event.GetData()
    selectedItem = m.filtersList.content.GetChild(selectedItemIndex)
    
    'checking for empty query;
    'if empty - showing related label to the user;
    'if not empty - requesting data; 
    if selectedItem.id = "searchButton"
        if Utils_IsNullOrEmpty(m.searchQuery)
            AddFilters(false)
            DropInfoLabel("Please enter a search query first")
        else
            DropInfoLabel()
            if m.spinner = invalid then m.spinner = ShowSpinner()
            Utils_CreateDataRequest("GetSearchQueryData", "OnSearchQueryResultsCome", {searchQuery: m.searchQuery})
        end if
    end if
    
    for each item in m.filtersList.content.GetChildren(-1, 0)
        item.isSelected = false
    end for
    
    'If not search button was selected - then requesting filtered content;
    if selectedItem.id <> "searchButton"
        selectedItem.isSelected = true
        RequestFilteredContent(selectedItem.id)
    end if
end sub

sub RequestFilteredContent(contentType as String)
    if Utils_IsNullOrEmpty(contentType) then return
    
    DropInfoLabel()
    if m.spinner = invalid then m.spinner = ShowSpinner()
    Utils_CreateDataRequest("GetSearchQueryData", "OnSearchQueryResultsCome", {searchQuery: m.searchQuery, type: contentType})
end sub

'Appending retrieved results data to the screen;
sub OnSearchQueryResultsCome(data as Object)
    if m.spinner <> invalid
        HideSpinner(m.spinner)
        m.spinner = invalid
    end if
    data = data.GetData()
    
    if data <> invalid and Utils_AsInteger(data.totalItems) > 0
        AddFilters(true)
        m.top.data = data
        m.resultsGrid.content = data
    else
        'if data is empty - dropping related label to the user;
        m.resultsGrid.content = invalid
        AddFilters(false)
        DropInfoLabel("There is no results for such query. Try another one.")
    end if
end sub

'Sliding view to reach searched list results or keyboard;
sub SlideView(desiredY as Integer)
    currentX = m.viewContainer.translation[0]
    currentY = m.viewContainer.translation[1]

    m.slideViewAnimationInterpolator.keyValue = [[currentX, currentY], [currentX, desiredY]]
    m.slideViewAnimation.control = "start"
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        if key = "down"
            if m.keyboard.IsInFocusChain()
                m.filtersList.SetFocus(true)
                result = true
            else if m.filtersList.HasFocus() and m.resultsGrid.content <> invalid
                SlideView(-410)
                m.resultsGrid.SetFocus(true)
                result = true
            end if
        else if key = "up"
            if m.resultsGrid.HasFocus()
                m.filtersList.SetFocus(true)
                result = true
            else if m.filtersList.HasFocus()
                SlideView(0)
                m.keyboard.SetFocus(true)
                result = true
            end if
        else if key = "replay"
            if not m.keyboard.IsInFocusChain()
                SlideView(0)
                m.keyboard.SetFocus(true)
                result = true
            end if
        end if
    end if
    return result 
end function

'Dropping label with text to the user;
sub DropInfoLabel(text = "" as String)
    if Utils_IsNullOrEmpty(text)
        m.searchInfoLabel.visible = false
        m.searchInfoLabel.text = ""
    else
        m.searchInfoLabel.text = text
        m.searchInfoLabel.visible = true
    end if
end sub

'Initializing search button item;
function InitFiltersList() as Object
    return Utils_ContentList2Node([
        {
            id : "searchButton", 
            title : "SEARCH"
        }
    ])
end function

'building specific filter;
function GetFilter(id as String, title as String) as Object
    return Utils_AAToContentNode({
        id : id, 
        title : title,
        isSelected : false   
    })
end function

'Adding or removing filters;
sub AddFilters(isAdding as Boolean)
    if isAdding and m.filtersList.content.GetChildCount() < 2
        filters = []
        filters.Push(GetFilter("movie", "Movies"))
        filters.Push(GetFilter("series", "Series"))
        m.filtersList.content.AppendChildren(filters)
    else if not isAdding
        m.filtersList.content.removeChildrenIndex(2, 1)
    end if
end sub
