# metasploit-script-ataque-cmd

****************************************
* MSFCONSOLE - SCRIPT DE ATAQUE MASIVO *
*                                      *
* Autor: Jaime Andrés Cruz Romero      *
****************************************

IMPORTANTE: La finalidad del presente script para Metasploit es enteramente académica, con el ánimo de
compartir un ejemplo de cómo se pueden automatizar ataques por medio de código Ruby On Rails.
El autor NO SE HACE RESPONSABLE POR El uso indebido de este material de aquellos quienes lo usen y/o 
modifiquen. Reitero, es de uso ENTERAMENTE ACADEMICO.

El presente script tiene como objetivo realizar un ataque con Metasploit a un rango de IPs
en un segmento determinado (Ej: 192.168.1.XXX). Se ha diseñado desde Kali Linux 2017.1
(No se han realizado pruebas en otras versiones de Linux).

Está diseñado para atacar máquinas con sistema operativo Windows XP, haciendo uso del
exploit "exploit/windows/smb/ms08_067_netapi" y del payload "windows/exec" en cual permite
ejecutar comandos CMD en los equipos con dicha vulnerabilidad.

El segmento que se considera es el mismo que posee el equipo que lo esté ejecutando.

Para la ejecución del script, se deben considerar las siguientes configuraciones en las 
siguientes variables, a  saber:

--------------------------------------------
nombre		tipo dato		Observaciones
--------------------------------------------
$exc		Entero			Array en el que se pueden registrar las IP que se desean excluir del rango de ataque
$boo 		Entero			1 Activo, 0 Inactivo - Dispara escaneos con NMAP para engañar a la víctima, registrando conexiones múltiples, en caso que se monitoree con netstat
$rip		Entero			Dirección IP inicial de ataque
$fin		Entero			Dirección IP final de ataque
$trg		Entero			0 por defecto. Definición del target en caso que se desee obviar la validación del fingerprint del SO. 
$cmd		Texto			Array en el que se pueden registrar los comandos CMD que se desean ejecutar en la victima
