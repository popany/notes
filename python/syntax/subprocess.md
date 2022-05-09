# subprocess

- [subprocess](#subprocess)
  - [Popen](#popen)

## Popen

    cmd = ['docker', 'exec', '-ti', container_name, 'bash', '-c', 'cd /; ls']

    with subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=False) as proc:
        for line in proc.stdout.readlines():
            sys.stdout.write(line.decode('utf-8'))


