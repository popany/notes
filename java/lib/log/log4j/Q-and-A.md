# Q&A

- [Q&A](#qa)
  - [Why log4j's Logger.getLogger() need pass a Class type?](#why-log4js-loggergetlogger-need-pass-a-class-type)

## [Why log4j's Logger.getLogger() need pass a Class type?](https://stackoverflow.com/questions/14596690/why-log4js-logger-getlogger-need-pass-a-class-type)

1. You can always use any string as logger name other than class type. It's definitely ok.

2. The reason why many people use class type, I guess:

   - Easy to use. You don't need to worry about logger name duplication in a complex Java EE application. If other people also use your logger name, you may have a log file including no only the output of your class;

   - Easy to check the logging class, as the logger name will show in the log file. You can quickly navigate to the specific class;

   - When you distribute you class, people may want to redirect the logging from your class to a specific file or somewhere else. In such case, if you use a special logger name, we may need to check the source code or imposssible to do that if souce is unavailable.







