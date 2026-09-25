param (
    [string]$RustVersion,
    [string]$HermitStdlib
)

$RUSTC_SYSROOT=$(rustc +$RustVersion --print=sysroot)
mkdir -Force "$env:TEMP\hermitstd_install\"
tar -xvzf $HermitStdlib -C "$env:TEMP\hermitstd_install\"
$componentsDirectory = "$env:TEMP\hermitstd_install\rust-std-$RustVersion-x86_64-unknown-hermit"
$componentName = "rust-std-x86_64-unknown-hermit"

function Install-RustComponent($component) {
    $sourcePath = Join-Path -Path $componentsDirectory -ChildPath $component
    $manifestFile = Join-Path -Path $sourcePath -ChildPath "manifest.in"
    Copy-Item -Path $manifestFile -Destination "$RUSTC_SYSROOT\lib\rustlib\manifest_$component" -Force
    if (Test-Path $sourcePath) {
        Write-Host "Installing component $component"
        Copy-Item -Path "$sourcePath\lib" -Destination "$RUSTC_SYSROOT\" -Recurse -Force
    } else {
        Write-Host "Component $component not found at $sourcePath"
    }

    Add-Content -Path "$RUSTC_SYSROOT\lib\rustlib\components" -Value "$component"  
}
Install-RustComponent $componentName
