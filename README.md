# En Rask, Enkel og Praktisk OpenVPN Guide
Oppsett av OpenVPN for sikker fjerntilgang av nettverk, f.eks. hjem til jobb.  
Kan enkelt utvides til site-to-site, ved å kjøre oppsettet begge veier.  
  
Denne guiden er laget for, og testet i, rene Microsoft Windows miljøer,  
hvor server.ovpn kjører på en dedikert maskin i nettverket som skal nås.  
   
  
1. Last ned oppsettsfil, f.eks. OpenVPN-2.6.10-I002-amd64.msi
   fra: https://openvpn.net/community-downloads/  
     
   Pass på å få med både EasyRSA og tjenesten under installering.  
   (For generering av sertifikater m.m. og automatisk serveroppstart.)  
   
   
2. Fra C:\Program Files\OpenVPN\easy-rs (CMD som Administrator):  
   
   c:\> EasyRSA-start.bat  
   \# ./easyrsa init-pki  
   \# ./easyrsa build-ca  
   
   **KUN 1 GANG:**  
   \# ./easyrsa build-server-full server1     // Samme for server.  
   (PEM = tilkoblingspassord. Tilpass "askpass" argumentet i server.ovpn)  
   
   **PER KLIENT:**
   \# ./easyrsa build-client-full klient1     // Oppretter klient key/cert.  
     
   \# openssl dhparam -out dh2048.pem 2048    // Putt i <dh> taggen i server.ovpn  
   \# openvpn --genkey tls-auth ta.key        // Putt i <tls-auth> i begge filer.  

	Avslutt shellet.
   
   
3. Finn innholdet i genererte filer under samme mappe og lim det inn mellom  
   respektive tagger: &lt;ca>, &lt;cert>, &lt;key>, &lt;tls-auth> og &lt;dh>  
   i klient.ovpn og server.ovpn, da har du kun 2 filer å forholde deg til.  
   
   
4. Slå også på IP forwarding med: Turn_IP_forwarding_ON.cmd (som admin).  
   Sjekk med: Get-NetIPInterface | Select-Object InterfaceAlias,AddressFamily,Forwarding  
   
  
5. Tilpass .ovpn klient og server med bl.a. riktig remote, ønsket subnet og port.  
   Plasser klient.ovpn i %userprofile%\OpenVPN\config hos klient.  
   Plasser server.ovpn i %programfiles%\OpenVPN\config-auto  
   (Sjekk at OpenVPN tjenesten starter automatisk via services.msc)  
   
  
6. Sett statiske ruter tilbake, direkte på maskiner du skal ha kontakt med.  
   F.eks. c:\> route -p add 10.8.0.0 mask 255.255.255.0 LAN-IP.til.vpn.server  
  
   (Dette gjøres i stedet for felles statisk rute i LAN'ets router, for å unngå  
	problematikk og ekstra trafikk iht. pakke/ICMP redirects kan/vil oppstå når  
	server.ovpn kjører på en IP under samme subnet som maskiner som skal nås.)  
   
  
7. Sett opp NAT/portviderekobling i Internett gateway/brannmur/router etter behov.