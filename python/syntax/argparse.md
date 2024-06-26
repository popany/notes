# argparse

- [argparse](#argparse)
  - [Example of argparse with subparsers for python](#example-of-argparse-with-subparsers-for-python)

## [Example of argparse with subparsers for python](https://gist.github.com/amarao/36327a6f77b86b90c2bca72ba03c9d3a)

    #!/usr/bin/env python
    import argparse
    
    
    def main(command_line=None):
        parser = argparse.ArgumentParser('Blame Praise app')
        parser.add_argument(
            '--debug',
            action='store_true',
            help='Print debug info'
        )
        subparsers = parser.add_subparsers(dest='command')
        blame = subparsers.add_parser('blame', help='blame people')
        blame.add_argument(
            '--dry-run',
            help='do not blame, just pretend',
            action='store_true'
        )
        blame.add_argument('name', nargs='+', help='name(s) to blame')
        praise = subparsers.add_parser('praise', help='praise someone')
        praise.add_argument('name', help='name of person to praise')
        praise.add_argument(
            'reason',
            help='what to praise for (optional)',
            default="no reason",
            nargs='?'
        )
        args = parser.parse_args(command_line)
        if args.debug:
            print("debug: " + str(args))
        if args.command == 'blame':
            if args.dry_run:
                print("Not for real")
            print("blaming " + ", ".join(args.name))
        elif args.command == 'praise':
            print('praising ' + args.name + ' for ' + args.reason)
    
    
    if __name__ == '__main__':
        main()
