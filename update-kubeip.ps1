# --- k3s on WSL portproxy updater ---

# WSL が起動していなければ起動
wsl -e bash -c "true" | Out-Null

# WSL の IP を取得
$wslIp = (wsl hostname -I).Trim().Split(" ")[0]

if (-not $wslIp) {
    Write-Error "WSL IP address not found"
    exit 1
}

Write-Host "WSL IP detected: $wslIp"

# portproxy を更新
netsh interface portproxy reset

netsh interface portproxy add `
  v4tov4 `
  listenaddress=127.0.0.1 `
  listenport=6443 `
  connectaddress=$wslIp `
  connectport=6443

Write-Host "portproxy updated: 127.0.0.1:6443 -> $wslIp:6443"

# --- k3s on WSL portproxy updater ---
netsh interface portproxy add `
  v4tov4 `
  listenaddress=127.0.0.1 `
  listenport=80 `
  connectaddress=$wslIp `
  connectport=80

Write-Host "portproxy updated: 127.0.0.1:80 -> $wslIp:80"