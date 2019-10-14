function ShowSpinner(x = 0 as float, y = 0 as float) as Object
    spinner = CreateObject("roSGNode", "BusySpinner")
    spinner.clockwise = true
    spinner.spinInterval = 1
    spinner.poster.width = 100
    spinner.poster.height = 100
    spinner.poster.uri = "pkg:/images/spinner.png"
    
    if x = 0 and y = 0
        x = 590 '(1280 - 100) / 2
        y = 310 '(720 - 100) / 2
    end if
    
    spinner.translation = [x, y]
    spinner.visible = true
    spinner.control = "start"
    
    m.top.appendChild(spinner)
    
    return spinner
end function

function HideSpinner(spinner as Object)
    m.top.removeChild(spinner)
    spinner = invalid
end function