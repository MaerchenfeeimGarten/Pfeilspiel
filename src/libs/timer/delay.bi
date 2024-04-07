'  delay_regulate_framerate.bi

Type MaerchenZeit 'Zeitangabe mit Zeitreisefunktion
    public:
        AS Double zeitangabe = 0
        Declare Constructor (ByVal IO as Double)
        Declare Constructor ()
End Type

Constructor MaerchenZeit( ByVal IO as Double ) 
    This.zeitangabe = IO
end Constructor

Constructor MaerchenZeit() 
    This.zeitangabe = 0
end Constructor



function MaerchenZeitAngeber( neueAktuelleMaerchenZeit as MaerchenZeit = MaerchenZeit( -1.0d) ) as MaerchenZeit
    Static as Double MaerchenZeitOffset = 0
    if neueAktuelleMaerchenZeit.zeitangabe <> -1 then
        MaerchenZeitOffset += neueAktuelleMaerchenZeit.zeitangabe - MaerchenZeitAngeber().zeitangabe 
    end if 
    
    Dim As MaerchenZeit rueckgabewert
    rueckgabewert.zeitangabe = timer + MaerchenZeitOffset
    return rueckgabewert
end function

    
#if defined(__FB_WIN32__)
Declare Sub delay(ByVal amount As Single, ByVal threshold As Ulong = 2 * 16)
Declare Function regulate(ByVal MyFps As Ulong, ByVal threshold As Ulong = 2 * 16) As Single
Declare Function _setTimer Lib "winmm" Alias "timeBeginPeriod"(ByVal As Ulong = 1) As Long
Declare Function _resetTimer Lib "winmm" Alias "timeEndPeriod"(ByVal As Ulong = 1) As Long
Declare Sub delayHR(ByVal amount As Single, ByVal threshold As Ulong = 2 * 1)
Declare Function regulateHR(ByVal MyFps As Ulong, ByVal threshold As Ulong = 2 * 1) As Single
Sub delayHR(ByVal amount As Single, ByVal threshold As Ulong)
    '' 'amount'  : requested temporisation to apply, in milliseconds
    '' 'thresold' : fixing threshold for fine-grain temporisation (by waiting loop), in milliseconds
    Dim As Double t1 = MaerchenZeitAngeber().zeitangabe
    Dim As Double t2
    Dim As Double t3 = t1 + amount / 1000
    If amount > threshold + 0.5 Then
        _setTimer()
        Sleep amount - threshold, 1
        _resetTimer()
    End If
    Do
    #if Not defined(__FB_WIN32__) And Not defined(__FB_LINUX__)
        t2 = MaerchenZeitAngeber().zeitangabe
        If t2 < t1 Then t1 -= 24 * 60 * 60 : t3 -= 24 * 60 * 60
    Loop Until t2 >= t3
    #else
    Loop Until MaerchenZeitAngeber().zeitangabe >= t3
    #endif
End Sub
Function regulateHR(ByVal MyFps As Ulong, ByVal threshold As Ulong) As Single
    '' 'MyFps' : requested FPS value, in frames per second
    '' function return : applied delay (for debug), in milliseconds
    '' 'thresold' : fixing threshold for fine-grain temporisation (by waiting loop), in milliseconds
    Static As Double t1
    Dim As Single tf = 1 / MyFps
    Dim As Double t2 = MaerchenZeitAngeber().zeitangabe
    #if Not defined(__FB_WIN32__) And Not defined(__FB_LINUX__)
    If t2 < t1 Then t1 -= 24 * 60 * 60
    #endif
    Dim As Single dt = (tf - (t2 - t1)) * 1000
    delayHR(dt, threshold)
    t1 = MaerchenZeitAngeber().zeitangabe
    Return dt
End Function
#elseif defined(__FB_LINUX__)
Declare Sub delay(ByVal amount As Single, ByVal threshold As Ulong = 2 * 10)
Declare Function regulate(ByVal MyFps As Ulong, ByVal threshold As Ulong = 2 * 10) As Single
#elseif defined(__FB_DOS__)
Declare Sub delay(ByVal amount As Single, ByVal threshold As Ulong = 2 * 55)
Declare Function regulate(ByVal MyFps As Ulong, ByVal threshold As Ulong = 2 * 55) As Single
#else
Declare Sub delay(ByVal amount As Single, ByVal threshold As Ulong = 2 * 16)
Declare Function regulate(ByVal MyFps As Ulong, ByVal Ulong As Single = 2 * 16) As Single
#endif

Declare Function framerate() As Ulong

'------------------------------------------------------------------------------

Sub delay(ByVal amount As Single, ByVal threshold As Ulong)
    '' 'amount'  : requested temporisation to apply, in milliseconds
    '' 'thresold' : fixing threshold for fine-grain temporisation (by waiting loop), in milliseconds
    Dim As Double t1 = MaerchenZeitAngeber().zeitangabe
    Dim As Double t2
    Dim As Double t3 = t1 + amount / 1000
    If amount > threshold + 0.5 Then Sleep amount - threshold, 1
    Do
    #if Not defined(__FB_WIN32__) And Not defined(__FB_LINUX__)
        t2 = MaerchenZeitAngeber().zeitangabe
        If t2 < t1 Then t1 -= 24 * 60 * 60 : t3 -= 24 * 60 * 60
    Loop Until t2 >= t3
    #else
    Loop Until MaerchenZeitAngeber().zeitangabe >= t3
    #endif
End Sub

Function regulate(ByVal MyFps As Ulong, ByVal threshold As Ulong) As Single
    '' 'MyFps' : requested FPS value, in frames per second
    '' function return : applied delay (for debug), in milliseconds
    '' 'thresold' : fixing threshold for fine-grain temporisation (by waiting loop), in milliseconds
    Static As Double t1
    Dim As Single tf = 1 / MyFps
    Dim As Double t2 = MaerchenZeitAngeber().zeitangabe
    #if Not defined(__FB_WIN32__) And Not defined(__FB_LINUX__)
    If t2 < t1 Then t1 -= 24 * 60 * 60
    #endif
    Dim As Single dt = (tf - (t2 - t1)) * 1000
    delay(dt, threshold)
    t1 = MaerchenZeitAngeber().zeitangabe
    Return dt
End Function

Function framerate() As Ulong
    '' function return : measured FPS value (for debug), in frames per second
    Static As Double t1
    Dim As Double t2 = MaerchenZeitAngeber().zeitangabe
#if Not defined(__FB_WIN32__) And Not defined(__FB_LINUX__)
    If t2 < t1 Then t1 -= 24 * 60 * 60
#endif
    Dim As Ulong tf = 1 / (t2 - t1)
    t1 = t2
    Return tf
End Function 

Function timelerp(starttime as MaerchenZeit, durationInSecs as Double, startvalue as double, endvalue as double) as double
    Dim As Double t2 = MaerchenZeitAngeber().zeitangabe
#if Not defined(__FB_WIN32__) And Not defined(__FB_LINUX__)
    If t2 < starttime.zeitangabe Then starttime.zeitangabe -= 24 * 60 * 60
#endif
    Dim as Double diff = (t2 - starttime.zeitangabe)
    if diff < 0 then
        return 0
    elseif diff < durationInSecs then
        return (diff/durationInSecs)*(endvalue - startvalue) + startvalue
    else 
        return endvalue
    end if
end function
