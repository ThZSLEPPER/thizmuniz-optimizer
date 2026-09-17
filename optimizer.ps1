# =====================================================================
# THIZMUNIZ OPTIMIZER - SEU UTILITARIO EXCLUSIVO DE DESEMPENHO
# Versao corrigida: elevacao de admin, tratamento de erros, UI responsiva
# =====================================================================

# ---------------------------------------------------------------------
# 1) GARANTIR EXECUCAO COMO ADMINISTRADOR (senao, a maioria das acoes falha)
# ---------------------------------------------------------------------
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    $psi.Verb = "runas"
    try {
        [System.Diagnostics.Process]::Start($psi) | Out-Null
    } catch {
        [System.Windows.Forms.MessageBox]::Show("E necessario permitir a execucao como Administrador para usar o ThizMuniz Optimizer.", "Permissao negada") | Out-Null
    }
    exit
}

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2000/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2000/xaml"
        Title="ThizMuniz Optimizer - Configuracoes e Jogos" Height="480" Width="600"
        Background="#121212" WindowStartupLocation="CenterScreen" ResizeMode="NoResize">
    <Grid>
        <TabControl Background="#1a1a1a" BorderBrush="#333333" Margin="10,10,10,50">
            <TabItem Header="Instalacoes" Width="120" Background="#2d2d2d" Foreground="White">
                <Grid Margin="15">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    <StackPanel Grid.Column="0" VerticalAlignment="Top">
                        <TextBlock Text="Aplicativos" FontSize="14" FontWeight="Bold" Foreground="Cyan" Margin="0,0,0,10"/>
                        <CheckBox Name="ChkBrave" Content="Brave Browser" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="ChkDiscord" Content="Discord" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="ChkSteam" Content="Steam" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="ChkVLC" Content="VLC Media Player" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="ChkWinRAR" Content="WinRAR" Foreground="White" Margin="0,5,0,5"/>
                    </StackPanel>
                    <StackPanel Grid.Column="1" VerticalAlignment="Top">
                        <TextBlock Text="Componentes de Sistema" FontSize="14" FontWeight="Bold" Foreground="Cyan" Margin="0,0,0,10"/>
                        <CheckBox Name="ChkVC" Content="Visual C++ Runtimes (Todos)" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="ChkJava" Content="Java Runtime" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="ChkNet" Content=".NET Framework 4.8" Foreground="White" Margin="0,5,0,5"/>
                    </StackPanel>
                    <Button Name="BtnInstalar" Content="Instalar Selecionados" Grid.ColumnSpan="2" VerticalAlignment="Bottom" Height="40"
                            Background="#222222" Foreground="White" FontWeight="Bold" BorderBrush="Cyan" BorderThickness="1"/>
                </Grid>
            </TabItem>
            <TabItem Header="Otimizacoes" Width="120" Background="#2d2d2d" Foreground="White">
                <Grid Margin="15">
                    <StackPanel VerticalAlignment="Top">
                        <TextBlock Text="Marque o que deseja otimizar para Jogos" FontSize="14" FontWeight="Bold" Foreground="Cyan" Margin="0,0,0,10"/>
                        <CheckBox Name="OptEnergia" Content="Ativar Plano de Energia de Desempenho Maximo" Foreground="White" Margin="0,5,0,5" IsChecked="True"/>
                        <CheckBox Name="OptInterface" Content="Remover Widgets e Copilot da Barra de Tarefas" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="OptEdge" Content="Desinstalar e Bloquear o Microsoft Edge" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="OptServicos" Content="Desativar Servicos Inuteis de Segundo Plano (Print/Fax)" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="OptVBS" Content="Desativar Isolamento de Nucleo (VBS) - Latencia CPU" Foreground="White" Margin="0,5,0,5"/>
                    </StackPanel>
                    <Button Name="BtnOtimizar" Content="Aplicar Ajustes de Desempenho" VerticalAlignment="Bottom" Height="40"
                            Background="#222222" Foreground="White" FontWeight="Bold" BorderBrush="Cyan" BorderThickness="1"/>
                </Grid>
            </TabItem>
        </TabControl>
        <StatusBar Background="#0d0d0d" VerticalAlignment="Bottom" Height="35">
            <StatusBarItem>
                <TextBlock Name="TxtStatus" Text="ThizMuniz Optimizer pronto. Escolha uma aba para iniciar." Foreground="#888888" FontWeight="Medium" Margin="10,0,0,0"/>
            </StatusBarItem>
        </StatusBar>
    </Grid>
</Window>
"@

$Reader = New-Object System.Xml.XmlNodeReader $XAML
$Form = [Windows.Markup.XamlReader]::Load($Reader)

$ChkBrave = $Form.FindName("ChkBrave"); $ChkDiscord = $Form.FindName("ChkDiscord"); $ChkSteam = $Form.FindName("ChkSteam")
$ChkVLC = $Form.FindName("ChkVLC"); $ChkWinRAR = $Form.FindName("ChkWinRAR")
$ChkVC = $Form.FindName("ChkVC"); $ChkJava = $Form.FindName("ChkJava"); $ChkNet = $Form.FindName("ChkNet")
$BtnInstalar = $Form.FindName("BtnInstalar")

