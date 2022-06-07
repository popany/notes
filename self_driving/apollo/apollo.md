# apollo

- [apollo](#apollo)
  - [repo](#repo)
  - [docs](#docs)
    - [quickstart](#quickstart)
    - [technical_tutorial](#technical_tutorial)
    - [specs](#specs)
    - [howto](#howto)
    - [technical_documents](#technical_documents)

## repo

[github](https://github.com/ApolloAuto/apollo)

## docs

### quickstart

docs/quickstart/apollo_software_installation_guide_cn.md

- 配置环境变量 `APOLLO_ROOT_DIR`

      echo "export APOLLO_ROOT_DIR=$(pwd)" >> ~/.bashrc  && source ~/.bashrc

- 启动容器

      bash docker/scripts/dev_start.sh

- 进入容器

      bash docker/scripts/dev_into.sh

- 构建整个 Apollo 工程

      ./apollo.sh build

  或

      ./apollo.sh build_opt

  构建参考: docs/specs/apollo_build_and_test_explained.md

- 启动并运行 Apollo

  docs/howto/how_to_launch_and_run_apollo.md

### technical_tutorial

docs/technical_tutorial/apollo_best_coding_practice_cn.md

### specs

docs/specs/apollo_build_and_test_explained.md

- build planning

  bash apollo.sh build planning

  bash apollo.sh build_opt planning

  bash apollo.sh build_dbg planning

  bash apollo.sh test planning















docs/specs/bazel_in_apollo_an_overview.md

docs/specs/Class_Architecture_Planning_cn.md

docs/specs/coordination_cn.md

docs/specs/Open_Space_Planner.md

docs/specs/qp_spline_path_optimizer_cn.md

docs/specs/qp_spline_st_speed_optimizer_cn.md

docs/specs/reference_line_smoother_cn.md

### howto

docs/howto/how_to_launch_and_run_apollo.md

### technical_documents

docs/technical_documents/open_space_decider.md

docs/technical_documents/open_space_trajectory_optimizer_en.md

docs/technical_documents/open_space_trajectory_partition.md

docs/technical_documents/open_space_trajectory_provider_en.md

docs/technical_documents/planning_component.md

docs/technical_documents/planning_piecewise_jerk_nonlinear_speed_optimizer.md

docs/technical_documents/planning_speed_bounds_decider.md




