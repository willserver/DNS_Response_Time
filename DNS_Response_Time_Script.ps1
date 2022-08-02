#----- Ini file define -----
#Script setting ini file path define.
$Ini_File_Path = ".\DNS_Response_Time_Script.ini"
#Define Init parameter agruments.
$Ini_Param = @{}
#Import init file and valiable assigments.
Import-Csv -Path $Ini_File_Path -Header Key,Value -Delimiter "=" | %{$Ini_Param.Add($_.Key.Trim(), $_.Value.Trim())}



#GET DNS List Function
function GET_DNS_List {
    param (
        #DNS list file path define.
        $DNS_List_Path
    )
    #Check DNS list file.
    $Check_DNS_List_Path = Test-Path $DNS_List_Path

    #DNS list file judgements.
    if ($Check_DNS_List_Path) {
        #Check DNS list file ok.
        Write-Host "Check DNS List File OK. Path : " $DNS_List_Path
    }else {
        #Check DNS list file not found. Script exit 1
        Write-Host "Check DNS List File Not Found."
        exit 1
    }

    #GET DNS List File.
    try {
        #Import DNS Server List.
        $GET_DNS_List = Import-Csv $DNS_List_Path -Encoding UTF8 -ErrorAction Stop
        Write-Host "DNS server list get success."
    }
    catch {
        #DNS server list get failed.
        Write-Host "DNS Server list get failed. Exception : " $_.Exception
        exit 1
    }
    #return Import DNS List.
    return $GET_DNS_List

}


#GET DNS Query function 
function GET_DNS_ResponseTime {
    param (
        $DNS_Server_List,
        $Output_Path,
        $Resolve_Name,
        $Query_Count,
        $Interval_Time
    )
    #Function start message.
    Write-Host "Start GET DNS Query. Output File : "$Output_Path",Resolve Name : "$Resolve_Name
    #CSV header string define.
    $Initiai_Header = "DNS_ServerName,IP,Response_Time,ResolveName"
    Write-Host $Initiai_Header
    #CSV header output.
    Write-Output $Initiai_Header | Out-File $Output_Path -Encoding utf8 -Append

    #DNS query loop.
    foreach ($line in $DNS_Server_List) {
        #DNS query counter loop.
        for ($i = 0; $i -lt $Query_Count; $i++) {
            try {
                #do Measure-Command. DNS resolve exit. 
                $RAW_Query_Result = Measure-Command {Resolve-DnsName $Resolve_Name -DnsOnly -Type A -NoHostsFile -server $line.IP} -ErrorAction Stop
            }
            catch {
                
            }
            
            #Output string Generate.
            $Create_Output_String = $line.DNS_ServerName + "," + $line.IP + "," + $RAW_Query_Result.TotalMilliseconds + "," + $Resolve_Name
            Write-Host $Create_Output_String
            #CSV output.
            Write-Output $Create_Output_String | Out-File $Output_Path -Encoding utf8 -Append
            #Execution speed adjustment 1seconds.
            Start-Sleep -s $Interval_Time
        }
    }
    Write-Host "End GET DNS Query."
}




#----- Main Process -----
#call DNS List get contente function.
$GET_DNS_Server = . GET_DNS_List $Ini_Param.DNS_List_Path
#do DNS resolve and file write
. GET_DNS_ResponseTime $GET_DNS_Server $Ini_Param.DNS_Response_Time_Result $Ini_Param.ResolveName $Ini_Param.QueryCount $Ini_Param.Interval_Time

Write-Host "END Scripts."






















