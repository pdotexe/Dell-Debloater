# Dell-Debloater 


<img width="350" height="350" alt="31d3eecdbc9c7a930ad857d8845b3393" src="https://github.com/user-attachments/assets/934ed12c-1f0e-410f-9f49-5c18eec5eb3b" />






Dell-Debloater is a easy to use debloat tool with a focus on Dell Computers running the Windows 11 Operating System (Home and Pro).



# Usage Options 🧠
# ---------------------------------------------------------
# REQUIRES ADMINISTATOR PRIVELAGE
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


* Alternatively, you may download the .zip from this repository, and click on the batch file as administrator.


# Removal Overview  🛠️ 

* AppxPackages and AppxProvisionedPackages: Common preinstalled apps such as clipchamp, Outlook, and Screensketch, as well as Provisioned Packages to maintain a clean OS image for new users.
* Preinstalled Dell Applications: Power Manager, SupportAssist, Mobile Connect, Etc.
* Intel Management
* Video, Image, and Media Codec softwares which aid in compression and playback quality.
* Automated services such as XblGameSave, Wavessvc64, and other services which increase memory usage on svchost.exe
* Dell-related directories
* MSI Packages (Contain instructions in Registry for application installation and updates
* Blocked TCP Connections to IP addresses of Telemetry outbound
* Set the endpoint's associated IP in C:\windows\system32\drivers\etc\hosts to 0.0.0.0
*  Disabled services such as DiagTrack, and Dmwappushservice ( may remove some functionalities )
*  Completely removed directories made for logging data to be sent to Microsoft later




# Options
# -------------------------------------------------------
[1] Fast Debloat
* This option quickly applies changes automatically for you. You may review what is being removed with the third option, but there is no rollback for this action unless manually reinstalled

[2] Remove Telemetry
* Windows collects data on users silently in the background (scheduled tasks, registry keys, etc.). These also consumes resources, and may pose privacy concern and a chance of privelage escalation (PrivEsc) attacks through insecure GUI apps or registry misconfigurations. Note that this does not fully remove Telemetry, as some is baked into the NT Kernel, which is not legal to modify.

[3] Review Removed Items
* This runs "Get-Content" on a text file containing information on what is being targeted.













