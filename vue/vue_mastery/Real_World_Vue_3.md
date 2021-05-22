# [Real World Vue 3](https://www.vuemastery.com/courses/real-world-vue3/rwv3-orientation/)

- [Real World Vue 3](#real-world-vue-3)
  - [Lessons-1 Orientation](#lessons-1-orientation)
  - [Lessons-2 Vue CLI - Creating the Project](#lessons-2-vue-cli---creating-the-project)
    - [install vul cli](#install-vul-cli)
    - [create project named "real-world-vue"](#create-project-named-real-world-vue)
    - [run project](#run-project)
    - [project tour](#project-tour)

## Lessons-1 Orientation

## Lessons-2 Vue CLI - Creating the Project

### install vul cli

    npm install -g @vue/cli

or

    yarn global add @vue/cli

### create project named "real-world-vue"

    vue create real-world-vue

### run project

    cd real-world-vue
    npm run serve

### project tour

- `node_modules`

  libraries we need to build

- `public`

  static assets you don’t want to be run through Webpack when the project is built

- `src`
  
  application code.

  - `assets`

    images and fonts

  - `components`

    components, or building blocks

  - `router`

    used for Vue Router

  - `store`

    Vuex code

  - `views`

    store component files for the different views of our app, which Vue Router loads up.

  - `App.vue`

    - the root component that all other components are nested within

  - main.js

    - renders `App.vue` component (and everything nested within it) and mounts it to the DOM