$OptEnergia = $Form.FindName("OptEnergia"); $OptInterface = $Form.FindName("OptInterface"); $OptEdge = $Form.FindName("OptEdge")
$OptServicos = $Form.FindName("OptServicos"); $OptVBS = $Form.FindName("OptVBS"); $BtnOtimizar = $Form.FindName("BtnOtimizar")
$TxtStatus = $Form.FindName("TxtStatus")

# ---------------------------------------------------------------------
# Helper: atualiza o texto de status e FORCA o WPF a redesenhar
# (sem isso, a janela "trava" visualmente durante operacoes longas)
# ---------------------------------------------------------------------
function Update-Status {
    param([string]$Text, [string]$Color = "#888888")
    $TxtStatus.Text = $Text
    $TxtStatus.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($Color)
    $Form.Dispatcher.Invoke([System.Windows.Threading.DispatcherPriority]::Background, [action]{})
}

function Test-WingetDisponivel {
    $null = Get-Command winget -ErrorAction SilentlyContinue
    return $?
}

function Install-ComWinget {
    param([string]$Id, [string]$Nome)
    Update-Status "Instalando $Nome... Aguarde." "Yellow"
    try {
        $proc = Start-Process -FilePath "winget" -ArgumentList "install --id $Id --silent --accept-source-agreements --accept-package-agreements" -Wait -PassThru -NoNewWindow
        if ($proc.ExitCode -ne 0) { throw "winget retornou codigo $($proc.ExitCode)" }
        return $true
    } catch {
        Update-Status "Falha ao instalar $Nome`: $($_.Exception.Message)" "OrangeRed"
        Start-Sleep -Milliseconds 1200
        return $false
    }
}

$BtnInstalar.Add_Click({
    $BtnInstalar.IsEnabled = $false
    if (-not (Test-WingetDisponivel)) {
        Update-Status "winget nao foi encontrado neste sistema. Instale o 'App Installer' pela Microsoft Store." "OrangeRed"
        $BtnInstalar.IsEnabled = $true
        return
    }

    $erros = @()

    if ($ChkBrave.IsChecked)   { if (-not (Install-ComWinget "Brave.Brave" "Brave Browser")) { $erros += "Brave" } }
    if ($ChkDiscord.IsChecked) { if (-not (Install-ComWinget "Discord.Discord" "Discord")) { $erros += "Discord" } }
    if ($ChkSteam.IsChecked)   { if (-not (Install-ComWinget "Valve.Steam" "Steam")) { $erros += "Steam" } }
    if ($ChkVLC.IsChecked)     { if (-not (Install-ComWinget "VideoLAN.VLC" "VLC Media Player")) { $erros += "VLC" } }
    if ($ChkWinRAR.IsChecked)  { if (-not (Install-ComWinget "RARLab.WinRAR" "WinRAR")) { $erros += "WinRAR" } }
    if ($ChkVC.IsChecked)      { if (-not (Install-ComWinget "Microsoft.VCRedist.2015+.x64" "Visual C++ Runtimes")) { $erros += "Visual C++" } }
    if ($ChkJava.IsChecked)    { if (-not (Install-ComWinget "Oracle.JavaRuntimeEnvironment" "Java Runtime")) { $erros += "Java" } }

    if ($ChkNet.IsChecked) {
        # .NET Framework 4.8 nao e um "recurso opcional" instalavel via
        # Enable-WindowsOptionalFeature. Verificamos a versao instalada via
        # registro e, se necessario, baixamos o instalador offline oficial.
        Update-Status "Verificando .NET Framework 4.8..." "Yellow"
        try {
            $release = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction Stop).Release
            if ($release -ge 528040) {
                Update-Status ".NET Framework 4.8 ja esta instalado." "LightGreen"
            } else {
                Update-Status "Baixando instalador do .NET Framework 4.8..." "Yellow"
                $url = "https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/NDP48-x86-x64-AllOS-ENU.exe"
                $dest = "$env:TEMP\NDP48-x86-x64-AllOS-ENU.exe"
                Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
                Update-Status "Instalando .NET Framework 4.8 (pode reiniciar o PC)..." "Yellow"
                Start-Process -FilePath $dest -ArgumentList "/q /norestart" -Wait
            }
        } catch {
            Update-Status "Falha ao instalar .NET Framework 4.8: $($_.Exception.Message)" "OrangeRed"
            $erros += ".NET Framework 4.8"
            Start-Sleep -Milliseconds 1200
        }
    }

    if ($erros.Count -eq 0) {
        Update-Status "Instalacoes concluidas com sucesso!" "LightGreen"
    } else {
        Update-Status "Concluido com falhas em: $($erros -join ', ')" "OrangeRed"
    }
    $BtnInstalar.IsEnabled = $true
})

