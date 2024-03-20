#### Travis Barnette 011143725
try {
    function Show-Menu {
        # small function for showing the options 
        Write-Host "Select an option:"
        Write-Host "1. List .log files in 'Requirements1' and append to 'DailyLog.txt'"
        Write-Host "2. List files in 'Requirements1' in a table, output to 'C916contents.txt'"
        Write-Host "3. List current CPU and memory usage"
        Write-Host "4. List running processes, sorted by virtual size"
        Write-Host "5. Exit"
    }

    $userInput = 0 
    while ($userInput -ne "5") {
        Show-Menu
        $userInput = Read-Host "Enter your choice (1-5)"
        switch ($userInput) {
            "1" {
                Write-Host "You've Selected Option 1"
                # calculate current date and format
                $currentDate = Get-Date -Format "dd-MM-yyyy HH:mm"
                # Use regular expression to list files in the current folder (directory) with .log ext   
                $regexPattern = "*.log"
                
                $files = Get-ChildItem -File -Filter "$($regexPattern)" -Recurse
                # get current working directory
                $filePath = "$PWD/DailyLog.txt"
                Write "Logs will be added to $filePath"
                Write-Host "======= Processing Logs =======`n`n`n"

                $numberOfFiles = $files.Count
                Write-Host "Log Files Found $($numberOfFiles) `n`n`n"
                # write date to log file 

                $currentDate | Out-File -FilePath $filePath -Append
                # loop files
                foreach ($file in $files) {
                    #append files to the log file 
                    $file.FullName | Out-File -FilePath $filePath -Append
                }
                # notify user when done 
                Write-Host "Log files have been added to the DailyLog" -ForegroundColor Green
            }
            "2" {
                Write-Host "You've Selected Option 2"
                # get the items in the current working directory sort them by their name,        push to out file DO NOT APPEND 
                Get-ChildItem -Path $PWD | Sort-Object -Property Name | Format-Table -AutoSize | Out-File -FilePath "$PWD/C916contents.txt"
                Write-Host "Files listed in tabular format and saved to C916contents.txt"
                # list files inside requirements1 folder in tabular format, sorted in ascending a-z order.
                # Direct output into C916contents.txt found in this directory
            }
            "3" {
                Write-Host "You've Selected Option 3"
                Write-Host "Current CPU and Memory Usage on Machine:"

                # I'm running on a mac machine so I needed this
                # top -l 1 | grep "CPU usage"  # Displays CPU usage
                # top -l 1 | grep "PhysMem"    # Displays memory usage
                # On windows machine you would use something with the WmiObject 
                # This uses the get information from the wmi repo to get information about the performance of the processor. 
                # Then you use select object to filter the information (there's a lot) to the properties we want
                # Finally you can use format table to make it pretty for the user. 
                Get-WmiObject -Class Win32_PerfFormattedData_PerfOS_Processor | Select-Object -Property Name, PercentProcessorTime | Format-Table -AutoSize
                Get-WmiObject -Class Win32_OperatingSystem | Select-Object -Property FreePhysicalMemory, TotalVisibleMemorySize | Format-Table -AutoSize
            }
            "4" {
                
                Write-Host "You've Selected Option 4"

                Get-Process | Sort-Object -Property VM -Descending | Format-Table -AutoSize
                # List all the different running processes inside your system sort the output by virutal size used least to greatest
                # display in grid format
            }
            "5" {
                Write-Host "You've Selected Option 5"
                Write-Host "Exitting..."
                break

            }
        }
    }
} catch [System.OutOfMemoryException]{

    Write-Host "An OutOfMemoryException occurred. Please free up memory and try again."

    # Error Handler
}
#