# Setup Remote Access
To enable remote access on the machines (mostly when using Apache's Guacamole) you need to configure RDP protocol for Windows and VNC server for Linux. The instructions may vary based on the type of operating system and its version. We are providing instructions for the several type of images which we are already using in KYPO CRP. 

[TOC]

## RDP - Windows 

### windows-10

1. Set up the following properties 

    ```
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 0
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "SecurityLayer" -Value 1
    ``` 

2. Enable remote desktop 

    ```
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
    ```

**Note:** These steps have been already used for the image [windows-10](https://gitlab.ics.muni.cz/muni-kypo-images/windows-10)

## VNC - Linux 

### xubuntu-18.04
Inspirated by the [Remote-desktop to a host using VNC](https://docs.01.org/clearlinux/latest/guides/network/vnc.html#method-3-multi-user-logins-with-authentication-through-gdm).

1. Install **TigerVNC** 
    ```
    apt-get update
    mkdir -p /var/log/apt/
    apt-get install -y tigervnc-standalone-server tigervnc-xorg-extension tigervnc-viewer
    ```


2. Create a systemd socket file `xvnc.socket` with the following content

    ```
    sudo tee -a /etc/systemd/system/xvnc.socket << EOF

    [Unit]
    Description=XVNC Server on port 5900

    [Socket]
    ListenStream=5900
    Accept=yes

    [Install]
    WantedBy=sockets.target

    EOF
    ```

3. Create a systemd service file `xvnc@.service` with the following content

    ``` 
    sudo tee -a  /etc/systemd/system/xvnc@.service << EOF

    [Unit]
    Description=Daemon for each XVNC connection

    [Service]
    ExecStart=-/usr/bin/Xvnc -inetd -query localhost -geometry 2000x1200 -once -SecurityTypes=None
    User=nobody
    StandardInput=socket
    StandardError=syslog

    EOF
    ```

4. Create a LightDM `lightdm.conf` file with the following content
    ```
    sudo tee -a /etc/lightdm/lightdm.conf << EOF

    [XDMCPServer]
    enabled=true
    port=177

    EOF
    ```

5. Start the VNC socket script and set it to start automatically on boot.
    ```
    sudo systemctl daemon-reload
    sudo systemctl enable xvnc.socket
    sudo systemctl start xvnc.socket
    ```

6. Restart LigthDM service
    ``` 
    sudo systemctl restart lightdm.service
    ```

**Note:** These steps have been already used for the image [xubuntu-18.04](https://gitlab.ics.muni.cz/muni-kypo-images/xubuntu-18.04)

### kali-2020.4
Inspirated by the [Remote-desktop to a host using VNC](https://docs.01.org/clearlinux/latest/guides/network/vnc.html#method-3-multi-user-logins-with-authentication-through-gdm).

1. Remove **TightVNC**
    ```
    sudo apt remove tightvncserver 
    ```

2. Install **TigerVNC** 
    ```
    sudo apt-get update 
    sudo apt install tigervnc-standalone-server tigervnc-xorg-extension tigervnc-viewer
    ```


3. Create a systemd socket file `xvnc.socket` with the following content
    ```
    sudo tee -a /etc/systemd/system/xvnc.socket << EOF

    [Unit]
    Description=XVNC Server on port 5900

    [Socket]
    ListenStream=5900
    Accept=yes

    [Install]
    WantedBy=sockets.target

    EOF
    ```

4. Create a systemd service file `xvnc@.service` with the following content

    ``` 
    sudo tee -a  /etc/systemd/system/xvnc@.service << EOF

    [Unit]
    Description=Daemon for each XVNC connection

    [Service]
    ExecStart=-/usr/bin/Xvnc -inetd -query localhost -geometry 2000x1200 -once -SecurityTypes=None
    User=nobody
    StandardInput=socket
    StandardError=syslog

    EOF
    ```

5. Create a LightDM `lightdm.conf` file with the following content
    ```
    sudo tee -a /etc/lightdm/lightdm.conf << EOF

    [XDMCPServer]
    enabled=true
    port=177

    EOF
    ```

6. Install accountsservice 
    ```
    sudo apt-get install accountsservice
    ```

7. Restart LigthDM service
    ``` 
    sudo systemctl restart lightdm.service
    ```
