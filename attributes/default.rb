case default[:platform_family]
when "mac_os_x"
  default[:dotfiles] = {
    user: "jimmy",
    group: "staff",
    home_path: "/Users/jimmy"
  }
else
  default[:dotfiles] = {
    user: "jimmy",
    group: "jimmy",
    home_path: "/home/jimmy"
  }
end
