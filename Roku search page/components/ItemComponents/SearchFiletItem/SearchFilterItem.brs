sub Init()
    m.background = m.top.FindNode("background")
    m.titleLabel = m.top.FindNode("titleLabel")
    font  = CreateObject("roSGNode", "Font")
    font.uri = "pkg:/fonts/regular.ttf"
    font.size = 20
    m.titleLabel.font = font
end sub

sub OnItemContentChange()
    itemContent = m.top.itemContent
    if itemContent = invalid then return
    
    m.titleLabel.text = itemContent.title
    if Utils_AsBoolean(itemContent.isSelected)
        m.background.color = "#ffffff"
        m.background.opacity = "0.6"
    else
        m.background.color = "#808080"
        m.background.opacity = "0.3"
    end if
end sub