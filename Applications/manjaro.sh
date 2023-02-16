
alias GPU_list_drivers="sudo mhwd -l -d"
alias GPU_list_installed_drivers="sudo mhwd -li -d" 
alias GPU_install_driver_free="sudo mhwd -a pci free 0300"
alias GPU_install_driver_proprietary="sudo mhwd -a pci nonfree 0300"
alias GPU_check_driver="sudo mhwd-gpu --check"
alias GPU_status_driver="sudo mhwd-gpu --status"
alias GPU_set_module_driver="sudo mhwd-gpu --setmod"
# sudo mhwd-gpu --setxorg /etc/x11/xorg.conf

GPU_remove_driver_by_name(){
    sudo mhwd -r pci "$1";
}
