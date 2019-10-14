' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    ShowSearchPage()
End sub

sub ShowSearchPage()
    'Creating and appending Search Page to Main Scene;
    m.searchPage = CreateObject("roSGNode", "SearchPage")
    m.top.AppendChild(m.searchPage)
    m.searchPage.SetFocus(true)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    
    return result 
end function
