# Rolling-Your-Own-Bootloader
Rolling Your Own Bootloader - scrierea unui bootloader capabil să încarce un sistem linux

# 17.06.2024
Astazi am ales tema si am citit jumatate din acest pdf: https://www.cs.cmu.edu/~410-s07/p4/p4-boot.pdf, plus inca 
cateva resurse de pe internet pentru a vedea in ce consta codul unui bootloader si a-mi aminti cateva notiuni invatate
semestrul acesta la arhitecturi.

# 18.06.2024
Am terminat de citit mai multe resurse de pe internet, inclusiv ceea ce incepusem ieri.
Am decis sa folosesc qemu pentru emularea procesorului si pentru a testa codul pentru bootloader.
Am parcurs acest tutorial de pe git: https://github.com/cfenollosa/os-tutorial . Mi s-a parut foarte folositor 
pentru a pune in practica teoria pe care am citit-o si a intelege mai bine.

# 19.06.2024
Astazi am mai citit putin si am inceput sa scriu codul pentru bootloader. Am scris cod pentru a incarca un 
kernel in memorie. Am intampinat o problema la testarea codului cu qemu. Dupa ce am rezolvat problema si am reusit sa testez codul,
am observat ca aveam niste probleme, asa ca am inceput sa il modific. 
update: am rezolvat problema legata de cod, dar nu si cea legata de qemu.

# 20.06.2024
Am avansat cu codul, dar am o problema pe care nu am reusit sa o rezolv astazi. Nu inteleg daca problema este la cum folosesc aplicatia qemu,
sau la codul meu. Eu din codul pentru bootloader si pentru kernel creez o imagine de disk pe care o dau parametru la aplicatia qemu.
Desi creez imaginea la fel cum fac si citirea kernelului, aplicatia imi spune ca nu il gaseste.
dd if=/dev/zero of=disk.img bs=512 count=2880
dd if=bootloader.bin of=disk.img bs=512 count=1 conv=notrunc
dd if=kernel.bin of=disk.img bs=512 seek=1 conv=notrunc
qemu-system-x86_64 -drive format=raw,file=disk.img

# 21.06.2024
Problema era cu comanda pe care o foloseam pentru aplicatia qemu. Dupa ce am mai cautat pe internet, am aflat ca ii lipsea un parametru.
Trebuia sa specific ca folosesc un floppy-disk. Pentru ca nu specificam, incerca sa faca bootarea de pe un hard disk.
Noua comanda:
qemu-system-x86_64 -drive format=raw,file=disk.img,index=0,if=floppy

