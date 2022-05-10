# subprocess

- [subprocess](#subprocess)
  - [Popen](#popen)

## Popen

    cmd = ['docker', 'exec', '-ti', container_name, 'bash', '-c', 'cd /; ls']

    with subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=False) as proc:
        while True:
            line = proc.stdout.readline()
            if not line:
                sys.stdout.write('\n')
                break
            sys.stdout.write(line.decode('utf-8'))


