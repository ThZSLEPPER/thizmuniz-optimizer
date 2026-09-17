# =====================================================================
# THIZMUNIZ OPTIMIZER - SEU UTILITÁRIO EXCLUSIVO DE DESEMPENHO
# =====================================================================

# 1. DEFINIÇÃO DA INTERFACE VISUAL AVANÇADA (XAML)
[xml]$XAML = @"
<Window xmlns="http://microsoft.com"
        xmlns:x="http://microsoft.com"
        Title="ThizMuniz Optimizer - Configurações e Jogos" Height="480" Width="600" 
        Background="#121212" WindowStartupLocation="CenterScreen" ResizeMode="NoResize">
    <Grid>
        <TabControl Background="#1a1a1a" BorderBrush="#333333" Margin="10,10,10,50">
            <!-- ABA 1: INSTALAR PROGRAMAS -->
            <TabItem Header="Instalações" Width="120" Background="#2d2d2d" Foreground="White">
                <Grid Margin="15">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="*"/>
                    </Grid.ColumnDefinitions>
                    
                    <!-- Navegadores e Apps -->
                    <StackPanel Grid.Column="0" VerticalAlignment="Top">
                        <TextBlock Text="Aplicativos" FontSize="14" FontWeight="Bold" Foreground="#Cyan" Margin="0,0,0,10"/>
                        <CheckBox Name="ChkBrave" Content="Brave Browser" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="ChkDiscord" Content="Discord" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="ChkSteam" Content="Steam" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="ChkVLC" Content="VLC Media Player" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="ChkWinRAR" Content="WinRAR" Foreground="White" Margin="0,5,0,5"/>
                    </StackPanel>
                    
                    <!-- Componentes e Runtimes -->
                    <StackPanel Grid.Column="1" VerticalAlignment="Top">
                        <TextBlock Text="Componentes de Sistema" FontSize="14" FontWeight="Bold" Foreground="#Cyan" Margin="0,0,0,10"/>
                        <CheckBox Name="ChkVC" Content="Visual C++ Runtimes (Todos)" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="ChkJava" Content="Java Runtime" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="ChkNet" Content=".NET Framework 4.8" Foreground="White" Margin="0,5,0,5"/>
                    </StackPanel>
                    
                    <Button Name="BtnInstalar" Content="Instalar Selecionados" Grid.ColumnSpan="2" VerticalAlignment="Bottom" Height="40"
                            Background="#222222" Foreground="White" FontWeight="Bold" BorderBrush="#Cyan" BorderThickness="1"/>
                </Grid>
            </TabItem>
            
            <!-- ABA 2: OTIMIZAÇÕES DO SISTEMA -->
            <TabItem Header="Otimizações" Width="120" Background="#2d2d2d" Foreground="White">
                <Grid Margin="15">
                    <StackPanel VerticalAlignment="Top">
                        <TextBlock Text="Marque o que deseja otimizar para Jogos" FontSize="14" FontWeight="Bold" Foreground="#Cyan" Margin="0,0,0,10"/>
                        
                        <CheckBox Name="OptEnergia" Content="Ativar Plano de Energia de Desempenho Máximo" Foreground="White" Margin="0,5,0,5" IsChecked="True"/>
                        <CheckBox Name="OptInterface" Content="Remover Widgets e Copilot da Barra de Tarefas" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="OptEdge" Content="Desinstalar e Bloquear o Microsoft Edge" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="OptServicos" Content="Desativar Serviços Inúteis de Segundo Plano (Print/Fax)" Foreground="White" Margin="0,5,0,5"/>
                        <CheckBox Name="OptVBS" Content="Desativar Isolamento de Núcleo (VBS) - Latência CPU" Foreground="White" Margin="0,5,0,5"/>
                    </StackPanel>
                    
                    <Button Name="BtnOtimizar" Content="Aplicar Ajustes de Desempenho" VerticalAlignment="Bottom" Height="40"
                            Background="#222222" Foreground="White" FontWeight="Bold" BorderBrush="#Cyan" BorderThickness="1"/>
                </Grid>
            </TabItem>
        </TabControl>
        
        <!-- BARRA DE STATUS INFERIOR GLOBAL -->
        <StatusBar Background="#0d0d0d" VerticalAlignment="Bottom" Height="35">
            <StatusBarItem>
                <TextBlock Name="TxtStatus" Text="ThizMuniz Optimizer pronto. Escolha uma aba para iniciar." Foreground="#888888" FontWeight="Medium" Margin="10,0,0,0"/>
            </StatusBarItem>
        </StatusBar>
    </Grid>
</Window>
"@

# 2. CONFIGURAR AMBIENTE E RENDERIZAR A INTERFACE
Add-Type -AssemblyName PresentationFramework
$Reader = New-Object System.Xml.XmlNodeReader $XAML
$Form = [Windows.Markup.XamlReader]::Load($Reader)

