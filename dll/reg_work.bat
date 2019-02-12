%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\regasm.exe %~dp0soap_work2.dll /regfile:%~dp0soap_work2.reg /tlb:%~dp0soap_work2.tlb
%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\regsvcs /tlb:%~dp0soap_work2.tlb %~dp0soap_work2.dll  
pause