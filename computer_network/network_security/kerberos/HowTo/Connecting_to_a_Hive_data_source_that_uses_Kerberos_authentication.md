# [Connecting to a Hive data source that uses Kerberos authentication](https://www.ibm.com/support/knowledgecenter/en/SSQNUZ_2.1.0/com.ibm.icpdata.doc/zen/admin/hive-kerb-connection.html)

- [Connecting to a Hive data source that uses Kerberos authentication](#connecting-to-a-hive-data-source-that-uses-kerberos-authentication)
  - [Before you begin](#before-you-begin)
  - [Procedure](#procedure)

If you want to discover assets that are stored in a Hive data source that uses Kerberos authentication, you must add your krb5.conf file and several keytab files your IBM® Cloud Pak for Data cluster.

## Before you begin

Locate the following files on your Hive server:

- The krb5.conf file

- A user keytab file

- The Hive service keytab file

To complete this task, you must have the appropriate permissions to transfer files from the Hive server.

## Procedure

1. SSH into the master node (master-1) as root:

       ssh root@MASTER-1-IP

2. Copy the following files from your Hive server to a temporary directory on the master node of your Cloud Pak for Data cluster:

   - Copy the krb5.conf file:

         scp root@hive-server:/etc/krb5.conf  ICPD-MASTER-1-IP/tmp

     Replace hive-server with the hostname of your Hive server.

   - Copy the keytab file from the Hive server. You can use the hive.service.keytab file or the

         scp root@hive-server:/etc/security/keytabs/hive.service.keytab ICPD-MASTER-1-IP/tmp

     Replace hive-server with the hostname of your Hive server.

   - Copy the keytab file for a Hive server user:

         scp root@hive-server:path-to-user-keytab-files/user-keytab-file ICPD-MASTER-1-IP/tmp

     Replace the following values:

     - Replace hive-server with the hostname of your Hive server.
     - Replace path-to-user-keytab-files with the fully qualified path of the keytab files directory on the server.
     - Replace user-keytab-file with the name of the specific user keytab file to copy.

3. Open the Bash interface in the is-en-conductor-0 pod:

       kubectl exec -it is-en-conductor-0 -n namespace /bin/bash

   Replace namespace with the namespace where Cloud Pak for Data is deployed. The default namespace is zen.

4. Edit the JDBCDriverLogin.conf file:

   - Change to the /opt/IBM/InformationServer/ASBNode/lib/java directory.

   - Create a file named JDBCDriverLogin.conf:

         vi JDBCDriverLogin.conf

   - Add the following lines to the file:

         JDBC_DRIVER_keytab{
         com.ibm.security.auth.module.Krb5LoginModule required
         credsType=both
         principal="hive/hive-server@kerberos-realm"
         useKeytab="FILE:/etc/security/keytabs/hive.service.keytab";
         };

     Replace the following values:

     - Replace hive-server with the hostname of your Hive server.
     - Replace kerberos-realm with the domain in which the Kerberos authentication server has the authority to authenticate. For example: IBM.COM

     Ensure that the file has the same structure as the preceding snippet.

   - Save the JDBCDriverLogin.conf file:

     Press Esc.

     Enter :wq

5. Copy the krb5.conf and keytab files to the is-en-conductor-0 pod:

   - Create the following directory:

         mkdir /etc/security/keytabs

   - Exit the is-en-conductor-0 pod:

         exit

   - Copy the krb5.conf file:

         kubectl cp /tmp/krb5.conf namespace/is-en-conductor-0:/etc/krb5.conf

     Replace namespace with the namespace where Cloud Pak for Data is deployed. The default namespace is zen.

   - Copy the keytab file from the Hive server. You can use the hive.service.keytab file or the

         kubectl cp /tmp/hive.service.keytab namespace/is-en-conductor-0:/etc/security/keytabs/hive.service.keytab

     Replace namespace with the namespace where Cloud Pak for Data is deployed. The default namespace is zen.

   - Copy the user keytab file:

         kubectl cp /tmp/user-keytab namespace/is-en-conductor-0:/etc/security/keytabs/user-keytab

     Replace the following values:

     - Replace namespace with the namespace where Cloud Pak for Data is deployed. The default namespace is zen.
     - Replace user-keytab with the name of the user keytab file.

6. Open the Bash interface in the is-en-conductor-0 pod:

       kubectl exec -it is-en-conductor-0 -n namespace /bin/bash

   Replace namespace with the namespace where Cloud Pak for Data is deployed. The default namespace is zen.

7. Give the keytab file for the Hive server read permissions:

       chmod -R 755  /etc/security/keytabs/hive.service.keytab

8. Update the Agent.sh file:

   - Change to the /opt/IBM/InformationServer/ASBNode/bin directory.

   - Open Agent.sh file:

         vi Agent.sh

   - Add the following line before the classpath entry:

         '-Djava.security.auth.login.config=/opt/IBM/InformationServer/ASBNode/lib/java/JDBCDriverLogin.conf'

   - Save your changes to the Agent.sh file:

        Press Esc.

        Enter :wq

9. Restart the ISF node agent by running the following commands in order:

   service ISFAgents stop
   service ISFAgents start

10. Update the dsenv file:

    - Change to the /opt/IBM/InformationServer/Server/DSEngine directory.

    - Open the dsenv file:

          vi dsenv

    - Add the following line to the file:

          CC_JVM_OPTIONS=-Djava.security.auth.login.config=/opt/IBM/InformationServer/ASBNode/lib/java/JDBCDriverLogin.conf; export CC_JVM_OPTIONS 

    - Save your changes to the dsenv file:

      Press Esc.

      Enter :wq

11. Restart the ISF node agent by running the following commands in order:

        service ISFAgents stop
        service ISFAgents start

12. Restart the data governance service:

    - Change to the /opt/IBM/InformationServer/Server/DSEngine directory.

    - Stop the service:

          bin/uv -admin -stop

    - Start the service:

          bin/uv -admin -start

13. Exit the is-en-conductor-0 pod:

        exit

14. Create the connection to your Hive data source:

    - Open the Cloud Pak for Data web client.

    - From the navigation, select Connections.

    - Click Add connection.

    - Specify the display name for the connection and select one of the following options:

      - Hive JDBC - CDH
      - Hive JDBC - HDP

    - Specify the connection details.

      You do not need to specify a username or password.

    - In the Options field, enter the following string:

          MaxStringSize=256;AuthenticationMethod=kerberos;ServicePrincipalName=hive/hive-server@kerberos-realm;loginConfigName=JDBC_DRIVER_keytab

      Replace the following values:

      - Replace hive-server with the hostname of your Hive server.
      - Replace kerberos-realm with the domain in which the Kerberos authentication server has the authority to authenticate. For example: IBM.COM

    - Test the connection and then click Add.
