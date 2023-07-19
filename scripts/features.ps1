$features = @(
    @{
        "name"= "TelnetClient"
        "action"="disable"
    }
    @{
        "name"= "DirectPlay"
        "action"="enable"
    }
)

function Set-WindowsFeatures{
    Param(
        [hashtable]
        $feature
    )
    switch ($feature["action"]) {
        "enable" {
            Enable-WindowsOptionalFeature $feature["name"]
        }
        "disable" {
            Disable-WindowsOptionalFeature $feature["name"]
        }
    }
}

foreach ($feature in $features) {
    Set-WindowsFeatures $feature
    Write-Host "Feature $($feature["name"]) $($feature["action"])"
}