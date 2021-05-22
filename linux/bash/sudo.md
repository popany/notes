# sudo

- [sudo](#sudo)
  - [Add User to Sudoers on CentOS](#add-user-to-sudoers-on-centos)
    - [Step 1: Login as Administrator](#step-1-login-as-administrator)
    - [Step 2: Create a New Sudo User](#step-2-create-a-new-sudo-user)
    - [How to Add Users to Sudo Group](#how-to-add-users-to-sudo-group)
      - [Step 1: Verify the Wheel Group is Enabled](#step-1-verify-the-wheel-group-is-enabled)
      - [Step 2: Add User to Group](#step-2-add-user-to-group)
      - [Step: 3 Switch to the Sudo User](#step-3-switch-to-the-sudo-user)
    - [Alternative: Add User to Sudoers Configuration File](#alternative-add-user-to-sudoers-configuration-file)
      - [Step 1: Open the Sudoers File in an Editor](#step-1-open-the-sudoers-file-in-an-editor)
      - [Step 2: Add the New User to file](#step-2-add-the-new-user-to-file)

## [Add User to Sudoers on CentOS](https://phoenixnap.com/kb/how-to-create-add-sudo-user-centos)

### Step 1: Login as Administrator

    ssh root@server_ip_address

### Step 2: Create a New Sudo User

    adduser UserName

    passwd UserName

### How to Add Users to Sudo Group

By default, CentOS 7 has a user group called the "wheel" group. Members of the wheel group are automatically granted sudo privileges. Adding a user to this group is a quick and easy way to grant sudo privileges to a user.

#### Step 1: Verify the Wheel Group is Enabled

Your CentOS 7 installation may or may not have the wheel group enabled.

Open the configuration file by entering the command:

    visudo

Scroll through the configuration file until you see the following entry:

    ## Allows people in group wheel to run all commands

    # %wheel        ALL=(ALL)       ALL

If the second line begins with the `#` sign, it has been disabled and marked as a comment. Just delete the `#` sign at the beginning of the second line so it looks like the following:

    %wheel        ALL=(ALL)       ALL

Then save the file and exit the editor.

#### Step 2: Add User to Group

To add a user to the wheel group, use the command:

    usermod –aG wheel UserName

#### Step: 3 Switch to the Sudo User

Switch to the new (or newly-elevated) user account with the su (substitute user) command:

    su - UserName

Enter the password if prompted. The terminal prompt should change to include the UserName.

Enter the following command to list the contents of the `/root` directory:

    sudo ls -la /root

The terminal should request the password for UserName. Enter it, and you should see a display of the list of directories. Since listing the contents of `/root` requires sudo privileges, this works as a quick way to prove that UserName can use the sudo command.

### Alternative: Add User to Sudoers Configuration File

If there's a problem with the `wheel` group, or administrative policy prevents you from creating or modifying groups, you can add a user directly to the sudoers configuration file to grant sudo privileges.

#### Step 1: Open the Sudoers File in an Editor

In the terminal, run the following command:

    visudo

This will open the `/etc/sudoers` file in a text editor.

#### Step 2: Add the New User to file

Scroll down to find the following section:

    ## Allow root to run any commands anywhere

    root ALL=(ALL) ALL

Right after this entry, add the following text:

    UserName ALL=(ALL) ALL

Replace `UserName` with the username you created in Step 2. This section should look like the following:

    ## Allow root to run any commands anywhere

    root ALL=(ALL) ALL

    UserName ALL=(ALL) ALL

Save the file and exit.
