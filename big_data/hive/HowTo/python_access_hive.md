# python access hive

- [python access hive](#python-access-hive)
  - [python 访问需 kerberos 认证的 hive](#python-访问需-kerberos-认证的-hive)
    - [环境](#环境)
    - [centos 中配置 kerberos 认证](#centos-中配置-kerberos-认证)
      - [安装 kerberos 客户端](#安装-kerberos-客户端)
      - [拷贝配置与认证文件](#拷贝配置与认证文件)
      - [完成认证](#完成认证)
        - [查看 hive.keytab 文件中的用户](#查看-hivekeytab-文件中的用户)
        - [选择用户 hive/tdh03@HADOOP.COM 进行认证](#选择用户-hivetdh03hadoopcom-进行认证)
    - [python 环境准则](#python-环境准则)
      - [安装工具包](#安装工具包)
      - [启动 jupyter](#启动-jupyter)
      - [python 代码](#python-代码)
        - [参考](#参考)

## python 访问需 kerberos 认证的 hive

### 环境

- docker

- centos8

- python3

- jupter

### centos 中配置 kerberos 认证

#### 安装 kerberos 客户端

    yum install -y krb5-workstation

#### 拷贝配置与认证文件

- 将 krb5.conf 文件拷贝至 /etc/krb5.conf

- 将 hive.keytab 拷贝至 /var/kerberos/krb5/user/hive.keytab

#### 完成认证

##### 查看 hive.keytab 文件中的用户

    # klist -ket  /var/kerberos/krb5/user/hive.keytab

    Keytab name: FILE:/var/kerberos/krb5/user/hive.keytab
    KVNO Timestamp         Principal
    ---- ----------------- --------------------------------------------------------
    2 10/19/20 09:49:16 hive/tdh03@HADOOP.COM (aes256-cts-hmac-sha1-96)
    2 10/19/20 09:49:16 hive/tdh03@HADOOP.COM (aes128-cts-hmac-sha1-96)
    2 10/19/20 09:49:16 hive/tdh03@HADOOP.COM (des3-cbc-sha1)
    2 10/19/20 09:49:16 hive/tdh03@HADOOP.COM (arcfour-hmac)
    2 10/19/20 09:49:16 hive/tdh03@HADOOP.COM (camellia256-cts-cmac)
    2 10/19/20 09:49:16 hive/tdh03@HADOOP.COM (camellia128-cts-cmac)
    2 10/19/20 09:49:16 hive/tdh03@HADOOP.COM (des-hmac-sha1)
    2 10/19/20 09:49:16 hive/tdh03@HADOOP.COM (des-cbc-md5)
    8 10/19/20 09:50:40 hive/tdh01@HADOOP.COM (aes256-cts-hmac-sha1-96)
    8 10/19/20 09:50:40 hive/tdh01@HADOOP.COM (aes128-cts-hmac-sha1-96)
    8 10/19/20 09:50:40 hive/tdh01@HADOOP.COM (des3-cbc-sha1)
    8 10/19/20 09:50:40 hive/tdh01@HADOOP.COM (arcfour-hmac)
    8 10/19/20 09:50:40 hive/tdh01@HADOOP.COM (camellia256-cts-cmac)
    8 10/19/20 09:50:40 hive/tdh01@HADOOP.COM (camellia128-cts-cmac)
    8 10/19/20 09:50:40 hive/tdh01@HADOOP.COM (des-hmac-sha1)
    8 10/19/20 09:50:40 hive/tdh01@HADOOP.COM (des-cbc-md5)
    2 10/19/20 09:50:43 hive/tdh02@HADOOP.COM (aes256-cts-hmac-sha1-96)
    2 10/19/20 09:50:43 hive/tdh02@HADOOP.COM (aes128-cts-hmac-sha1-96)
    2 10/19/20 09:50:43 hive/tdh02@HADOOP.COM (des3-cbc-sha1)
    2 10/19/20 09:50:43 hive/tdh02@HADOOP.COM (arcfour-hmac)
    2 10/19/20 09:50:43 hive/tdh02@HADOOP.COM (camellia256-cts-cmac)
    2 10/19/20 09:50:43 hive/tdh02@HADOOP.COM (camellia128-cts-cmac)
    2 10/19/20 09:50:43 hive/tdh02@HADOOP.COM (des-hmac-sha1)
    2 10/19/20 09:50:43 hive/tdh02@HADOOP.COM (des-cbc-md5)

##### 选择用户 hive/tdh03@HADOOP.COM 进行认证

    kinit -kt /var/kerberos/krb5/user/hive.keytab hive/tdh03@HADOOP.COM

### python 环境准则

#### 安装工具包

    conda install sasl
    conda install thrift
    conda install thrift-sasl
    conda install pyhive

#### 启动 jupyter

    jupyter notebook --ip=0.0.0.0 --port=50000 --allow-root .

#### python 代码

    from pyhive import hive
    conn = hive.Connection(host="tdh03", port=10000, username="hive", auth='KERBEROS', kerberos_service_name="hive")

    cursor = conn.cursor()
    cursor.execute('show databases')
    row = cursor.fetchone() 
    while row: 
        print(row[0])
        row = cursor.fetchone()

##### 参考

- [PyHive](https://pypi.org/project/PyHive/)

- [How to Access Hive via Python?](https://stackoverflow.com/questions/21370431/how-to-access-hive-via-python)