$BtnOtimizar.Add_Click({
    $BtnOtimizar.IsEnabled = $false
    $erros = @()

    if ($OptVBS.IsChecked) {
        $confirma = [System.Windows.Forms.MessageBox]::Show(
            "Desativar o VBS (Isolamento de Nucleo) reduz a seguranca do sistema em troca de menor latencia. Deseja continuar?",
            "Confirmar", "YesNo", "Warning")
        if ($confirma -eq "Yes") {
            Update-Status "Desativando Isolamento de Nucleo (VBS)..." "Yellow"
            try {
                if (-not (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard")) {
                    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Force | Out-Null
                }
                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "EnableVirtualizationBasedSecurity" -Value 0 -Force
            } catch {
                $erros += "VBS"
                Update-Status "Falha ao desativar VBS: $($_.Exception.Message)" "OrangeRed"
                Start-Sleep -Milliseconds 1000
            }
        }
    }

    if ($OptEnergia.IsChecked) {
        Update-Status "Ativando plano de energia de Desempenho Maximo..." "Yellow"
        try {
            powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
            powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
        } catch {
            $erros += "Plano de Energia"
            Update-Status "Falha ao ativar plano de energia: $($_.Exception.Message)" "OrangeRed"
            Start-Sleep -Milliseconds 1000
        }
    }

    if ($OptInterface.IsChecked) {
        Update-Status "Removendo Widgets e Copilot da barra de tarefas..." "Yellow"
        try {
            # Caminho correto (faltava \Explorer\ no original)
            $advPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            if (-not (Test-Path $advPath)) { New-Item -Path $advPath -Force | Out-Null }
            Set-ItemProperty -Path $advPath -Name "TaskbarDa" -Value 0 -Force
            Set-ItemProperty -Path $advPath -Name "ShowCopilotButton" -Value 0 -Force -ErrorAction SilentlyContinue
            # Reinicia o Explorer para as mudancas fazerem efeito imediatamente
            Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
            Start-Process explorer.exe
        } catch {
            $erros += "Widgets/Copilot"
            Update-Status "Falha ao remover Widgets/Copilot: $($_.Exception.Message)" "OrangeRed"
            Start-Sleep -Milliseconds 1000
        }
    }

    if ($OptEdge.IsChecked) {
        $confirma = [System.Windows.Forms.MessageBox]::Show(
            "Isso vai fechar, desinstalar e bloquear atualizacoes do Microsoft Edge. Deseja continuar?",
            "Confirmar", "YesNo", "Warning")
        if ($confirma -eq "Yes") {
            Update-Status "Removendo Microsoft Edge..." "Yellow"
            try {
                Stop-Process -Name "msedge" -ErrorAction SilentlyContinue
                if (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate")) {
                    New-Item -Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate" -Force | Out-Null
                }
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate" -Name "DoNotUpdateToEdgeWithChromium" -Value 1 -Force

                # Procura o instalador em ambos os locais possiveis (32 e 64 bits)
                $possiveisCaminhos = @(
                    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application",
                    "${env:ProgramFiles}\Microsoft\Edge\Application"
                )
                $EdgeInstaller = $null
                foreach ($p in $possiveisCaminhos) {
                    if (Test-Path $p) {
                        $found = Get-ChildItem -Path $p -Filter "setup.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
                        if ($found) { $EdgeInstaller = $found; break }
                    }
                }
                if ($EdgeInstaller) {
                    Start-Process -FilePath $EdgeInstaller.FullName -ArgumentList "--uninstall --system-level --force-uninstall --verbose-logging" -NoNewWindow -Wait
                } else {
                    throw "instalador do Edge nao encontrado (o Windows pode reinstala-lo automaticamente depois)"
                }
            } catch {
                $erros += "Edge"
                Update-Status "Falha ao remover Edge: $($_.Exception.Message)" "OrangeRed"
                Start-Sleep -Milliseconds 1200
            }
        }
    }

    if ($OptServicos.IsChecked) {
        Update-Status "Desativando servicos inuteis de segundo plano..." "Yellow"
        $Services = @("Spooler", "Fax", "SensorService", "RetailDemo", "LfSvc", "MapsBroker", "WerSvc", "DiagTrack", "dmwappushservice")
        foreach ($s in $Services) {
            try {
                if (Get-Service -Name $s -ErrorAction SilentlyContinue) {
                    Stop-Service -Name $s -Force -ErrorAction SilentlyContinue
                    Set-Service -Name $s -StartupType Disabled
                }
            } catch {
                $erros += $s
            }
        }
    }

    if ($erros.Count -eq 0) {
        Update-Status "Otimizacoes concluidas! E recomendavel reiniciar o computador." "LightGreen"
    } else {
        Update-Status "Concluido com falhas em: $($erros -join ', ')" "OrangeRed"
    }
    $BtnOtimizar.IsEnabled = $true
})

$Form.ShowDialog() | Out-Null
