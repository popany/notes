# log4net config

- [log4net config](#log4net-config)
  - [PatternLayout](#patternlayout)
    - [Examples](#examples)

## [PatternLayout](https://logging.apache.org/log4net/release/sdk/html/T_log4net_Layout_PatternLayout.htm)

### Examples

    <b>%timestamp [%thread] %level %logger %ndc - %message%newline</b>

    <conversionPattern value="[%date{yyyy-MM-dd HH:mm:ss.fff}][%class][%method][%line][%level] %message%newline" />
