# First and Last Name - Student ID

while ($true) {
    $input = Read-Host "Enter a number (1-5) to choose an action, or press 5 to exit:`n  1. List log files with current date`n  2. List contents of Requirements1 folder in tabular format`n  3. Display current CPU and memory usage`n  4. List running processes sorted by virtual size`n  5. Exit"
    switch ($input) {
        1 {
            # List log files with current date
            Get-ChildItem -Path '.\Requirements1\*.log' -Force | % {
                "$(Get-Date) - $_.Name"
            } | Out-File -FilePath '.\Requirements1\DailyLog.txt' -Append
        }
        2 {
            # List contents of Requirements1 folder in tabular format
            Get-ChildItem -Path '.\Requirements1\*' | Sort-Object -Property Name | Format-Table -Property Name | Out-File -FilePath '.\Requirements1\C916contents.txt'
        }
        3 {
            # Display current CPU and memory usage
            Get-WmiObject -Class Win32_Processor | Select-Object -Property LoadPercentage, Name
            Get-WmiObject -Class Win32_OperatingSystem | Select-Object -Property FreePhysicalMemory, TotalVisibleMemorySize | % {
                "{0:N2}% free memory" -f (($_.FreePhysicalMemory / $_.TotalVisibleMemorySize) * 100)
            }
        }
        4 {
            # List running processes sorted by virtual size
            Get-Process | Sort-Object -Property WS | Format-Table -Property ProcessName, WS -AutoSize
        }
        5 {
            # Exit
            break
        }
        default {
            Write-Warning "Invalid input. Please try again."
        }
    }
}

try {
    # Add code that might throw a System.OutOfMemoryException here
} catch [System.OutOfMemoryException] {
    Write-Warning "An out-of-memory exception occurred. Please ensure that you have sufficient memory available and try again."
}
