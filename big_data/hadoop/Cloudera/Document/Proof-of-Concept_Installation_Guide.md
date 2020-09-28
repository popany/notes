# [Proof-of-Concept Installation Guide](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_installation.html)

- [Proof-of-Concept Installation Guide](#proof-of-concept-installation-guide)
  - [Before You Begin](#before-you-begin)
    - [(Optional) Configure an HTTP Proxy](#optional-configure-an-http-proxy)
    - [Disable SELinux](#disable-selinux)
  - [Installing a Proof-of-Concept Cluster](#installing-a-proof-of-concept-cluster)
    - [Step 1: Download and Run the Cloudera Manager Server Installer](#step-1-download-and-run-the-cloudera-manager-server-installer)
    - [Step 2: Install CDH Using the Wizard](#step-2-install-cdh-using-the-wizard)
    - [Step 3: Set Up a Cluster Using the Wizard](#step-3-set-up-a-cluster-using-the-wizard)
  - [Managing the Embedded PostgreSQL Database](#managing-the-embedded-postgresql-database)
  - [Migrating from the Cloudera Manager Embedded PostgreSQL Database Server to an External PostgreSQL Database](#migrating-from-the-cloudera-manager-embedded-postgresql-database-server-to-an-external-postgresql-database)

This guide provides instructions for installing Cloudera software in a non-production environment for demonstration and proof-of-concept use cases. In these procedures, Cloudera Manager automates the installation of the Oracle JDK, Cloudera Manager Server, an embedded PostgreSQL database, Cloudera Manager Agent, CDH, and other managed services on cluster hosts. Cloudera Manager also configures databases for the Cloudera Manager Server and Hive Metastore and optionally for Cloudera Management Service roles.

This guide is recommended for demonstration, testing, and proof-of-concept deployments, but is not supported for production deployments because it is not designed to scale. To use this method, server and cluster hosts must satisfy the following requirements:

- You must be able to log in to the Cloudera Manager Server host using the root user account or an account that has passwordless sudo privileges.
- The Cloudera Manager Server host must have uniform SSH access on the same port to all hosts. For more information, see [CDH and Cloudera Manager Networking and Security Requirements](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/rg_network_and_security_requirements.html#cdh_cm_network_security).
- All hosts must have access to standard package repositories for the operating system and either archive.cloudera.com or a local repository with the required installation files.
- SELinux must be disabled or set to permissive mode before running the installer. For more information, see [Disable SELinux](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_installation_reqs.html#poc_install_reqs__installer_disable_selinux).

## [Before You Begin](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_installation_reqs.html)

### (Optional) Configure an HTTP Proxy

The Cloudera Manager installer accesses `archive.cloudera.com` by using `yum` on RHEL systems, `zypper` on SLES systems, or `apt-get` on Ubuntu systems. If your hosts access the Internet through an HTTP proxy, you can configure `yum`, `zypper`, or `apt-get`, system-wide, to access `archive.cloudera.com` through a proxy.

To do so, modify the system configuration on every cluster host as follows:

||||
|-|-|-|
|OS | File | Property|
|RHEL-compatible | /etc/yum.conf | `proxy=http://server:port/`|
|SLES | /root/.curlrc | `--proxy=http://server:port/`|
|Ubuntu | /etc/apt/apt.conf | `Acquire::http::Proxy "http://server:port";`
||||

### Disable SELinux

Although Cloudera supports running Cloudera software with SELinux enabled, the Cloudera Manager installer will not proceed if SELinux is enabled. Disable SELinux or set it to permissive mode before running the installer. For instructions, see [Setting SELinux mode](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/install_cdh_disable_selinux.html).

After you have installed and deployed Cloudera Manager and CDH, you can re-enable SELinux by changing `SELINUX=permissive` back to `SELINUX=enforcing` in `/etc/selinux/config` (or `/etc/sysconfig/selinux`), and then running the following command to immediately switch to enforcing mode:

    setenforce 1

If you are having trouble getting Cloudera Software working with SELinux, contact your OS vendor for support. Cloudera is not responsible for developing or supporting SELinux policies.

## [Installing a Proof-of-Concept Cluster](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/cm_ig_non_production.html)

### [Step 1: Download and Run the Cloudera Manager Server Installer](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_run_installer.html#run-cms-installer)

Download the Cloudera Manager installer to the cluster host to which you are installing the Cloudera Manager Server. By default, the automated installer binary (cloudera-manager-installer.bin) installs the highest version of Cloudera Manager.

1. Download the Cloudera Manager Installer

   - Open [Cloudera Manager Downloads](https://www.cloudera.com/downloads.html) in a web browser. In the Cloudera Manager box, click Download Now.

   - You can download either the most recent version of the installer or select an earlier version from the drop-down. Click GET IT NOW!.

   - Either sign in or complete the product interest form and click Continue.

   - Read and accept the Cloudera Standard License agreement and click Submit.

   - Download the installer for your Cloudera Manager version. For example, for Cloudera Manager 6.3.3:

         wget https://username:password@archive.cloudera.com/p/cm6/6.3.3/cloudera-manager-installer.bin

     In versions 6.3.3 and higher, the Proof of Concept installer is available only to licensed users. For more information on obtaining a license and the authentication credentials required to download cloudera-manager-installer.bin, see [Cloudera Manager 6 Version and Download Information](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/rg_cm_6_version_download.html#cm_6_version_download).

2. Run the Cloudera Manager Installer

   - Change cloudera-manager-installer.bin to have execute permissions:

         chmod u+x cloudera-manager-installer.bin

   - Run the Cloudera Manager Server installer:

         sudo ./cloudera-manager-installer.bin --username=username --password=password

     For clusters without Internet access: Install Cloudera Manager packages from a local repository:

         sudo ./cloudera-manager-installer.bin --skip_repo_package=1

3. Read and Accept the Associated License Agreements

   - Read the Cloudera Manager README and then select Next to proceed.

   - Read the Cloudera Express License and then select Next to proceed. Use the arrow keys to highlight Yes and then press Enter to accept the license.

   - Read the Oracle Binary Code License Agreement and then select Next to proceed. Use the arrow keys to highlight Yes and then press Enter to accept the license.

     The installer then:

     - Installs the Cloudera Manager repository files.
     - Installs the Oracle JDK.
     - Installs the Cloudera Manager Server and embedded PostgreSQL packages.
     - Starts the embedded PostgreSQL database and Cloudera Manager Server.

   **Note**: If the installation is interrupted, run the following command on the Cloudera Manager Server host before you retry the installation:

       sudo /usr/share/cmf/uninstall-cloudera-manager.sh

   Log files for the installer are stored in `/var/log/cloudera-manager-installer/`.

4. Exit the Installer

   - When the installation completes, the complete URL for the Cloudera Manager Admin Console displays, including the port number (7180 by default). Make a note of this URL.

   - Press Enter to choose OK to exit the installer, and then again to acknowledge the successful installation.

   - Wait several minutes for the Cloudera Manager Server to start. To observe the startup process, run sudo tail -f /var/log/cloudera-scm-server/cloudera-scm-server.log on the Cloudera Manager Server host. When you see the following log entry, the Cloudera Manager Admin Console is ready:

         INFO WebServerImpl:com.cloudera.server.cmf.WebServerImpl: Started Jetty server.

      If the Cloudera Manager Server does not start, see [Troubleshooting Installation Problems](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/cm_ig_troubleshooting.html#cmig_topic_19).

### [Step 2: Install CDH Using the Wizard](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_install_cdh.html)

After Cloudera Manager Server has started up, log in to the Cloudera Manager Admin Console:

1. In a web browser, go to http://<server_host>:7180, where <server_host> is the FQDN or IP address of the host where the Cloudera Manager Server is running.

2. Log into Cloudera Manager Admin Console. The default credentials are:

   Username: admin

   Password: admin

   **Note**: Cloudera Manager does not support changing the admin username for the installed account. You can change the password using Cloudera Manager after you run the installation wizard. Although you cannot change the admin username, you can add a new user, assign administrative privileges to the new user, and then delete the default admin account.

3. After you log in, the End User License Terms and Conditions page displays. Read the terms and conditions and then check the box labeled Yes, I accept the End User License Terms and Conditions to accept them. Click Continue, and the installation wizard launches.

The following instructions walk you through the Cloudera Manager installation wizard for Cloudera Manager.

- [Select Edition](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_install_cdh.html#id_abd_dtm_25)
- [Welcome](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_install_cdh.html#concept_qdy_mz3_wcb)
- [Specify Hosts](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_install_cdh.html#id_rtd_dtm_25)
- [Select Repository](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_install_cdh.html#poc_select_repo)
- [Accept JDK License](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_install_cdh.html#poc_accept_jdk_license)
- [Enter Login Credentials](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_install_cdh.html#id_tkg_lfh_ycb)
- [Install Agents](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_install_cdh.html#poc_install_agents)
- [Install Parcels](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_install_cdh.html#poc_install_parcels)
- [Inspect Hosts](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_install_cdh.html#poc_inspect_hosts)

### [Step 3: Set Up a Cluster Using the Wizard](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_set_up_cluster.html)

After completing the Cluster Installation wizard, the Cluster Setup wizard automatically starts. The following sections guide you through each page of the wizard:

- [Select Services](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_set_up_cluster.html#poc_select_services)
- [Assign Roles](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_set_up_cluster.html#poc_assign_roles)
- [Setup Database](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_set_up_cluster.html#poc_setup_db)
- [Review Changes](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_set_up_cluster.html#poc_review_changes)
- [Command Details](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_set_up_cluster.html#poc_cmd_details)
- [Summary](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/poc_set_up_cluster.html#poc_summary)

## [Managing the Embedded PostgreSQL Database](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/cm_ig_embed_pstgrs.html)

## [Migrating from the Cloudera Manager Embedded PostgreSQL Database Server to an External PostgreSQL Database](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/cm_ag_migrate_postgres_db.html)
