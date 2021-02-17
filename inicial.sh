sudo pacman -Syu ;

loadkeys br-abnt2 ;
fdisk -l /dev/sda ;
cfdisk /dev/sda ;

#/dev/sda1 (500MB para o /boot/efi)
#/dev/sda2 (50GB para /)
#/dev/sda3 (todo o resto para o /home)
#/dev/sda4 (2GB para swap)

mkfs.vfat /dev/sda1 ;
mkfs.ext4 /dev/sda2 ;
mkfs.ext4 /dev/sda3 ;
mkswap /dev/sda4 ;

mount /dev/sda2 /mnt ;
mkdir /mnt/home ;
mkdir /mnt/boot ;
mkdir /mnt/boot/efi ;
mount /dev/sda3 /mnt/home ;
mount /dev/sda1 /mnt/boot/efi ;
swapon /dev/sda4 ;

pacstrap /mnt base linux-lts linux-firmware base base-devel ;
genfstab -U -p /mnt >> /mnt/etc/fstab ;
arch-chroot /mnt ;
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime ;
hwclock --systohc ;
pacman -S nano ;
nano /etc/locale.gen ;
locale-gen ;
echo LANG=pt_BR.UTF-8 >> /etc/locale.conf ;
echo KEYMAP=br-abnt2 >> /etc/vconsole.conf ;
useradd -m -g users -G wheel pedro ;
passwd ;
passwd pedro ;
pacman -S dosfstools os-prober mtools network-manager-applet networkmanager wpa_supplicant wireless_tools dialog sudo -y ;
nano /etc/sudoers ;
usermod -d /home/pedro -m pedro ;
pacman -S grub-efi-x86_64 efibootmgr ;
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck ;
cp /usr/share/locale/en@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo ;
grub-mkconfig -o /boot/grub/grub.cfg ;
exit ;
reboot ;
