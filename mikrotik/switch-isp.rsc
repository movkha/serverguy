:local PingCount 5;
:local CheckIp1 77.88.8.1;
:local CheckIp8 77.88.8.8;
:local isp1 [/ping $CheckIp1 count=$PingCount interface="ether1"];
:local isp2 [/ping $CheckIp8 count=$PingCount interface="ether2"];
:local BackGw [/ip route get [find comment="reserver-isp"] disable];
:if (($isp1=0) && ($isp2=$PingCount) && ($BackGw=true)) do={
/ip route disable [find comment="main-isp"];
/ip route enable [find comment="reserver-isp"];
:delay 2
:log warning "Set routes to reserver ISP";
/ip firewall connection remove [ find protocol~"tcp" ];
/ip firewall connection remove [ find protocol~"udp" ];
:delay 2
:log warning "Set routes to reserver ISP";
}
:local MainGw [/ip route get [find comment="main-isp"] disable];
:if (($isp1=$PingCount) && ($MainGw=true)) do={
/ip route enable [find comment="main-isp"];
/ip route disable [find comment="reserver-isp"];
:delay 2
:log warning "Set routes to main ISP";
/ip firewall connection remove [ find protocol~"tcp" ];
/ip firewall connection remove [ find protocol~"udp" ];
:delay 2
:log warning "Set routes to main ISP";
}
