# [MyBatis-Plus](https://baomidou.com/guide/)

- [MyBatis-Plus](#mybatis-plus)
  - [HowTo](#howto)
    - [`MetaObjectHandler`](#metaobjecthandler)
  - [分页](#分页)
    - [分页插件](#分页插件)

## HowTo

### `MetaObjectHandler`

[mybatis-plus（公共字段自动填充的配置和使用）](https://www.cnblogs.com/stephen-java/p/11247020.html)

[MybatisPlus MetaObjectHandler 配置了没起作用](https://blog.csdn.net/u011936951/article/details/105912597)

[Mybatisplus实现MetaObjectHandler接口自动更新创建时间更新时间](https://blog.csdn.net/as849167276/article/details/105216940)

## 分页

### [分页插件](https://baomidou.com/guide/page.html)

    //Spring boot方式
    @Configuration
    @MapperScan("com.baomidou.cloud.service.*.mapper*")
    public class MybatisPlusConfig {

        // 旧版
        @Bean
        public PaginationInterceptor paginationInterceptor() {
            PaginationInterceptor paginationInterceptor = new PaginationInterceptor();
            // 设置请求的页面大于最大页后操作， true调回到首页，false 继续请求  默认false
            // paginationInterceptor.setOverflow(false);
            // 设置最大单页限制数量，默认 500 条，-1 不受限制
            // paginationInterceptor.setLimit(500);
            // 开启 count 的 join 优化,只针对部分 left join
            paginationInterceptor.setCountSqlParser(new JsqlParserCountOptimize(true));
            return paginationInterceptor;
        }
        
        // 最新版
        @Bean
        public MybatisPlusInterceptor mybatisPlusInterceptor() {
            MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
            interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.H2));
            return interceptor;
        }
        
    }

demo:

    @Configuration
    public class MybatisPlusConfig {

        @Autowired
        DataSourceProperties dataSourceProperties;

        @Bean
        public MybatisPlusInterceptor mybatisPlusInterceptor() {
            MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
            DbType dbType = JdbcUtils.getDbType(dataSourceProperties.getUrl());
            interceptor.addInnerInterceptor(new PaginationInnerInterceptor(dbType));
            return interceptor;
        }
    }
