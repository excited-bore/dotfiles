


alias GPU_list_drivers="doas mhwd -l -d"
alias GPU_list_installed_drivers="doas mhwd -li -d" 
alias GPU_install_driver_free="doas mhwd -a pci free 0300"
alias GPU_install_driver_proprietary="doas mhwd -a pci nonfree 0300"
alias GPU_check_driver="doas mhwd-gpu --check"
alias GPU_status_driver="doas mhwd-gpu --status"
alias GPU_set_module_driver="doas mhwd-gpu --setmod"
# doas mhwd-gpu --setxorg /etc/x11/xorg.conf

function GPU_remove_driver_by_name(){
    doas mhwd -r pci "$1";
}
