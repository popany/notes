# [Ignite Persistence](https://ignite.apache.org/docs/latest/persistence/native-persistence)

- [Ignite Persistence](#ignite-persistence)
  - [Overview](#overview)
  - [Enabling Persistent Storage](#enabling-persistent-storage)
  - [Configuring Persistent Storage Directory](#configuring-persistent-storage-directory)
  - [Write-Ahead Log](#write-ahead-log)
    - [WAL Modes](#wal-modes)
    - [WAL Archive](#wal-archive)
    - [Changing WAL Segment Size](#changing-wal-segment-size)
    - [Disabling WAL](#disabling-wal)
    - [WAL Archive Compaction](#wal-archive-compaction)
    - [Disabling WAL Archive](#disabling-wal-archive)
    - [Checkpointing](#checkpointing)
  - [Configuration Properties](#configuration-properties)

## Overview

Ignite Persistence, or Native Persistence, is a set of features designed to provide persistent storage. When it is enabled, Ignite always stores all the data on disk, and **loads as much data as it can** into RAM for processing. For example, if there are 100 entries and RAM has the capacity to store only 20, then all 100 are stored on disk and only 20 are cached in RAM for better performance.

When Native persistence is turned off and no external storage is used, Ignite behaves as a pure in-memory store.

When persistence is enabled, every server node persists a subset of the data that only includes the partitions that are assigned to that node (including backup partitions if backups are enabled).

The Native Persistence functionality is based on the following features:

- Storing data partitions on disk

- Write-ahead logging

- Checkpointing

- Usage of OS swap

When persistence is enabled, Ignite **stores each partition in a separate file on disk**. The data format of the partition files is the same as that of the data when it is kept in memory. If partition backups are enabled, they are also saved on disk. In addition to **data partitions**, Ignite stores **indexes** and **metadata**.

You can change the default location of data files in the configuration.

## Enabling Persistent Storage

Native Persistence is configured per data region. To enable persistent storage, set the `persistenceEnabled` property to `true` in the data region configuration. You can have in-memory data regions and data regions with persistence at the same time.

The following example shows how to enable persistent storage for the default data region.

    <bean class="org.apache.ignite.configuration.IgniteConfiguration">
        <property name="dataStorageConfiguration">
            <bean class="org.apache.ignite.configuration.DataStorageConfiguration">
                <property name="defaultDataRegionConfiguration">
                    <bean class="org.apache.ignite.configuration.DataRegionConfiguration">
                        <property name="persistenceEnabled" value="true"/>
                    </bean>
                </property>
            </bean>
        </property>
    </bean>

## Configuring Persistent Storage Directory

When persistence is enabled, the node stores **user data**, **indexes** and **WAL** files in the `{IGNITE_WORK_DIR}/db` directory. This directory is referred to as the **storage directory**. You can change the storage directory by setting the `storagePath` property of the `DataStorageConfiguration` object, as shown below.

Each node maintains the following sub-directories under the storage directory meant to store **cache data**, **WAL files**, and **WAL archive files**:

|Subdirectory name|Description|
|-|-|
`{WORK_DIR}/db/{nodeId}`|This directory contains cache data and indexes.
`{WORK_DIR}/db/wal/{nodeId}`|This directory contains WAL files.
`{WORK_DIR}/db/wal/archive/{nodeId}`|This directory contains WAL archive files.
|||

`nodeId` here is either the consistent node ID (if it’s defined in the node configuration) or [auto-generated node id](https://cwiki.apache.org/confluence/display/IGNITE/Ignite+Persistent+Store+-+under+the+hood#IgnitePersistentStore-underthehood-SubfoldersGeneration). It is used to ensure uniqueness of the directories for the node. If multiple nodes share the same work directory, they uses different sub-directories.

If the work directory contains persistence files for multiple nodes (there are multiple `{nodeId}` subdirectories with different nodeIds), the node picks up the first subdirectory that is not being used. To make sure a node always uses a specific subdirectory and, thus, specific data partitions even after restarts, set `IgniteConfiguration.setConsistentId` to a cluster-wide unique value in the node configuration.

You can change the storage directory as follows:

    <bean class="org.apache.ignite.configuration.IgniteConfiguration">
        <property name="dataStorageConfiguration">
            <bean class="org.apache.ignite.configuration.DataStorageConfiguration">
                <property name="defaultDataRegionConfiguration">
                    <bean class="org.apache.ignite.configuration.DataRegionConfiguration">
                        <property name="persistenceEnabled" value="true"/>
                    </bean>
                </property>
                <property name="storagePath" value="/opt/storage"/>
            </bean>
        </property>
    </bean>

You can also change the **WAL** and **WAL archive** paths to point to directories outside of the storage directory. Refer to the next section for details.

## Write-Ahead Log

The write-ahead log is a log of all **data modifying operations** (including deletes) that happen on a node. When a page is updated in RAM, the update is not directly written to the partition file but is appended to the tail of the WAL.

The purpose of the write-ahead log is to provide a **recovery mechanism** for scenarios where a single node or the whole cluster goes down. In case of a crash or restart, the cluster can always be recovered to the latest successfully committed transaction by relying on the content of the WAL.

The WAL consists of several files (called **active segments**) and an **archive**. The active segments are filled out sequentially and are overwritten in a cyclical order. Once the 1st segment is full, its content is copied to the WAL archive (see the WAL Archive section below). While the 1st segment is being copied, the 2nd segment is treated as an active WAL file and accepts all the updates coming from the application side. By default, there are 10 active segments.

### WAL Modes

There are three WAL modes. Each mode differs in how it affects performance and provides different consistency guarantees.

|Mode|Description|Consistency Guarantees|
|-|-|-|
`FSYNC`|The changes are guaranteed to be persisted to disk for every atomic write or transactional commit.|Data updates are never lost surviving any OS or process crashes, or power failure.
`LOG_ONLY`|The default mode. <br> The changes are guaranteed to be flushed to either the OS buffer cache or a memory-mapped file for every atomic write or transactional commit. <br> The memory-mapped file approach is used by default and can be switched off by setting the IGNITE_WAL_MMAP system property to false. | Data updates survive a process crash.
`BACKGROUND`|When the `IGNITE_WAL_MMAP` property is enabled (default), this mode behaves like the `LOG_ONLY` mode. <br> If the memory-mapped file approach is disabled then the changes stay in node’s internal buffer and are periodically flushed to disk. The frequency of flushing is specified via the `walFlushFrequency` parameter.|When the `IGNITE_WAL_MMAP` property is enabled (default), the mode provides the same guarantees as `LOG_ONLY` mode. <br> Otherwise, recent data updates may get lost in case of a process crash or other outages.
`NONE`|WAL is disabled. The changes are persisted only if you shut down the node gracefully. Use `Ignite.active(false)` to deactivate the cluster and shut down the node.|Data loss might occur. <br> If a node is terminated abruptly during update operations, it is very likely that the data stored on the disk becomes out-of-sync or corrupted.
||||

### WAL Archive

The WAL archive is used to store WAL segments that may be needed to recover the node after a crash. The number of segments kept in the archive is such that the total size of all segments does not exceed the specified size of the WAL archive.

By default, the maximum size of the WAL archive (total space it occupies on disk) is defined as 4 times the size of the [checkpointing buffer](https://www.gridgain.com/docs/latest/perf-troubleshooting-guide/persistence-tuning#adjusting-checkpointing-buffer-size). You can change that value in the [configuration](https://www.gridgain.com/docs/latest/developers-guide/persistence/native-persistence#configuration-properties).

Setting the WAL archive size to a value lower than the default may impact performance and should be tested before being used in production.

### Changing WAL Segment Size

The default WAL segment size (64 MB) may be inefficient in high load scenarios because it causes WAL to switch between segments too frequently and switching/rotation is a costly operation. A larger size of WAL segments can help increase performance under high loads at the cost of increasing the total size of the WAL files and WAL archive.

You can change the size of the WAL segment files in the data storage configuration. The value must be between 512KB and 2GB.

    <bean class="org.apache.ignite.configuration.IgniteConfiguration" id="ignite.cfg">
    
        <property name="dataStorageConfiguration">
            <bean class="org.apache.ignite.configuration.DataStorageConfiguration">
    
                <!-- set the size of wal segments to 128MB -->
                <property name="walSegmentSize" value="#{128 * 1024 * 1024}"/>
    
                <property name="defaultDataRegionConfiguration">
                    <bean class="org.apache.ignite.configuration.DataRegionConfiguration">
                        <property name="persistenceEnabled" value="true"/>
                    </bean>
                </property>
    
            </bean>
        </property>
    </bean>

### Disabling WAL

There are situations when it is reasonable to have the WAL disabled to get better performance. For instance, it is useful to disable WAL during initial data loading and enable it after the pre-loading is complete.

    IgniteConfiguration cfg = new IgniteConfiguration();
    DataStorageConfiguration storageCfg = new DataStorageConfiguration();
    storageCfg.getDefaultDataRegionConfiguration().setPersistenceEnabled(true);

    cfg.setDataStorageConfiguration(storageCfg);

    Ignite ignite = Ignition.start(cfg);

    ignite.cluster().state(ClusterState.ACTIVE);

    String cacheName = "myCache";

    ignite.getOrCreateCache(cacheName);

    ignite.cluster().disableWal(cacheName);

    //load data
    ignite.cluster().enableWal(cacheName);

### WAL Archive Compaction

You can enable WAL Archive compaction to reduce the space occupied by the WAL Archive. By default, WAL Archive contains segments for the last 20 checkpoints (this number is configurable). If compaction is enabled, all archived segments that are 1 checkpoint old are compressed in ZIP format. If the segments are needed (for example, to re-balance data between nodes), they are uncompressed to RAW format.

### Disabling WAL Archive

In some cases, you may want to disable WAL archiving, for example, to reduce the overhead associated with copying of WAL segments to the archive. There can be a situation where GridGain writes data to WAL segments faster than the segments are copied to the archive. This may create an I/O bottleneck that can freeze the operation of the node. If you experience such problems, try disabling WAL archiving.

To disable archiving, set the WAL path and the WAL archive path to the same value. In this case, GridGain does not copy segments to the archive; instead, it creates new segments in the WAL folder. Old segments are deleted as the WAL grows, based on the WAL Archive size setting.

### Checkpointing

`Checkpointing` is the process of copying dirty pages from RAM to partition files on disk. A dirty page is a page that was updated in RAM but was not written to the respective partition file (the update, however, was appended to the WAL).

After a checkpoint is created, all changes are persisted to disk and will be available if the node crashes and is restarted.

**Checkpointing** and **write-ahead logging** are designed to ensure **durability** of data and **recovery** in case of a node failure.

This process helps to utilize disk space frugally by keeping pages in the most up-to-date state on disk. After a checkpoint is passed, you can delete the WAL segments that were created before that point in time.

See the following related documentation:

- [Monitoring Checkpointing Operations](https://www.gridgain.com/docs/latest/administrators-guide/monitoring-metrics/metrics#monitoring-checkpointing-operations)

- [Adjusting Checkpointing Buffer Size](https://www.gridgain.com/docs/latest/perf-troubleshooting-guide/persistence-tuning#adjusting-checkpointing-buffer-size)

## Configuration Properties

The following table describes some properties of [DataStorageConfiguration](https://www.gridgain.com/sdk/8.8.2/javadoc/org/apache/ignite/configuration/DataStorageConfiguration.html).

|Property Name|Description|Default Value|
`persistenceEnabled`|Set this property to `true` to enable Native Persistence.|`false`
`storagePath`|The path where data is stored.|`${IGNITE_HOME}/work/db/node{IDX}-{UUID}`
`walPath`|The path to the directory where active WAL segments are stored.|`${IGNITE_HOME}/work/db/wal/`
`walArchivePath`|The path to the WAL archive.|`${IGNITE_HOME}/work/db/wal/archive/`
`walCompactionEnabled`|Set to `true` to enable [WAL archive compaction](https://www.gridgain.com/docs/latest/developers-guide/persistence/native-persistence#wal-archive-compaction).|`false`
`walSegmentSize`|The size of a WAL segment file in bytes.|64MB
`walMode`|[Write-ahead logging mode](https://www.gridgain.com/docs/latest/developers-guide/persistence/native-persistence#wal-modes).|`LOG_ONLY`
`walCompactionLevel`|WAL archive compression level. `1` indicates the fastest speed, and `9` indicates the best compression.|`1`
`maxWalArchiveSize`|The maximum size (in bytes) the WAL archive can occupy on the file system.|Four times the size of the [checkpointing buffer](https://www.gridgain.com/docs/latest/perf-troubleshooting-guide/persistence-tuning#adjusting-checkpointing-buffer-size).
||||
