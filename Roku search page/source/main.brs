' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 

sub Main()
    ShowChannelSGScreen()
end sub

sub showChannelSGScreen()
    m.screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    m.global = m.screen.GetGlobalNode()
    
    m.screen.SetMessagePort(m.port)
    m.scene = m.screen.CreateScene("MainScene")
    InitEventHandlers()
    m.screen.Show()
    m.ApiConsumer = InitApiConsumer()
    
    m.eventHandlers.Append({
        createDataRequest: function(request as Object) as Void
            m.ApiConsumer[request.name](request)
        end function
    })
    
    while(true)
        msg = wait(0, m.port)
    msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        else if msgType = "roSGNodeEvent"
            HandleSGEvent(msg)
        end if
    end while
end sub

sub InitEventHandlers()
    m.global.addField("event", "assocarray", false)
    m.global.observeField("event", m.port)
    m.eventHandlers = {}
end sub

function HandleSGEvent(msg as Object)
    if msg <> invalid
        msgData = msg.getData()
        eventType = Utils_asString(msgData.type)
        
        handler = m.eventHandlers[eventType]
        if handler <> invalid
            eventData = msgData.data
            
            if eventData <> invalid
                handler(eventData)
            end if
        end if
    end if
end function
