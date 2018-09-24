function Get-ShellBuffer {
    [CmdletBinding()]
    param ()
			
    try {
        # Define limits
        $rec = New-Object System.Management.Automation.Host.Rectangle
        $rec.Left = 0
        $rec.Right = $host.ui.rawui.BufferSize.Width - 1
        $rec.Top = 0
        $rec.Bottom = $host.ui.rawui.BufferSize.Height - 1
				
        # Load buffer
        $buffer = $host.ui.rawui.GetBufferContents($rec)
				
        # Convert Buffer to list of strings
        $int = 0
        $lines = @()
        while ($int -le $rec.Bottom) {
            $n = 0
            $line = ""
            while ($n -le $rec.Right) {
                $line += $buffer[$int, $n].Character
                $n++
            }
            $line = $line.TrimEnd()
            $lines += $line
            $int++
        }
				
        # Measure empty lines at the beginning
        $int = 0
        $temp = $lines[$int]
        while ($temp -eq "") { $int++; $temp = $lines[$int] }
				
        # Measure empty lines at the end
        $z = $rec.Bottom
        $temp = $lines[$z]
        while ($temp -eq "") { $z--; $temp = $lines[$z] }
				
        # Skip the line launching this very function
        $z--
				
        # Measure empty lines at the end (continued)
        $temp = $lines[$z]
        while ($temp -eq "") { $z--; $temp = $lines[$z] }
				
        # Cut results to the limit and return them
        return $lines[$int .. $z]
    }
    catch { }
}