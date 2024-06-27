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

# 25.06.2026
In weekend-ul care a trecut am imbunatatit codul. Dupa ce am mai citit cateva resurse pe internet, am scris codul 
pentru a face trecerea de la real mode la protected mode. Am intampinat o problema la crearea unei tabele de descriptori temporala, necesara pentru a face trecerea in protected mode. Dupa ce am facut debugging, am observat ca atunci cand incerc sa creez gdt, codul se opreste. Am tot cautat pe internet, dar codul meu pare corect. Nu imi pot da seama unde este problema.
Cateva resurse folosite:
https://dev.to/frosnerd/writing-my-own-boot-loader-3mld
https://stackoverflow.com/questions/71915188/failing-to-write-to-video-memory-in-32-bit-mode
https://wiki.osdev.org/Protected_Mode
https://c9x.me/x86/html/file_module_x86_id_156.html
https://wiki.osdev.org/Rolling_Your_Own_Bootloader

# 26.06.2026
Ieri si astazi am reusit sa rezolv problemele pe care le aveam. Mai exact problema descrisa ieri si inca o problema pe care am intalnit-o. (Dupa ce treceam in 32-bit protected mode, faceam un call la adresa la care incarcam kernelul in memorie. Aparent am calculat adresa gresit, dar astazi am rezolvat si problema aceasta). 
Saptamana trecuta am creat si un Makefile pentru a fi mai usor de rulat codul. In codul bootloader-ului am pus si mesaje pentru a fi mai usor de urmarit executia lui.
Inca cateva resurse folosite pe parcursul proiectului:
https://wiki.osdev.org/Disk_access_using_the_BIOS_(INT_13h)
https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
https://0xax.gitbooks.io/linux-insides/content/Booting/
https://www.almesberger.net/cv/papers/ols2k-9.pdf
