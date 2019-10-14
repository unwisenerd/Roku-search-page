sub Init()
    m.itemPoster = m.top.FindNode("itemPoster")
    m.titleLabel = m.top.FindNode("titleLabel")
    
    font  = CreateObject("roSGNode", "Font")
    font.uri = "pkg:/fonts/regular.ttf"
    font.size = 18
    m.titleLabel.font = font
end sub

sub OnItemContentChange()
    itemContent = m.top.itemContent
    if itemContent = invalid then return
    
    m.itemPoster.uri = Utils_AsString(itemContent.posterUri)
    m.titleLabel.text = Utils_AsString(itemContent.title) + " | " + Utils_AsString(itemContent.year)
end sub
