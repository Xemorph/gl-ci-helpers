# Script to install glfwX (X stands for the version) under Windows
# Authors: Voltana <oss@derikmediagroup.xyz>
# License: MIT: http://creativecommons.org/publicdomain/zero/1.0/

# Adapted from VisPy

$GLFW_URL = "https://github.com/glfw/glfw/releases/download/"

# Mesa DLLs found linked from:
#     http://qt-project.org/wiki/Cross-compiling-Mesa-for-Windows
# to:
#     http://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/mingw-w64-x86_64-mesa-10.2.4-1-any.pkg.tar.xz/download

function DownloadOpenGL ($architecture) {
    [Net.ServicePointManager]::SecurityProtocol = 'Ssl3, Tls, Tls11, Tls12'
    $webclient = New-Object System.Net.WebClient
    # Download and retry up to 3 times in case of network transient errors.
    $url = $GLFW_URL + "3.3/glfw-3.3.bin.WIN" + $architecture + ".zip"
    $fileName = "glfw-3.3.bin.WIN" + $architecture + ".zip"
    # For later use, need to move file to the system directory to make it
    # globally accessible
    if ($architecture -eq "32") {
        $filepath = "C:\Windows\SysWOW64\glfw3.dll"
    } else {
        $filepath = "C:\Windows\system32\glfw3.dll"
    }
    $filepathTmp = "C:\Users\${env:UserName}\Downloads\${fileName}"
    # takeown /F $filepath /A
    # icacls $filepath /grant "${env:ComputerName}\${env:UserName}:F"
    # Remove-item -LiteralPath $filepath
    Write-Host "Downloading" $url
    $retry_attempts = 2
    for($i=0; $i -lt $retry_attempts; $i++){
        try {
            $webclient.DownloadFile($url, $filepathTmp)
            break
        }
        Catch [Exception]{
            Start-Sleep 1
        }
    }
    if (Test-Path $filepathTmp) {
        Write-Host "File saved at" $filepathTmp
        # Unpack our zip-Archive
        Invoke-Expression "& `"7z`" x ${filepathTmp} -oC:\Users\${env:UserName}\Downloads"
        # Move files into the right destination (libraries & headers)
        Move-Item -Path "C:\Users\${env:UserName}\Downloads\glfw-3.3.bin.WIN${architecture}\lib-vc2017\glfw3.dll" -Destination "${filepath}"
        # Remove temporary created files
        Remove-item -LiteralPath $filepathTmp
        # Remove-item -LiteralPath  "C:\Users\${env:UserName}\Downloads\glfw-3.3.bin.WIN${architecture}"
    } else {
        # Retry once to get the error message if any at the last try
        $webclient.DownloadFile($url, $filepathTmp)
    }
}


function main () {
    DownloadOpenGL "64"
}

main