# Python Logging

- [Python Logging](#python-logging)
  - [Multi Process Log](#multi-process-log)

## Multi Process Log

One log file per process

test.py

    import logging
    import os
    import pathlib
    import argparse
    from concurrent.futures import ProcessPoolExecutor
    from concurrent.futures import as_completed
    import multiprocessing
    from datetime import datetime
    import pathlib
    
    parser = argparse.ArgumentParser(prog='')
    sub_parsers = parser.add_subparsers(dest='command')
    parser_run = sub_parsers.add_parser('run')
    parser_run.add_argument('--task-count', type=int, required=True)
    args = parser.parse_args()
    
    logger = logging.getLogger()
    formatter = logging.Formatter('%(asctime)s %(process)d %(name)s %(levelname)s %(filename)s:%(lineno)s %(funcName)s| %(message)s')
    c_handler = logging.StreamHandler()
    c_handler.setLevel(logging.INFO)
    c_handler.setFormatter(formatter)
    
    script_dir = os.path.dirname(os.path.realpath(__file__))
    log_folder = datetime.now().strftime('log-%Y%m%d-%H%M%S.%f')
    main_log_file_name = 'main.log'
    main_log_file_path = pathlib.Path(script_dir) / log_folder / main_log_file_name
    main_log_file_path.parent.mkdir(parents=True, exist_ok=True)
    
    f_handler = logging.FileHandler(str(main_log_file_path))
    f_handler.setLevel(logging.INFO)
    f_handler.setFormatter(formatter)
    
    logger.addHandler(c_handler)
    logger.addHandler(f_handler)
    logger.setLevel(logging.INFO)
    
    def close_logger_handlers():
        while len(logger.handlers) > 0:
            handler = logger.handlers[0]
            logger.handlers.remove(handler)
            handler.close()
    
    def reset_logger_handlers(log_file_path):
        close_logger_handlers()
    
        file_log_handler = logging.FileHandler(str(log_file_path))
        file_log_handler.setLevel(logging.INFO)
        file_log_handler.setFormatter(formatter)
        logger.addHandler(file_log_handler)
        logger.setLevel(logging.INFO)
    
    def run_task(task_name):
        log_file_path = main_log_file_path.parent / f'task-{multiprocessing.current_process().pid}-{task_name}.log'
        reset_logger_handlers(log_file_path)
        logger.info('task_name: %s', task_name)
        close_logger_handlers()
        return f'task {task_name} done'
    
    def run_task_list():
        with ProcessPoolExecutor() as executor:
            futures = list()
            for i in range(args.task_count):
                logger.info('submit task: %s', i)
                futures.append(executor.submit(run_task, f't{i}'))
                
            for future in as_completed(futures):
                logger.info('complete, %s', future.result())
    
    if __name__ == '__main__':
        if args.command == 'run':
            run_task_list()

Run:

    $ python test.py run --task-count 3
    2022-12-07 23:51:11,761 1347 root INFO test.py:63 run_task_list| submit task: 0
    2022-12-07 23:51:11,763 1347 root INFO test.py:63 run_task_list| submit task: 1
    2022-12-07 23:51:11,765 1347 root INFO test.py:63 run_task_list| submit task: 2
    2022-12-07 23:51:11,772 1347 root INFO test.py:67 run_task_list| complete, task t0 done
    2022-12-07 23:51:11,773 1347 root INFO test.py:67 run_task_list| complete, task t1 done
    2022-12-07 23:51:11,774 1347 root INFO test.py:67 run_task_list| complete, task t2 done
    $ tree log-20221207-235111.756423/
    log-20221207-235111.756423/
    ├── main.log
    ├── task-1348-t0.log
    ├── task-1351-t1.log
    └── task-1352-t2.log

    0 directories, 4 files
