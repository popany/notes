# Build and Run Planning

- [Build and Run Planning](#build-and-run-planning)
  - [prepare](#prepare)
  - [build planning](#build-planning)
  - [bazel](#bazel)
  - [vscode](#vscode)
    - [generate compile_commands.json for planning](#generate-compile_commandsjson-for-planning)
    - [config clangd](#config-clangd)
  - [Run Planning](#run-planning)
  - [Set vscode clangd for both planning & cyber](#set-vscode-clangd-for-both-planning--cyber)

## prepare

    echo "export APOLLO_ROOT_DIR=$(pwd)" >> ~/.bashrc  && source ~/.bashrc

    bash docker/scripts/dev_start.sh

    bash docker/scripts/dev_into.sh

## build planning

show planning deps:

    bazel query --noimplicit_deps 'deps(//modules/planning:install)'  --output graph > simplified_graph.in

    # sudo apt install graphviz
    dot -Tpng < simplified_graph.in > simplified_graph.png

build:

    bash apollo.sh build_dbg planning

note:

    bash apollo.sh build_dbg planning
        |- env STAGE=dev USE_ESD_CAN=false bash /apollo/scripts/apollo_build.sh --config=dbg planning
            |- bazel build --config=gpu --config=dbg --jobs=24 '--local_ram_resources=HOST_RAM*0.7' -- //modules/planning/...

## bazel

docs/specs/bazel_in_apollo_an_overview.md


## vscode

### generate compile_commands.json for planning

https://github.com/grailbio/bazel-compilation-database

use 0.4.5 for bazel 3.7.1

1. method 1

   - install bazel-compdb

         INSTALL_DIR=$HOME
         VERSION="0.4.5"

         # Download and symlink.
         (
           cd "${INSTALL_DIR}" \
           && curl -L "https://github.com/grailbio/bazel-compilation-database/archive/${VERSION}.tar.gz" | tar -xz \
           && ln -f -s "${INSTALL_DIR}/bazel-compilation-database-${VERSION}/generate.sh" bazel-compdb
         )

   - generate compile_commands.json

         cd /apollo
         $HOME/bazel-compdb

2. method 2

   - config

     WORKSPACE file, append to end

         http_archive(
             name = "com_grail_bazel_compdb",
             strip_prefix = "bazel-compilation-database-0.4.5",
             urls = ["https://github.com/grailbio/bazel-compilation-database/archive/0.4.5.tar.gz"],
         )

     modules/planning/BUILD file, add to head

         load("@com_grail_bazel_compdb//:aspects.bzl", "compilation_database")
    
     append to end

         compilation_database(
             name = "example_compdb",
             targets = [
                 "libplanning_component.so"
             ]
         )

   - generate compile_commands.json

         bash apollo.sh build_dbg planning

     or

         bazel build --config=gpu --config=dbg example_compdb

   - replace `__EXEC_ROOT__` 

         compile_commands_file="$(bazel info execution_root)/bazel-out/k8-dbg/bin/modules/planning/compile_commands.json"

         execroot=$(bazel info execution_root)
         sed -i "s@__EXEC_ROOT__@${execroot}@" "${compile_commands_file}"

### config clangd

.vscode/settings.json file

    {
        "clangd.arguments": [
            "--compile-commands-dir=/apollo/.cache/bazel/540135163923dd7d5820f3ee4b306b32/execroot/apollo/bazel-out/k8-dbg/bin/modules/planning/"
        ]
    }

## Run Planning

start

    bash scripts/planning.sh start

stop

    bash scripts/planning.sh stop

## Set vscode clangd for both planning & cyber

- modify cyber/mainboard/BUILD as to modules/planning/BUILD

      compilation_database(
          name = "example_compdb",
          targets = [
              "mainboard"
          ]
      )

- reset .vscode/settings.json file

  remove below


        "clangd.arguments": [
            ...
        ]

- build

      ./apollo.sh build_dbg

- replace `__EXEC_ROOT__` in `compile_commands.json` 

      execroot=$(bazel info execution_root)
      sed -i "s@__EXEC_ROOT__@${execroot}@" ${execroot}/bazel-out/k8-dbg/bin/modules/planning/compile_commands.json
      sed -i "s@__EXEC_ROOT__@${execroot}@" ${execroot}/bazel-out/k8-dbg/bin/cyber/mainboard/compile_commands.json

- create file .clangd

      If:
        PathMatch: cyber/.*
      
      CompileFlags:
        CompilationDatabase: /apollo/.cache/bazel/540135163923dd7d5820f3ee4b306b32/execroot/apollo/bazel-out/k8-dbg/bin/cyber/mainboard
      
      ---
      
      If:
        PathMatch: modules/planning/.*
      
      CompileFlags:
        CompilationDatabase: /apollo/.cache/bazel/540135163923dd7d5820f3ee4b306b32/execroot/apollo/bazel-out/k8-dbg/bin/modules/planning
 

