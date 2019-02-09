%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\regasm.exe %~dp0soap_test2.dll /tlb:%~dp0soap_test2.tlb /codebase
%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\regsvcs /tlb:%~dp0soap_test2.tlb %~dp0soap_test2.dll  
pause