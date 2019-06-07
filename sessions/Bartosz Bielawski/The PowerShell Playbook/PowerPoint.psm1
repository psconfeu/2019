Add-Type -AssemblyName PresentationFramework

function Show-Slide {
    param (
        [ValidateSet(
                'About_Me',
                'Questions',
                'Citron',
                'OutsideBox',
                'AllRoads',
                'Owl'
        )]
        [string]$Name = 'Owl',
        [int]$Height = 989,
        [double]$Opacity = 0.9
    )

    $Info = [hashtable]::Synchronized(@{})
    $Info.Slide = @{
        About_Me = @{
            Path = 'D:\GitHub\PSPlayBook\Intro_About_Me_Ewa.png'
            Width = 1000
        }
        Questions = @{
            Path = 'D:\GitHub\PSPlayBook\Outro_Questions_Ewa.png'
            Width = 1000
        }
        Citron = @{
            Path = 'D:\GitHub\PSPlayBook\04_Lemon_Hania.png'
            Width = 1759
        }
        OutsideBox = @{
            Path = 'D:\GitHub\PSPlayBook\03_OutsideBox_Hania.png'
            Width = 1759
        }
        AllRoads =  @{
            Path = 'D:\GitHub\PSPlayBook\01_MultipleWays_Paweł.png'
            Width = 1759
        }
        Owl = @{
            Path = 'D:\GitHub\PSPlayBook\Intro_Owl_Paweł.png'
            Width = 1000
        }
    }
    $Info.Height = $Height
    $Info.Opacity = $Opacity
    $Info.Name = $Name

    $newRunspace = [runspacefactory]::CreateRunspace()
    $newRunspace.ApartmentState = 'STA'
    $newRunspace.ThreadOptions = 'ReuseThread'          
    $newRunspace.Open()
    $newRunspace.SessionStateProxy.SetVariable(
        'syncHash',
        $Info
    )          
    $psCmd = [PowerShell]::Create().AddScript({   
            [xml]$XAML = @"
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Height="1080" Title="GuiTrick" SizeToContent="WidthAndHeight" 
    Name="Window" WindowStyle="None" AllowsTransparency="True"
	Background="Transparent" Topmost="True">
    <Grid Background="Transparent">
        <Image Height="$($syncHash.Height)" Opacity="$($syncHash.Opacity)" Name="Logo">
		    <Image.Source>
			    <BitmapImage UriSource="$($syncHash.Slide[$syncHash.Name].Path)" />
		    </Image.Source>
	    </Image>
	</Grid>
</Window>
"@
            $Reader = New-Object System.Xml.XmlNodeReader $XAML
            $syncHash.Logo = [Windows.Markup.XamlReader]::Load($Reader)
            $syncHash.Image = $syncHash.Logo.FindName('Logo')
            $width = $syncHash.Slide[$syncHash.Name].Width
            $syncHash.Logo.Left = 1920 - $width
            $syncHash.Logo.Top = 0
            $syncHash.Logo.Add_MouseRightButtonDown{
                $this.Close()
            }
            $syncHash.Logo.Add_MouseLeftButtonDown{
                $this.DragMove()
            }
            $syncHash.Logo.ShowDialog() | Out-Null
    })
    $psCmd.Runspace = $newRunspace
    $data = $psCmd.BeginInvoke()
}

