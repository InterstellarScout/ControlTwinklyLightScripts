




function Get-AuthenticationToken {
    param (
        [Parameter(Mandatory = $true)]
        [string]$IpAddress
    )

    # Define the URL
    $url = "http://$IpAddress/xled/v1/login"

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
    $url = "http://$IpAddress/xled/v1/verify"

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

function Get-Movies {
    param (
        [Parameter(Mandatory = $true)]
        [string]$IpAddress,

        [Parameter(Mandatory = $true)]
        [string]$AuthToken
    )

    # Define the URL
    $url = "http://$IpAddress/xled/v1/movies"

    # Define the headers
    $headers = @{
        Host            = $IpAddress
        Accept          = "application/json, text/plain, */*"
        "User-Agent"    = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) LumiaStream/8.2.0 Chrome/126.0.6478.234 Electron/31.7.5 Safari/537.36"
        address         = $IpAddress
        "Content-Type"  = "application/json"
        "Accept-Encoding" = "gzip, deflate"
        "Accept-Language" = "en-US"
        "X-Auth-Token"  = $AuthToken
    }

    try {
        # Make the GET request
        $response = Invoke-RestMethod -Uri $url -Method GET -Headers $headers

        # Check the response
        if ($response.code -eq 1000) {
            Write-Output "Movies retrieved successfully."
            return $response.movies
        } else {
            Write-Warning "Failed to retrieve movies. Server response code: $($response.code)"
            return $null
        }
    } catch {
        # Handle errors
        Write-Error "Failed to retrieve movies for IP $IpAddress is: $_"
        return $null
    }
}

function Set-MovieMode {
    param (
        [Parameter(Mandatory = $true)]
        [string]$IpAddress,

        [Parameter(Mandatory = $true)]
        [string]$AuthToken
    )

    # Define the URL
    $url = "http://$IpAddress/xled/v1/led/mode"

    # Define the headers
    $headers = @{
        Host            = $IpAddress
        Accept          = "application/json, text/plain, */*"
        "User-Agent"    = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) LumiaStream/8.2.0 Chrome/126.0.6478.234 Electron/31.7.5 Safari/537.36"
        address         = $IpAddress
        "Content-Type"  = "application/json"
        "Accept-Encoding" = "gzip, deflate"
        "Accept-Language" = "en-US"
        "X-Auth-Token"  = $AuthToken
    }

    # Define the body
    $body = @{
        mode = "movie"
    } | ConvertTo-Json -Depth 10 -Compress

    try {
        # Make the POST request
        $response = Invoke-RestMethod -Uri $url -Method POST -Headers $headers -Body $body

        # Check the response
        if ($response.code -eq 1000) {
            Write-Output "Successfully switched to movie mode."
            return $true
        } else {
            Write-Output "Failed to switch to movie mode. Server response code: $($response.code)"
            Write-Warning "Failed to switch to movie mode. Server response code: $($response.code)"
            return $false
        }
    } catch {
        # Handle errors
        Write-Output "Failed to switch to movie mode for IP $IpAddress is: $_"
        Write-Error "Failed to switch to movie mode for IP $IpAddress is: $_"
        return $false
    }
}


function Set-CurrentMovie {
    param (
        [Parameter(Mandatory = $true)]
        [string]$IpAddress,

        [Parameter(Mandatory = $true)]
        [string]$AuthToken,

        [Parameter(Mandatory = $true)]
        [string]$UniqueId
    )

    # Define the URL
    $url = "http://$IpAddress/xled/v1/movies/current"

    # Define the headers
    $headers = @{
        Host            = $IpAddress
        Accept          = "application/json, text/plain, */*"
        "User-Agent"    = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) LumiaStream/8.2.0 Chrome/126.0.6478.234 Electron/31.7.5 Safari/537.36"
        address         = $IpAddress
        "Content-Type"  = "application/json"
        "Accept-Encoding" = "gzip, deflate"
        "Accept-Language" = "en-US"
        "X-Auth-Token"  = $AuthToken
    }

    # Define the body
    $body = @{
        unique_id = $UniqueId
    } | ConvertTo-Json -Depth 10 -Compress

    try {
        # Make the POST request
        $response = Invoke-RestMethod -Uri $url -Method POST -Headers $headers -Body $body

        # Check the response
        if ($response.code -eq 1000) {
            Write-Output "Movie with unique_id '$UniqueId' set successfully."
            return $true
        } else {
            Write-Warning "Failed to set the movie. Server response code: $($response.code)"
            return $false
        }
    } catch {
        # Handle errors
        Write-Error "Failed to set the movie for IP $IpAddress is: $_"
        return $false
    }
}



# Define the list of IP addresses
$ipAddresses = @("192.168.68.176", "192.168.68.175", "192.168.68.158", "192.168.68.143")  # Add more IPs as needed

foreach ($ip in $ipAddresses) {
    Write-Output "Processing IP: $ip"

    $token = Get-AuthenticationToken -IpAddress $ip

    if ($token) {
        $isVerified = Verify-AuthenticationToken -IpAddress $ip -AuthToken $token
        if ($isVerified) {
            # Switch to movie mode
            $movieMode = Set-MovieMode -IpAddress $ip -AuthToken $token
            if ($movieMode) {
                Write-Output "The LED at $ip is now in movie mode."

                # Retrieve the list of movies
                $movies = Get-Movies -IpAddress $ip -AuthToken $token

                if ($movies) {
                    # Find the "RainbowVortex" movie
                    $movieToSet = $movies | Where-Object { $_.name -eq "Sparkling 0" }
                    if ($movieToSet) {
                        # Set the "RainbowVortex" movie as the current movie
                        $setMovie = Set-CurrentMovie -IpAddress $ip -AuthToken $token -UniqueId $movieToSet.unique_id
                        if ($setMovie) {
                            Write-Output "Successfully set the current movie to 'RainbowVortex' for IP $ip."
                        } else {
                            Write-Warning "Failed to set the movie 'RainbowVortex' for IP $ip."
                        }
                    } else {
                        Write-Warning "Movie 'RainbowVortex' not found for IP $ip."
                    }
                } else {
                    Write-Warning "No movies retrieved for IP $ip. Cannot set a movie."
                }
            } else {
                Write-Warning "Failed to set the LED to movie mode for IP $ip."
            }
        } else {
            Write-Warning "Token verification failed for IP $ip. Cannot proceed to set movie mode or movie."
        }
    } else {
        Write-Error "Failed to retrieve authentication token for IP $ip."
    }

    Write-Output "Completed processing for IP: $ip"
    Write-Output "---------------------------------------------"
}
