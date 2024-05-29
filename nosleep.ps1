Add-Type @"
using System;
using System.Runtime.InteropServices;
public class PowerManagement {
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern uint SetThreadExecutionState(uint esFlags);
    public const uint ES_CONTINUOUS = 0x80000000;
    public const uint ES_SYSTEM_REQUIRED = 0x00000001;
    public const uint ES_DISPLAY_REQUIRED = 0x00000002;
}
"@

function Display-On {
    Write-Host "Always On"
    [PowerManagement]::SetThreadExecutionState([PowerManagement]::ES_CONTINUOUS -bor [PowerManagement]::ES_DISPLAY_REQUIRED)
    $form.WindowState = 'Minimized'
}

function Display-Reset {
    [PowerManagement]::SetThreadExecutionState([PowerManagement]::ES_CONTINUOUS)
    $form.Close()
}

# Create a Windows Form
Add-Type -AssemblyName System.Windows.Forms
$form = New-Object System.Windows.Forms.Form
$form.Text = "Display App"
$form.Size = New-Object System.Drawing.Size(200, 60)
$form.StartPosition = "CenterScreen"

# Create a panel
$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = 'Top'
$form.Controls.Add($panel)

# Create the "Always ON" button
$alwaysOnButton = New-Object System.Windows.Forms.Button
$alwaysOnButton.Text = "Always ON"
$alwaysOnButton.Add_Click({ Display-On })
$panel.Controls.Add($alwaysOnButton)

# Create the "Quit" button
$quitButton = New-Object System.Windows.Forms.Button
$quitButton.Text = "Quit"
$quitButton.ForeColor = 'Red'
$quitButton.Add_Click({ Display-Reset })
$panel.Controls.Add($quitButton)

# Layout the buttons
$alwaysOnButton.Dock = 'Left'
$quitButton.Dock = 'Right'

# Show the form
[void]$form.ShowDialog()
