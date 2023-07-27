$features = @(
    @{
        "name"= "TelnetClient"
        "action"="disable"
    }
    @{
        "name"= "File-Services"
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
            Enable-WindowsOptionalFeature -FeatureName $feature["name"] -Online
        }
        "disable" {
            Disable-WindowsOptionalFeature -FeatureName $feature["name"] -Online
        }
    }
}

foreach ($feature in $features) {
    Set-WindowsFeatures $feature
    Write-Host "Feature $($feature["name"]) $($feature["action"])"
}