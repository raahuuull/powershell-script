$startDate = (Get-Date).AddMonths(-2)  # Change -2 to -1 for last 1 month
$events = Get-WinEvent -FilterHashtable @{
    LogName='System'
    Id=6005,6006
    StartTime=$startDate
} | Sort-Object TimeCreated

$uptimeRecords = @()
$lastBoot = $null

foreach ($event in $events) {
    if ($event.Id -eq 6005) {
        $lastBoot = $event.TimeCreated
    }
    elseif ($event.Id -eq 6006 -and $lastBoot) {
        $uptime = $lastBoot - $event.TimeCreated
        $uptimeRecords += [PSCustomObject]@{
            'Start Time' = $event.TimeCreated
            'End Time'   = $lastBoot
            'Uptime'     = $uptime
        }
        $lastBoot = $null
    }
}

$uptimeRecords | Format-Table -AutoSize
