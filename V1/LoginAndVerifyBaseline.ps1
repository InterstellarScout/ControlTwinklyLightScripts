

# Function to fetch Gestalt information
function Get-Gestalt {
    param (
        [string]$IpAddress
    )

    # Define the URL
    $url = "$IpAddress/xled/v1/gestalt"
    Write-Output "Attempting to contact $url"

    # Define the headers
    $headers = @{
        "Host"              = $IpAddress
        "Accept"            = "application/json, text/plain, */*"
        "User-Agent"        = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) LumiaStream/8.2.0 Chrome/126.0.6478.234 Electron/31.7.5 Safari/537.36"
        "Accept-Encoding"   = "gzip, deflate"
        "Accept-Language"   = "en-US"
    }

    # Send the GET request
    try {
        $response = Invoke-WebRequest -Uri $url -Method GET -Headers $headers -ErrorAction Stop
        $responseContent = $response.Content | ConvertFrom-Json
        Write-Output "Response from $IpAddress is:"
        Write-Output $responseContent
    } catch {
        Write-Warning "Failed to retrieve data from $IpAddress. Error: $_"
    }
}


function Get-AuthenticationToken {
    param (
        [Parameter(Mandatory = $true)]
        [string]$IpAddress
    )

    # Define the URL
    $url = "$IpAddress/xled/v1/login"

    # Define the headers
    $headers = @{
        Host            = $IpAddress
        Accept          = "application/json, text/plain, */*"
        "User-Agent"    = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) LumiaStream/8.2.0 Chrome/126.0.6478.234 Electron/31.7.5 Safari/537.36"
        address         = $IpAddress
        "Content-Type"  = "application/json"
        "Accept-Encoding" = "gzip, deflate"
        "Accept-Language" = "en-US"
    }

    # Define the body
    $body = @{
        challenge = "AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHr8="
    } | ConvertTo-Json -Depth 10 -Compress

    try {
        # Make the POST request
        $response = Invoke-RestMethod -Uri $url -Method POST -Headers $headers -Body $body

        # Extract the authentication token
        $authentication_token = $response.authentication_token

        # Return the authentication token
        return $authentication_token
    } catch {
        # Handle errors
        Write-Error "Failed to get authentication token for IP $IpAddress is: $_"
        return $null
    }
}

function Verify-AuthenticationToken {
    param (
        [Parameter(Mandatory = $true)]
        [string]$IpAddress,

        [Parameter(Mandatory = $true)]
        [string]$AuthToken
    )

    # Define the URL
    $url = "$IpAddress/xled/v1/verify"

    # Define the headers
    $headers = @{
        Host            = $IpAddress
        Accept          = "application/json, text/plain, */*"
        "User-Agent"    = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) LumiaStream/8.2.0 Chrome/126.0.6478.234 Electron/31.7.5 Safari/537.36"
        address         = "http://$IpAddress"
        "Content-Type"  = "application/json"
        "Accept-Encoding" = "gzip"
        "Accept-Language" = "en-US"
        "X-Auth-Token"  = $AuthToken
    }

    # Define the body
    $body = @{
        challenge = "AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHr8="
    } | ConvertTo-Json -Depth 10 -Compress

    try {
        # Make the POST request
        $response = Invoke-RestMethod -Uri $url -Method POST -Headers $headers -Body $body

        # Check the response for success
        if ($response.code -eq 1000) {
            Write-Output "Token is valid."
            return $true
        } else {
            Write-Warning "Token verification failed. Server response code: $($response.code)"
            return $false
        }
    } catch {
        # Handle errors
        Write-Error "Failed to verify authentication token for IP $IpAddress is: $_"
        return $false
    }
}




# Define the list of IP addresses
$ipAddresses = @("192.168.68.176", "192.168.68.175", "192.168.68.158", "192.168.68.143")  # Add more IPs as needed

# Use ForEach-Object -Parallel for concurrent processing
$results = $ipAddresses | ForEach-Object -Parallel {
    # Import necessary functions in the parallel runspace
    # Ensure all functions are available in the runspace
    $token = Get-AuthenticationToken -IpAddress $_
    if ($token) {
        $isVerified = Verify-AuthenticationToken -IpAddress $_ -AuthToken $token
        if ($isVerified) {
            $movieMode = Set-MovieMode -IpAddress $_ -AuthToken $token
            if ($movieMode) {
                $movies = Get-Movies -IpAddress $_ -AuthToken $token
                if ($movies) {
                    $movieToSet = $movies | Where-Object { $_.name -eq "RainbowVortex" }
                    if ($movieToSet) {
                        Set-CurrentMovie -IpAddress $_ -AuthToken $token -UniqueId $movieToSet.unique_id
                    } else {
                        Write-Warning "Movie 'RainbowVortex' not found for IP $_."
                    }
                } else {
                    Write-Warning "No movies retrieved for IP $_."
                }
            } else {
                Write-Warning "Failed to set movie mode for IP $_."
            }
        } else {
            Write-Warning "Token verification failed for IP $_."
        }
    } else {
        Write-Error "Failed to retrieve authentication token for IP $_."
    }
} -ThrottleLimit 5  # Adjust concurrency level

# Display results (if any)
$results
