# DNS Reponse Time Check Script

This script measures and outputs the response time of DNS server name resolution.

# How to USE
1. [DNS_List.csv] file create.
    1.1. CSV Argumenst is DNS Server Name(DNS Server Optional Title.) and DNS Server IP(or FQDN) .

2. [DNS_Response_Time.ini] file Edit. init file arguments is as follows.
    * DNS_List_Path : DNS_List.csv file path define. (Default : ScriptRoot\DNS_List.csv)
    * DNS_Response_Time_Result : DNS Response time output file path define. (Default : ScriptRoot\DNS_Response_Time.csv)
    * ResolveName : DNS Server Resolve DNS Name define. (Default : google.com)
    * QueryCount : Query repeat count define. (Default : 10)
    * Interval_Time : Query Interval define. Unit is Seconds. (Default : 1)
        * **Changing this value may increase the load on the DNS server being queried.**

3. Run the [DNS_Response_Time_Script.ps1] script.

4. Check Output file. Default output is [ScriptRoot\DNS_Response_Time.csv].
