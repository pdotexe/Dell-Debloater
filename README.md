# Dell-Debloater 💻



<img width="960" height="960" alt="Dell_Logo svg" src="https://github.com/user-attachments/assets/382eaf4a-287f-4d65-8931-98ea07f6102c" />

## ℹ️ Info 
## ---------------------------------------------------------
A common issue with production ready Dell shipped with Windows 11 is preinstalled software that consumes high amounts of memory when running as background processes and potentially creates and writes to log files, wasting SSD storage.


Dell-Debloater targets common Microsoft store apps, Dell management software, background services sending telemetry data to Microsoft cloud servers, and MSI packages in the Windows registry to remove background processes caused by these applications.



## ⚠️ Notes
## --------------------------------------------------------

- The OS attempts to re-install software such as Dell SupportAssist in events such as reboot failures. At startup, hit F2 multiple times to bring up the BIOS settings and disable SupportAssist recovery

- Not all Telemetry is removed. Some is baked into the NT kernel, and attempting to block core reporting may break the Operating System

- Run this script regularly for best results. Windows may reenable services, restart scheduled tasks, and re-add directories which were targeted by this script

- This utility requires administrator permission on the system




## Usage Options 🧠
# ---------------------------------------------------------

Clone the repository:
```
git clone https://github.com/pdotexe/Dell-Debloater.git
```
Change Directory:
```
cd Dell-Debloater
```
Run the batch file:
```
run.bat
```




* Alternatively, you may download the .zip from this repository, and click on the batch file.




## View Removed Items

To get a detailed report of what is being targeted, run the following command in the directory:

```
cat removeditems.txt
```












