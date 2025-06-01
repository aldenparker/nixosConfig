{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.${namespace}.bundles.cybersecurity; # Config path
in
{
  # --- Set options
  options.${namespace}.bundles.cybersecurity = {
    enable = mkEnableOption "Enables the cybersecurity packages and installs them on host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cutter # Disassemble and reverse engineer GUI toolkit
      nmap # Scan for ports
      detect-it-easy # Detect many things including packing for a binary (reverse engineering)
      file # Determine the type of file and any details about it
      tcpdump # Capture all TCP data on a device
      wireshark # A GUI for packet capture and analysis
      bruno # A GUI for REST api testing
      dig # Gets Domain name details
      whois # DNS lookup
      traceroute # Trace the route a packet takes
      tcpflow # Capture TCP data transmitted in a easy way to analyse
      macchanger # Chaneg mac address of device
      nbtscan # Scan networks searching for NetBIOS information
      # ike-scan # Tool to discover, fingerprint and test IPsec VPN servers
      ipcalc # Calculate IP address parameters
      dnsenum # Gather all DNS records for a domain
      dnsrecon # DNS enum with focus on vulnerabilities
      aircrack-ng # General purpose WIFI cracker
      reaverwps-t6x # WPS attack tool
      john # Password cracker (John the Ripper)
      thc-hydra # Logon cracker with many different services
      metasploit # Exploit framework for many different exploits
      sqlmap # SQL injection attack tool
      enum4linux # Enumerate information from Windows and Samba systems
      nikto # Web server vulnerability scanner
      wpscan # WordPress site vulnerability scanner
      dirb # Scan websites for hidden content
      ettercap # Man in the Middle attack tool
      dirbuster # GUI Web server hidden path scanner
      hashcat # Password cracker with GPU enabled
      volatility3 # RAM dump analyser
      autopsy # GUI data recovery suite
      gobuster # Brute-force URIs, DNS subdomains, Virtual Host names on web servers
      stegseek # Steganography brute forcer
      steghide # Steganography generator
      sshuttle # Proxy over SSH (Python 2.7 or 3.5 on is needed on both ends)
      mitmproxy # Intercepts http and https traffic
      hash-identifier # Identify differnt hashes
      samdump2 # Dump password hashes from Windows SAM files (NT/2k/XP installations)
      airgeddon # General purpose wifi auditor (more autonomous than aircrack)
      mitm6 # Man in the middle tool for IPv6
      dmitry # Info gathering tool
      theharvester # Public information gatherer for real world data
      binwalk # Extract embedded files in binaries
      foremost # Recover files based on their contents from disk
      scalpel # Recover files based on their contents from disk (more specialized than foremost)
      davtest # WebDAV server vulnerability scanner
      sslscan # Scan for ssl/tls vulnerabilities
      bettercap # Man in the middle attack tool
      pdf-parser # Analyse PDF files for malware
      p0f # Passive network recon to fingerprint devices
      thc-ipv6 # IPv6 attack toolkit
      chntpw # Change windows local account password by editing the SAM file
      exploitdb # Public exploit search
      yara # Pattern matching for files for malware reasearch
      msfpc # Metasploit payload creator (streamline the process of payload creation)
      mac-robber # Grab data about file edits
      mimikatz # Windows password extracter
      wordlists # Common wordlists used for password bruteforce
      snowman.cyberchef # Common decoding tool
    ];

    # For routing through tor
    services.tor = {
      enable = true;
      client.enable = true;
      torsocks.enable = true;
    };

    # Setup wireshark permisions
    users.groups.wireshark = { };
    security.wrappers.dumpcap = {
      source = "${pkgs.wireshark}/bin/dumpcap";
      capabilities = "cap_net_raw,cap_net_admin+eip";
      owner = "root";
      group = "wireshark";
      permissions = "u+rx,g+x";
    };
  };
}
