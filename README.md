# mestrado-qemu-send-ethernet-frame

Este repositório tem o intuito de abrigar o passo a passo para a criação dos artefatos necessários para máquinas virtuais rodando no QEMU possam fazer o envio de frames Ethernet sobre um socket para aplicações a serem utilizadas nos laboratórios da Disciplina de Redes Veiculares e Industriais do programa de Mestrado PPGCC na UFSC.

## Premissa

Este repositório tem como objetivo apenas demonstrar o que é necessário para o envio de frames Ethernet em uma rede Ethernet via socket sem uso de protocolo IP

O passo-a-passo para criação e execução das máquinas virtuais no QEMU pode ser encontrada no link a seguir:

[a link](https://github.com/JoeVogel/mestrado-qemu-kernel-busybox)

## sender.c

Este arquivo é o responsável pela montageme e envio do frame Ethernet.

Dois pontos relevantes nos testes são:

	unsigned char dest[ETH_ALEN] = { 0x52, 0x54, 0x00, 0x12, 0x034, 0x58 };

Nesta variável definimos o MAC ADDRESS do destinatário

	unsigned char *data = "testing - industrial networks";

Aqui definimos a mensagem que será enviada

## Compilando o sender.c

Para que isso possa ser executado, precisamos compilar o arquivo para gerar então o executável que será utilizado dentro da VM

Para tal, podemos usar o GCC no host com o argumento **-static** que possibilitará o uso na VM

	gcc -o sender -static sender.c

Isso irá gerar o arquivo **sender**, este deverá ser adicionado à pasta _install da BusyBox 

Com este arquivo no lugar certo, agora precisamos gerar novamente a imagem da BusyBox. Para tal usamos o utilitário disponibilizado pelo Kernel que compilamos ([ver Premissa](##-premissa))

	cd ./linux-5.15.57/
	./usr/gen_initramfs.sh -o ../initramfs.img ../busybox-1.36.0/_install ../cpio_list

Ao subir a VM utilizando a imagem *initramfs.img* o **sender** estará disponível para uso:

	~ # ls
	bin      init     mnt      root     sender   usr
	dev      linuxrc  proc     sbin     sys

Podemos usar então via

	./sender

Se tudo certo, teremos o seguinte resultado:

	~ # ./sender
	Success!

E via *TCPDump* podemos ver que o pacote foi enviado:

	15:05:09.743191 52:54:00:12:34:56 (oui Unknown) > 52:54:00:12:34:58 (oui Unknown), ethertype Unknown (0x1234), length 60: 
	0x0000:  7465 7374 696e 6720 2d20 696e 6475 7374  testing.-.indust
	0x0010:  7269 616c 206e 6574 776f 726b 7300 0000  rial.networks...
	0x0020:  0000 0000 0000 0000 0000 0000 0000       ..............