# Mapeando os CheckBoxes e Botões para usar dentro da lógica do PowerShell
$ChkBrave = $Form.FindName("ChkBrave"); $ChkDiscord = $Form.FindName("ChkDiscord"); $ChkSteam = $Form.FindName("ChkSteam")
$ChkVLC = $Form.FindName("ChkVLC"); $ChkWinRAR = $Form.FindName("ChkWinRAR")
$ChkVC = $Form.FindName("ChkVC"); $ChkJava = $Form.FindName("ChkJava"); $ChkNet = $Form.FindName("ChkNet")
$BtnInstalar = $Form.FindName("BtnInstalar")

$OptEnergia = $Form.FindName("OptEnergia"); $OptInterface = $Form.FindName("OptInterface"); $OptEdge = $Form.FindName("OptEdge")
$OptServicos = $Form.FindName("OptServicos"); $OptVBS = $Form.FindName("OptVBS"); $BtnOtimizar = $Form.FindName("BtnOtimizar")
$TxtStatus = $Form.FindName("TxtStatus")

# 3. LÓGICA DO BOTÃO DE INSTALAÇÃO (ABA 1)
$BtnInstalar.Add_Click({
    $TxtStatus.Foreground = [System.Windows.Media.Brushes]::Yellow
    
    # Executando instalações via Winget
    if ($ChkBrave.IsChecked) {
        $TxtStatus.Text = "Instalando Brave Browser... Aguarde."
        [void](winget install --id Brave.Brave --silent --accept-source-agreements --accept-package-agreements)
    }
    if ($ChkDiscord.IsChecked) {
        $TxtStatus.Text = "Instalando Discord... Aguarde."
        [void](winget install --id Discord.Discord --silent --accept-source-agreements --accept-package-agreements)
    }
    if ($ChkSteam.IsChecked) {
        $TxtStatus.Text = "Instalando Steam... Aguarde."
        [void](winget install --id Valve.Steam --silent --accept-source-agreements --accept-package-agreements)
    }
    if ($ChkVLC.IsChecked) {
        $TxtStatus.Text = "Instalando VLC Media Player... Aguarde."
        [void](winget install --id VideoLAN.VLC --silent --accept-source-agreements --accept-package-agreements)
    }
    if ($ChkWinRAR.IsChecked) {
        $TxtStatus.Text = "Instalando WinRAR... Aguarde."
        [void](winget install --id RARLab.WinRAR --silent --accept-source-agreements --accept-package-agreements)
    }
    
    # Componentes Especiais
    if ($ChkVC.IsChecked) {
        $TxtStatus.Text = "Instalando Todos os Visual C++ Runtimes..."
        [void](winget install --id Microsoft.VCRedist.2015+.x64 --silent --accept-source-agreements)
    }
    if ($ChkJava.IsChecked) {
        $TxtStatus.Text = "Instalando Java Runtime..."
        [void](winget install --id Oracle.JavaRuntimeEnvironment --silent --accept-source-agreements)
    }
    if ($ChkNet.IsChecked) {
        $TxtStatus.Text = "Instalando .NET Framework 4.8..."
        [void](Enable-WindowsOptionalFeature -Online -FeatureName "NetFx4Extended-ASPNET45" -NoRestart -ErrorAction SilentlyContinue)
    }
    
    $TxtStatus.Text = "Instalações concluídas com sucesso!"
    $TxtStatus.Foreground = [System.Windows.Media.Brushes]::LightGreen
})

# 4. LÓGICA DO BOTÃO DE OTIMIZAÇÕES (ABA 2)
$BtnOtimizar.Add_Click({
    $TxtStatus.Foreground = [System.Windows.Media.Brushes]::Yellow
    $TxtStatus.Text = "ThizMuniz Optimizer: Aplicando modificações..."

    if ($OptVBS.IsChecked) {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "EnableVirtualizationBasedSecurity" -Value 0 -Force
    }
    
    if ($OptEnergia.IsChecked) {
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
        powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
    }
    
    if ($OptInterface.IsChecked) {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Advanced" -Name "TaskbarDa" -Value 0 -Force
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCopilotButton" -Value 0 -Force -ErrorAction SilentlyContinue
    }
    
    if ($OptEdge.IsChecked) {
        Stop-Process -Name "msedge" -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" -Name "NoRemove" -Value 0 -Force
        if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate" -Force | Out-Null }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate" -Name "DoNotUpdateToEdgeWithChromium" -Value 1 -Force
        $EdgeInstaller = Get-ChildItem -Path "${env:ProgramFiles(x86)}\Microsoft\Edge\Application" -Filter "setup.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($EdgeInstaller) { Start-Process -FilePath $EdgeInstaller.FullName -ArgumentList "--uninstall --system-level --force-uninstall" -NoNewWindow -Wait }
    }
    
    if ($OptServicos.IsChecked) {
        $Services = @("Spooler", "Fax", "SensorService", "RetailDemo", "LfSvc", "MapsBroker", "WerSvc", "DiagTrack", "dmwappushservice")
        foreach ($s in $Services) {
            if (Get-Service -Name $s -ErrorAction SilentlyContinue) {
                Stop-Service -Name $s -Force -ErrorAction SilentlyContinue
