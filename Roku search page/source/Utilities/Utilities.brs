'Different useful utility functions;

'Creating data request via callback;
Function Utils_CreateDataRequest(name as String, onResult as Object, params = invalid as Object, onError = "" as String) as Object
    request = createObject("roSGNode", "DataRequest")
    'specifying function that will get proper data
    request.name = name
    if params <> invalid
        request.params = params
    end if
    'setting the observer on result receive
    onResultType = type(onResult) 
    if onResultType = "roString"
        request.ObserveField("result", onResult)
    else if onResultType = "roFunction"
        if m.onResultFunctions = invalid
            m.onResultFunctions = {}
        end if
        
        if params <> invalid and params.id <> invalid
            m.onResultFunctions.addReplace(params.id, onResult)
        else
            m.onResultFunctions.addReplace(name, onResult)
        end if
        
        request.ObserveField("result", "Utils_onDataRequestResult")
    end if
    'setting the observer for error field
    if onError <> invalid
        request.ObserveField("error", onError)
    end if
    
    Utils_fireEvent("createDataRequest", request)

    return request
End Function

'firing data requet to global - then catching it in main on observed port;
sub Utils_fireEvent(eventType as String, data = invalid as Dynamic)
    getGlobalAA().global.event = {
        type: eventType
        data: data
    }
end sub

function Utils_AAToNodeTree(data as Object) as Object
    result = invalid
    
    if Utils_IsSGNode(data)
        result = data
    else if Utils_IsAssociativeArray(data)
        fieldsToSet = {}
        
        fieldsToSet.append(data)
        children = fieldsToSet.childrenArr
        fieldsToSet.delete("childrenArr")
        
        subtype = data.subtype
        if not Utils_IsString(subtype) then subtype = "ContentNode"
        
        result = Utils_AAToContentNode(fieldsToSet, subtype)
        if result <> invalid AND Utils_IsArray(children)
            contentNode = invalid
            childrenArr = []
            for each child in children
                contentNode = Utils_AAToNodeTree(child)
                if contentNode <> invalid then childrenArr.push(contentNode)
            end for
            result.appendChildren(childrenArr) 
        end if
    end if
        
    return result
end function

Function Utils_AAToContentNode(inputAA = {} as Object, nodeType = "ContentNode" as String)
    item = createObject("roSGNode", nodeType)
    
    existingFields = {}
    newFields = {}
    
    'AA of node read-only fields for filtering'
    fieldsFilterAA = {
        focusedChild    :   "focusedChild"
        change          :   "change"
        metadata        :   "metadata"
    }
    
    for each field in inputAA
        if item.hasField(field)
            if NOT fieldsFilterAA.doesExist(field) then existingFields[field] = inputAA[field]
        else
            newFields[field] = inputAA[field]
        end if
    end for
    
    item.setFields(existingFields)
    item.addFields(newFields)
    
    return item
End Function

'converts array of AAs to content node with child content nodes
Function Utils_ContentList2Node(contentList as Object) as Object
    result = createObject("roSGNode","ContentNode")

    for each itemAA in contentList
        item = Utils_AAToNodeTree(itemAA)
        result.appendChild(item)
    end for

    return result
End Function

Function Utils_IsSGNode(value As Dynamic) As Boolean
    Return Utils_IsValid(value) And GetInterface(value, "ifSGNodeChildren") <> invalid
End Function

Function Utils_IsAssociativeArray(value As Dynamic) As Boolean
    Return Utils_IsValid(value) And GetInterface(value, "ifAssociativeArray") <> invalid
End Function

Function Utils_IsArray(value As Dynamic) As Boolean
    Return Utils_IsValid(value) And GetInterface(value, "ifArray") <> invalid
End Function

Function Utils_IsNullOrEmpty(value As Dynamic) As Boolean
    If Utils_IsString(value) Then
        Return (value = invalid Or Len(value) = 0)
    Else
        Return Not Utils_IsValid(value)
    End If
End Function

Function Utils_AsString(input As Dynamic, default = "" as String) As String
    If Utils_IsValid(input) = False Then
        Return default
    Else If Utils_IsString(input) and input.Len() > 0 Then
        Return input
    Else If Utils_IsInteger(input) or Utils_IsLongInteger(input) or Utils_IsBoolean(input)Then
        Return input.ToStr()
    Else If Utils_IsFloat(input) or Utils_IsDouble(input) Then
        Return Str(input).Trim()
    Else
        Return default
    End If
End Function

Function Utils_AsInteger(input As Dynamic, default = 0) As Integer
    If Utils_IsValid(input) = False Then
        Return default
    Else If Utils_IsString(input) Then
        Return input.ToInt()
    Else If Utils_IsInteger(input) Then
        Return input
    Else If Utils_IsFloat(input) or Utils_IsDouble(input) or Utils_IsLongInteger(input) Then
        Return Int(input)
    Else
        Return default
    End If
End Function

Function Utils_AsBoolean(input As Dynamic) As Boolean
    If Utils_IsValid(input) = False Then
        Return False
    Else If Utils_IsString(input) Then
        Return LCase(input) = "true"
    Else If Utils_IsInteger(input) Or Utils_IsFloat(input) Then
        Return input <> 0
    Else If Utils_IsBoolean(input) Then
        Return input
    Else
        Return False
    End If
End Function

Function Utils_IsValid(value As Dynamic) As Boolean
    Return Type(value) <> "<uninitialized>" And value <> invalid
End Function

Function Utils_IsString(value As Dynamic) As Boolean
    Return Utils_IsValid(value) And GetInterface(value, "ifString") <> invalid
End Function

Function Utils_IsInteger(value As Dynamic) As Boolean
    Return Utils_IsValid(value) And GetInterface(value, "ifInt") <> invalid And (Type(value) = "roInt" Or Type(value) = "roInteger" Or Type(value) = "Integer")
End Function

Function Utils_IsLongInteger(value As Dynamic) As Boolean
    Return Utils_IsValid(value) And GetInterface(value, "ifLongInt") <> invalid
End Function

Function Utils_IsBoolean(value As Dynamic) As Boolean
    Return Utils_IsValid(value) And GetInterface(value, "ifBoolean") <> invalid
End Function

Function Utils_IsFloat(value As Dynamic) As Boolean
    Return Utils_IsValid(value) And GetInterface(value, "ifFloat") <> invalid
End Function

Function Utils_IsDouble(value As Dynamic) As Boolean
    Return Utils_IsValid(value) And GetInterface(value, "ifDouble") <> invalid
End Function
