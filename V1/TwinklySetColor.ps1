




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

function Set-Color {
    param (
        [Parameter(Mandatory = $true)]
        [string]$IpAddress,

        [Parameter(Mandatory = $true)]
        [string]$AuthToken,

        [Parameter(Mandatory = $true)]
        [int]$Red,

        [Parameter(Mandatory = $true)]
        [int]$Green,

        [Parameter(Mandatory = $true)]
        [int]$Blue,

        [Parameter(Mandatory = $true)]
        [int]$Brightness
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
        mode = "color"
        color_config = @{
            red   = $Red
            green = $Green
            blue  = $Blue
        }
        brightness = $Brightness
    } | ConvertTo-Json -Depth 10 -Compress

    try {
        # Make the POST request
        $response = Invoke-RestMethod -Uri $url -Method POST -Headers $headers -Body $body

        # Check the response for success
        if ($response.code -eq 1000) {
            Write-Output "Color successfully set to Red=$Red, Green=$Green, Blue=$Blue with Brightness=$Brightness."
            return $true
        } else {
            Write-Warning "Failed to set color. Server response code: $($response.code)"
            return $false
        }
    } catch {
        # Handle errors
        Write-Error "Failed to set color for IP $IpAddress is $_"
        return $false
    }
}

# Define the list of IP addresses
$ipAddresses = @("192.168.68.176", "192.168.68.175", "192.168.68.158", "192.168.68.143")  # Add more IPs as needed

foreach ($ip in $ipAddresses) {
    Write-Output "Processing IP: $ip"
	$token = Get-AuthenticationToken -ip $ip

	if ($token) {
		$isVerified = Verify-AuthenticationToken -IpAddress $ip -AuthToken $token
		if ($isVerified) {
			$setColor = Set-Color -IpAddress $ip -AuthToken $token -Red 255 -Green 0 -Blue 0 -Brightness 100
			if ($setColor) {
				Write-Output "Color configuration was successfully applied!"
			} else {
				Write-Warning "Failed to set the color configuration."
			}
		} else {
			Write-Warning "Token verification failed. Cannot proceed with setting the color."
		}
	} else {
		Write-Error "Failed to retrieve authentication token."
	}
}