# [Intro-to-Vue-3](https://github.com/Code-Pop/Intro-to-Vue-3)

- [Intro-to-Vue-3](#intro-to-vue-3)
  - [Lessons-1 Intro to Vue 3](#lessons-1-intro-to-vue-3)
  - [Lessons-2 Creating the Vue App](#lessons-2-creating-the-vue-app)
    - [`createApp`](#createapp)
    - [`data`](#data)
    - [Mounting App Instance](#mounting-app-instance)
  - [Lessons-3 Attribute Binding](#lessons-3-attribute-binding)
    - [`v-bind`](#v-bind)
    - [`v-bind` shorthand: `:`](#v-bind-shorthand-)
  - [Lessons-4 Conditional Rendering](#lessons-4-conditional-rendering)
    - [`v-if` / `v-else`](#v-if--v-else)
    - [`v-show`](#v-show)
  - [Lessons-5 List Rendering](#lessons-5-list-rendering)
    - [`v-for`](#v-for)
  - [Lessons-6 Event Handling](#lessons-6-event-handling)
    - [`v-on`](#v-on)
      - [`v-on` shorthand: `@`](#v-on-shorthand-)
    - [`methods`](#methods)
  - [Lessons-7 Class & Style Binding](#lessons-7-class--style-binding)
    - [show variant colors using style binding](#show-variant-colors-using-style-binding)
    - [make the button disable whenever `inStock` is `false`](#make-the-button-disable-whenever-instock-is-false)
    - [use class binding to add a disabled butten class](#use-class-binding-to-add-a-disabled-butten-class)
  - [Lessons-8 Computed Properties](#lessons-8-computed-properties)
    - [`computed`](#computed)
    - [update `image` & `inStock` using computed properties](#update-image--instock-using-computed-properties)
  - [Lessons-9 Components & Props](#lessons-9-components--props)
    - [Components Basics](#components-basics)
  - [Lessons-10 Communicating Events](#lessons-10-communicating-events)
    - [emit event from `product-display` componet](#emit-event-from-product-display-componet)
    - [Custom Events](#custom-events)
  - [Lessons-10 Forms & v-model](#lessons-10-forms--v-model)
    - [`v-model`](#v-model)

[Video](https://www.vuemastery.com/courses/intro-to-vue-3/creating-the-vue-app-vue3)

## Lessons-1 Intro to Vue 3

## Lessons-2 Creating the Vue App

### [`createApp`](https://v3.vuejs.org/api/global-api.html#createapp)

Returns an application instance which provides an application context. The entire component tree mounted by the application instance share the same context.

    const app = createApp({})

You can chain other methods after `createApp`, they can be found in [Application API](https://v3.vuejs.org/api/application-api.html)

Arguments:

The function receives a root component options object as a first parameter:

js

    const app = createApp({
      data() {
        return {
          ...
        }
      },
      methods: {...},
      computed: {...}
      ...
    })

With the second parameter, we can pass root props to the application:

js

    const app = createApp(
      {
        props: ['username']
      },
      { username: 'Evan' }
    )

html

    <div id="app">
      <!-- Will display 'Evan' -->
      {{ username }}
    </div>

### [`data`](https://v3.vuejs.org/api/options-data.html#data-2)

- Type: `Function`

- Details:

  The function that returns a data object for the component instance

### [Mounting App Instance](https://v3.vuejs.org/guide/migration/global-api.html#vue-prototype-replaced-by-config-globalproperties)

After being initialized with `createApp(/* options */)`, the app instance `app` can be used to mount a root component instance with `app.mount(domTarget)`:

    import { createApp } from 'vue'
    import MyApp from './MyApp.vue'
    
    const app = createApp(MyApp)
    app.mount('#app')

## Lessons-3 Attribute Binding

### `v-bind`

- [Class and Style Bindings](https://v3.vuejs.org/guide/class-and-style.html#binding-html-classes)

### `v-bind` shorthand: `:`

## Lessons-4 Conditional Rendering

### `v-if` / `v-else`

- demo 1

      <p v-if="inStock">In Stock</p>
      <p v-else>Out of Stock</p>

- demo 2

      <p v-if="inventory > 10">In Stock</p>
      <p v-else-if="inventory <= 10 && inventory > 0">Almost sold out</p>
      <p v-else>Out of Stock</p

### `v-show`

    <p v-show="inStock">In Stock</p>

- Toggling element's visibility

## Lessons-5 List Rendering

desplay list

### `v-for`

    <li v-for="detail in details">{{ detail }}</li>

give each DOM element a key

    <li v-for="variant in variants" :key="variant.id">{{ variant.color }}</li>

    <li v-for="(size, index) in sizes" :key="index">{{ size }}</li>

## Lessons-6 Event Handling

listen for events on an element

### `v-on`

    <button class="button" v-on:click="cart += 1">Add to Cart</button>

or

    <button class="button" v-on:click="addToCart">Add to Cart</button>

with js

    methods: {
        addToCart() {
            this.cart += 1
        }
    }

#### `v-on` shorthand: `@`

`@mouseover`

    <div v-for="variant in variants" :key="variant.id" @mouseover=updateImage(variant.image)>{{ variant.color }}</div>

with js

        updateImage(variantImage) {
            this.image = variantImage
        }

### [`methods`](https://v3.vuejs.org/api/options-data.html#methods)

Type: `{ [key: string]: Function }`

Details:

Methods to be mixed into the component instance. You can access these methods directly on the VM instance, or use them in directive expressions. All methods will have their `this` context automatically bound to the component instance.

Note

Note that you should not use an arrow function to define a method (e.g. `plus: () => this.a++)`. The reason is arrow functions bind the parent context, so this will not be the component instance as you expect and this.a will be undefined.

Example:

    const app = createApp({
      data() {
        return { a: 1 }
      },
      methods: {
        plus() {
          this.a++
        }
      }
    })
    
    const vm = app.mount('#app')
    
    vm.plus()
    console.log(vm.a) // => 2

See also: [Event Handling](https://v3.vuejs.org/guide/events.html)

## Lessons-7 Class & Style Binding

### show variant colors using style binding

use the color name to set the background color of div

    <div 
      v-for="variant in variants" 
      :key="variant.id" 
      @mouseover="updateImage(variant.image)" 
      class="color-circle"
      :style="{ backgroundColor: variant.color }">
    </div>

with js

    variants: [
      { id: 2234, color: 'green', image: './assets/images/socks_green.jpg' },
      { id: 2235, color: 'blue', image: './assets/images/socks_blue.jpg' },
    ]

### make the button disable whenever `inStock` is `false`

    <button
      class="button"
      :disabled="!inStock"
      @click="addToCart">
      Add to Cart
    </button>

### use class binding to add a disabled butten class

    <button
      class="button"
      :class="{ disabledButton: !inStock }"
      :disabled="!inStock"
      @click="addToCart">
      Add to Cart
    </button

with css

    .disabledButton {
      background-color: #d8d8d8;
      cursor: not-allowed;
    }

## Lessons-8 Computed Properties

### [`computed`](https://v3.vuejs.org/api/options-data.html#computed)

Type: `{ [key: string]: Function | { get: Function, set: Function } }`

Details:

Computed properties to be mixed into the component instance. All getters and setters have their `this` context automatically bound to the component instance.

Note that if you use an arrow function with a computed property, `this` won't be the component's instance, but you can still access the instance as the function's first argument:

    computed: {
      aDouble: vm => vm.a * 2
    }

Computed properties are **cached**, and only re-computed on reactive dependency changes. Note that if a certain dependency is out of the instance's scope (i.e. not reactive), the computed property will **not** be updated.

Example:

    const app = createApp({
      data() {
        return { a: 1 }
      },
      computed: {
        // get only
        aDouble() {
          return this.a * 2
        },
        // both get and set
        aPlus: {
          get() {
            return this.a + 1
          },
          set(v) {
            this.a = v - 1
          }
        }
      }
    })
    
    const vm = app.mount('#app')
    console.log(vm.aPlus) // => 2
    vm.aPlus = 3
    console.log(vm.a) // => 2
    console.log(vm.aDouble) // => 4

See also: [Computed Properties](https://v3.vuejs.org/guide/computed.html)

### update `image` & `inStock` using computed properties

    <div id="app">
      <div class="nav-bar"></div>

      <div class="cart">Cart({{ cart }})</div>
      
      <div class="product-display">
        <div class="product-container">
          <div class="product-image">
            <img v-bind:src="image">
          </div>
          <div class="product-info">
            <h1>{{ title }}</h1>
            <p v-if="inStock">In Stock</p>
            <p v-else>Out of Stock</p>
            <ul>
              <li v-for="detail in details">{{ detail }}</li>
            </ul>

            <div 
              class="color-circle" 
              v-for="(variant, index) in variants" 
              :key="variant.id" 
              @mouseover="updateVariant(index)" 
              :style="{ backgroundColor: variant.color }"></div>
            <button class="button" :class="{ disabledButton: !inStock }" :disabled="!inStock" v-on:click="addToCart">Add to Cart</button>
          </div>
        </div>
      </div>
    </div>

with js

    const app = Vue.createApp({
        data() {
            return {
                cart:0,
                product: 'Socks',
                brand: 'Vue Mastery',
                selectedVariant: 0,
                details: ['50% cotton', '30% wool', '20% polyester'],
                variants: [
                { id: 2234, color: 'green', image: './assets/images/socks_green.jpg', quantity: 50 },
                { id: 2235, color: 'blue', image: './assets/images/socks_blue.jpg', quantity: 0 },
                ]
            }
        },
        methods: {
            addToCart() {
                this.cart += 1
            },
            updateVariant(index) {
                this.selectedVariant =index 
            }
        },
        computed: {
            title() {
                return this.brand + ' ' + this.product
            },
            image() {
                return this.variants[this.selectedVariant].image
            },
            inStock() {
                return this.variants[this.selectedVariant].quantity
            }
        }
    })

## Lessons-9 Components & Props

Components: Building blocks of a Vue app

Props: A custom attribute for passing data into a component

### [Components Basics](https://v3.vuejs.org/guide/component-basics.html)

## Lessons-10 Communicating Events

### emit event from `product-display` componet

index.html

    <product-display :premium="premium" @add-to-cart="updateCart"></product-display>

ProductDisplay.js

    app.component('product-display', {
    ...
        methods: {
            addToCart() {
                this.$emit('add-to-cart')
            },
            updateVariant(index) {
                this.selectedVariant = index
            }
        }
    }

main.js

    const app = Vue.createApp({
        data() {
            return {
                cart: 0,
                premium: true
            }
        },
        methods: {
            updateCart() {
                this.cart += 1
            }
        }
    })

### [Custom Events](https://v3.vuejs.org/guide/component-custom-events.html)

## Lessons-10 Forms & v-model

### `v-model`

2-way binding