$script:DemoText = @{
    alias = @'
██████╗ ███████╗███╗   ███╗ ██████╗         █████╗ ██╗     ██╗ █████╗ ███████╗
██╔══██╗██╔════╝████╗ ████║██╔═══██╗██╗    ██╔══██╗██║     ██║██╔══██╗██╔════╝
██║  ██║█████╗  ██╔████╔██║██║   ██║╚═╝    ███████║██║     ██║███████║███████╗
██║  ██║██╔══╝  ██║╚██╔╝██║██║   ██║██╗    ██╔══██║██║     ██║██╔══██║╚════██║
██████╔╝███████╗██║ ╚═╝ ██║╚██████╔╝╚═╝    ██║  ██║███████╗██║██║  ██║███████║
╚═════╝ ╚══════╝╚═╝     ╚═╝ ╚═════╝        ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝╚══════╝
                                                                              
'@
    regex = @'
██████╗ ███████╗███╗   ███╗ ██████╗        ██████╗ ███████╗ ██████╗ ███████╗██╗  ██╗
██╔══██╗██╔════╝████╗ ████║██╔═══██╗██╗    ██╔══██╗██╔════╝██╔════╝ ██╔════╝╚██╗██╔╝
██║  ██║█████╗  ██╔████╔██║██║   ██║╚═╝    ██████╔╝█████╗  ██║  ███╗█████╗   ╚███╔╝ 
██║  ██║██╔══╝  ██║╚██╔╝██║██║   ██║██╗    ██╔══██╗██╔══╝  ██║   ██║██╔══╝   ██╔██╗ 
██████╔╝███████╗██║ ╚═╝ ██║╚██████╔╝╚═╝    ██║  ██║███████╗╚██████╔╝███████╗██╔╝ ██╗
╚═════╝ ╚══════╝╚═╝     ╚═╝ ╚═════╝        ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝
                                                                                    
'@
    foreach = @'
██████╗ ███████╗███╗   ███╗ ██████╗        ███████╗ ██████╗ ██████╗ ███████╗ █████╗  ██████╗██╗  ██╗
██╔══██╗██╔════╝████╗ ████║██╔═══██╗██╗    ██╔════╝██╔═══██╗██╔══██╗██╔════╝██╔══██╗██╔════╝██║  ██║
██║  ██║█████╗  ██╔████╔██║██║   ██║╚═╝    █████╗  ██║   ██║██████╔╝█████╗  ███████║██║     ███████║
██║  ██║██╔══╝  ██║╚██╔╝██║██║   ██║██╗    ██╔══╝  ██║   ██║██╔══██╗██╔══╝  ██╔══██║██║     ██╔══██║
██████╔╝███████╗██║ ╚═╝ ██║╚██████╔╝╚═╝    ██║     ╚██████╔╝██║  ██║███████╗██║  ██║╚██████╗██║  ██║
╚═════╝ ╚══════╝╚═╝     ╚═╝ ╚═════╝        ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
                                                                                                    
'@
    space = @'
██████╗ ███████╗███╗   ███╗ ██████╗        ███████╗██████╗  █████╗  ██████╗███████╗
██╔══██╗██╔════╝████╗ ████║██╔═══██╗██╗    ██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝
██║  ██║█████╗  ██╔████╔██║██║   ██║╚═╝    ███████╗██████╔╝███████║██║     █████╗  
██║  ██║██╔══╝  ██║╚██╔╝██║██║   ██║██╗    ╚════██║██╔═══╝ ██╔══██║██║     ██╔══╝  
██████╔╝███████╗██║ ╚═╝ ██║╚██████╔╝╚═╝    ███████║██║     ██║  ██║╚██████╗███████╗
╚═════╝ ╚══════╝╚═╝     ╚═╝ ╚═════╝        ╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚══════╝
                                                                                   
'@
    outside = @'
██████╗ ███████╗███╗   ███╗ ██████╗         ██████╗ ██╗   ██╗████████╗    ██████╗  ██████╗ ██╗  ██╗
██╔══██╗██╔════╝████╗ ████║██╔═══██╗██╗    ██╔═══██╗██║   ██║╚══██╔══╝    ██╔══██╗██╔═══██╗╚██╗██╔╝
██║  ██║█████╗  ██╔████╔██║██║   ██║╚═╝    ██║   ██║██║   ██║   ██║       ██████╔╝██║   ██║ ╚███╔╝ 
██║  ██║██╔══╝  ██║╚██╔╝██║██║   ██║██╗    ██║   ██║██║   ██║   ██║       ██╔══██╗██║   ██║ ██╔██╗ 
██████╔╝███████╗██║ ╚═╝ ██║╚██████╔╝╚═╝    ╚██████╔╝╚██████╔╝   ██║       ██████╔╝╚██████╔╝██╔╝ ██╗
╚═════╝ ╚══════╝╚═╝     ╚═╝ ╚═════╝         ╚═════╝  ╚═════╝    ╚═╝       ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
                                                                                                   
'@
}

$script:demoList = @{
    alias = 'update, gal'
    regex = 'regex, lemon'
    foreach = 'foreach, where'
    outside = 'char, false, empty'
    space = 'space, quotes'
}

New-Alias -Name date -Value Get-Date

