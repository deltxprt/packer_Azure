$registries = @(
    [pscustomobject]@{
        path   = "HKLM:\SOFTWARE"
        key    = "folder1"
        value  = $null
        action = "create"
    },
    [pscustomobject]@{
        path   = "HKLM:\SOFTWARE\folder1"
        key    = "key1"
        value  = "1"
        action = "create"
    },
    [pscustomobject]@{
        path   = "HKLM:\SOFTWARE\folder1"
        key    = "key2"
        value  = "2"
        action = "create"
    }
)

function update-registry {
    param (
        $path,
        $key,
        $value,
        [ValidateSet("update","create","delete")]
        $action
    )
    switch ($action) {
        "update" {
            $result = Set-ItemProperty -Path $path -Name $key -Value $value
        } 
        "create" {
            $Exist = Test-Path "$path\$value"
            if($value -and !$Exist){$result = New-ItemProperty -path $path -Name $key -Value $value -PropertyType "DWORD"}
            elseif($Exist -and $value){$result = Set-ItemProperty -Path $path -Name $key -Value $value}
            elseif($exist){$result = New-Item -Path $path -Name $key -ItemType Directory}
            
        }
        "delete" {
            $result = Remove-ItemProperty -Path $path -Name $key -Value $value
        }
    }
    return $result
}


$registries | ForEach-Object {
    $param = $null
    $param = @{
        path = $_.path
        key  = $_.key
        value = $_.value
        action = $_.action
    }
    update-registry @param
    Write-Host "$($_.action) $($_.key) in $($_.path) with value: $($_.value)"
}