function Start-Demo {
    param (
        [ValidateSet(
            'foreach',
            'alias',
            'regex',
            'space',
            'outside'
        )]
        [string]$Name
    )
    Clear-Host
    Write-Host ''
    $Script:demoText.$Name | Out-Host
    "Demos: $($Script:demoList.$Name)" | Out-Host
}

Set-PSReadlineKeyHandler -Chord Spacebar -ScriptBlock {
    param ($key, $arg)
    $convert = @{
        'co' = 'git commit '
        'ad' = 'git add '
        'pu' = 'git push '
        'me' = 'git merge '
        '@sysadm2010' = @'
start http://www.happysysadm.com/search?q=golf
'@
        'false' = @'
+'〹'[$false]
'@
        'empty' = @'
+'〹'['']
'@
        'char' = @'
+[char]'〹'
'@
        'regex' = @'
[regex]'(.{3})'|% Re* 'X   X   XXX X X XXXXXXX       '{switch($args.Groups[1].Value){'X  '{'P'}' X '{'o'}'  X'{'w'}'XX '{'e'}'X X'{'r'}' XX'{'S'}'XXX'{'h'}'   '{'l'}}}
'@
        'regex2' =  @'
[regex]'...'|% Re* 'X   X   XXX X X XXXXXXX       '{switch($args){'X  '{'P'}' X '{'o'}'  X'{'w'}'XX '{'e'}'X X'{'r'}' XX'{'S'}'XXX'{'h'}'   '{'l'}}}
'@
        'lemon' = @'
[regex]'...'|% Re* 'X   X   XXX X X XXXXXXX       '{switch($args){'X  '{'P'}' X '{'o'}'  X'{'w'}'XX '{'e'}'X X'{'r'}' XX'{'S'}XXX{'h'}'   '{'l'}}}
'@
        'foreach' = @'
(ls C:\*\s*2\*.*|% Extension|group|sort count -d)[0..4]
'@
        'foreach2' = @'
(ls C:\*\s*2\*.*|% E*n|group|sort c*)[-1..-5]
'@
        'where' = 'Get-Alias ?,??|? Definition -NotMatch Get'
        'where2' = 'gal ?,??|? Di* -Notm Get'
        'update' = 'Get-CimInstance(Get-CimClass *ix*|% *mC*e)|? I*n -gt((Get-Date)+-30d)'
        'update2' = 'gcim(gcls *ix*|% *mC*e)|? I*n -gt((date)+-30d)'
        'space' = @'
'my string' -replace 'r'
'@
        'space2' = @'
'my string'-replace'r'
'@
        'quotes' = @'
sls 'ud' "$env:windir\s*\d*\e*\hosts"
'@
        'quotes2' = @'
sls ud $env:windir\s*\d*\e*\hosts
'@
        'gal' = 'Get-Alias | Where Definition -match Content'
        'gal2' = 'Get-Alias ?,??'
        'p' = @'
$p = 'P@ssw0rd'
'@
        '11' = 'Show-Slide -Name About_Me'
        '12' = 'Show-Slide Owl'
        '21' = 'Show-Slide -Name AllRoads'
        '22' = 'Show-Slide -Name OutsideBox'
        '23' = 'Show-Slide -Name Citron'
        '31' = 'Start-Demo -Name foreach'
        '32' = 'Start-Demo -Name alias'
        '33' = 'Start-Demo -Name regex'
        '34' = 'Start-Demo -Name space'
        '35' = 'Start-Demo -Name outside'
        '36' = 'ise D:\GitHub\PSPlayBook\Demo-Shorten.ps1'
        'final' = @'
$a,$b=$($p|sc -N a;filehash a -a SHA1).Hash-split'(?<=^.{5})';[regex]"(?ms).*^$b.(\d+).*"|% Re*(irm https://api.pwnedpasswords.com/range/$a -UseB)`$1
'@
        '41' = 'Show-Slide -Name Questions'
    }
    $line = $null
    $cursor = $null
    $psReadLine::GetBufferState(
        [ref]$line, [ref]$cursor
    )
    if ($convert.ContainsKey($line)) {
        $psReadLine::Replace(
            0,
            $line.Length,
            $convert.$line
        )
        $psReadLine::SetCursorPosition($convert.$line.Length)
    } else {
        $psReadLine::Insert(' ')
    }
}
