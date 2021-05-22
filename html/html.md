# HTML

- [HTML](#html)
  - [The HTML `<head>` Element](#the-html-head-element)
  - [The HTML `<title>` Element](#the-html-title-element)
  - [HTML `<link>` Tag](#html-link-tag)
  - [HTML `<style>` Tag](#html-style-tag)
  - [HTML `<script>` Tag](#html-script-tag)
  - [HTML `<div>` Tag](#html-div-tag)
  - [HTML `<img>` Tag](#html-img-tag)
  - [HTML `<a>` Tag](#html-a-tag)
  - [HTML `<ul>` Tag](#html-ul-tag)
  - [HTML `<li>` Tag](#html-li-tag)
  - [HTML `<button>` Tag](#html-button-tag)
  - [HTML `<form>` Tag](#html-form-tag)
  - [HTML `<label>` Tag](#html-label-tag)
  - [HTML `<input>` Tag](#html-input-tag)
  - [HTML `<textarea>` Tag](#html-textarea-tag)
  - [HTML `<select>` Tag](#html-select-tag)
  - [HTML `<option>` Tag](#html-option-tag)

## [The HTML `<head>` Element](https://www.w3schools.com/html/html_head.asp)

- containes metadata, which is note displayed

  - `<title>`

  - `<style>`

  - `<meta>`

  - `<link>`

  - `<script>`

  - `<base>`

- placed between the `<html>` tag and the `<body>` tag

## The HTML `<title>` Element

- defines a title in the browser toolbar
- provides a title for the page when it is added to favorites
- displays a title for the page in search engine-results

## [HTML `<link>` Tag](https://www.w3schools.com/tags/tag_link.asp)

Example: Link to an external style sheet:

    <head>
      <link rel="stylesheet" href="styles.css">
    </head>

Definition and Usage:

- The `<link>` tag defines the relationship between the current document and an external resource.

- The `<link>` tag is most often used to link to external style sheets.

- The `<link>` element is an empty element, it contains attributes only.

## [HTML `<style>` Tag](https://www.w3schools.com/tags/tag_style.asp)

Definition and Usage:

- The `<style>` tag is used to define style information (CSS) for a document

- Inside the `<style>` element you specify how HTML elements should render in a browser

Note:

- When a browser reads a style sheet, it will format the HTML document according to the information in the style sheet. If some properties have been defined for the same selector (element) in different style sheets, the value from the last read style sheet will be used

Tip:

- To link to an external style sheet, use the [`<link>`](https://www.w3schools.com/tags/tag_link.asp) tag.

- To learn more about style sheets, please read our [CSS Tutorial](https://www.w3schools.com/css/default.asp).

## [HTML `<script>` Tag](https://www.w3schools.com/tags/tag_script.asp)

Definition and Usage:

- The `<script>` tag is used to embed a client-side script (JavaScript).

- The `<script>` element either contains scripting statements, or it points to an external script file through the `src` attribute.

- Common uses for JavaScript are image manipulation, form validation, and dynamic changes of content.

Note:

There are several ways an external script can be executed

- If `async="async"`: The script is executed asynchronously with the rest of the page (the script will be executed while the page continues the parsing)

- If `async` is not present and `defer="defer"`: The script is executed when the page has finished parsing

- If neither `async` or `defer` is present: The script is fetched and executed immediately, before the browser continues parsing the page

Tip:

- Also look at the [`<noscript>`](https://www.w3schools.com/tags/tag_noscript.asp) element for users that have disabled scripts in their browser, or have a browser that doesn't support client-side scripting.

## [HTML `<div>` Tag](https://www.w3schools.com/tags/tag_div.ASP)

Definition and Usage:

- The `<div>` tag defines a division or a section in an HTML document.

- The `<div>` tag is used as a container for HTML elements - which is then styled with CSS or manipulated with JavaScript.

- The `<div>` tag is easily styled by using the class or id attribute.

- Any sort of content can be put inside the `<div>` tag

- By default, browsers always place a line break before and after the `<div>` element

## [HTML `<img>` Tag](https://www.w3schools.com/tags/tag_img.asp)

Definition and Usage:

The `<img>` tag is used to embed an image in an HTML page.

Images are not technically inserted into a web page; images are linked to web pages. The `<img>` tag creates a holding space for the referenced image.

The `<img>` tag has two required attributes:

- `src` - Specifies the path to the image
- `alt` - Specifies an alternate text for the image, if the image for some reason cannot be displayed

Note:

- Also, always specify the width and height of an image. If width and height are not specified, the page might flicker while the image loads.

Tip:

- To link an image to another document, simply nest the `<img>` tag inside an [`<a>`](https://www.w3schools.com/tags/tag_a.asp) tag

## [HTML `<a>` Tag](https://www.w3schools.com/tags/tag_a.asp)

Example

Create a link to W3Schools.com:

    <a href="https://www.w3schools.com">Visit W3Schools.com!</a>

Definition and Usage

- The `<a>` tag defines a hyperlink, which is used to link from one page to another.

The most important attribute of the `<a>` element is the `href` attribute, which indicates the link's destination.

By default, links will appear as follows in all browsers:

- An unvisited link is underlined and blue
- A visited link is underlined and purple
- An active link is underlined and red

Tip:

- If the `<a>` tag has no href attribute, it is only a placeholder for a hyperlink

- A linked page is normally displayed in the current browser window, unless you specify another target

- Use CSS to style links: [CSS Links](https://www.w3schools.com/css/css_link.asp) and [CSS Buttons](https://www.w3schools.com/css/css3_buttons.asp).

## [HTML `<ul>` Tag](https://www.w3schools.com/tags/tag_ul.asp)

Example

An unordered HTML list:

    <ul>
      <li>Coffee</li>
      <li>Tea</li>
      <li>Milk</li>
    </ul>

Definition and Usage

The `<ul>` tag defines an unordered (bulleted) list.

Use the `<ul>` tag together with the [`<li>`](https://www.w3schools.com/tags/tag_li.asp) tag to create unordered lists.

Tip:

- Use CSS to [style lists](https://www.w3schools.com/css/css_list.asp)

- For ordered lists, use the [`<ol>`](https://www.w3schools.com/tags/tag_ol.asp) tag

## [HTML `<li>` Tag](https://www.w3schools.com/tags/tag_li.asp)

Example

One ordered (`<ol>`) and one unordered (`<ul>`) HTML list:

    <ol>
      <li>Coffee</li>
      <li>Tea</li>
      <li>Milk</li>
    </ol>
    
    <ul>
      <li>Coffee</li>
      <li>Tea</li>
      <li>Milk</li>
    </ul>

Definition and Usage:

- The `<li>` tag defines a list item.

- The `<li>` tag is used inside ordered lists([`<ol>`](https://www.w3schools.com/tags/tag_ol.asp)), unordered lists ([`<ul>`](https://www.w3schools.com/tags/tag_ul.asp)), and in menu lists ([`<menu>`](https://www.w3schools.com/tags/tag_menu.asp)).

- In `<ul>` and `<menu>`, the list items will usually be displayed with bullet points.

- In `<ol>`, the list items will usually be displayed with numbers or letters.

Tip:

- Use CSS to [style lists](https://www.w3schools.com/css/css_list.asp).

## [HTML `<button>` Tag](https://www.w3schools.com/tags/tag_button.asp)

Example

A clickable button is marked up as follows:

    <button type="button">Click Me!</button>

Definition and Usage

The `<button>` tag defines a clickable button.

Inside a `<button>` element you can put text (and tags like `<i>`, `<b>`, `<strong>`, `<br>`, `<img>`, etc.). That is not possible with a button created with the [`<input>`](https://www.w3schools.com/tags/tag_input.asp) element

Tip:

- Always specify the type attribute for a `<button>` element, to tell browsers what type of button it is

- You can easily style buttons with CSS! Look at the examples below or visit our [CSS Buttons](https://www.w3schools.com/css/css3_buttons.asp) tutorial.

## [HTML `<form>` Tag](https://www.w3schools.com/tags/tag_form.asp)

Example

An HTML form with two input fields and one submit button:

    <form action="/action_page.php" method="get">
      <label for="fname">First name:</label>
      <input type="text" id="fname" name="fname"><br><br>
      <label for="lname">Last name:</label>
      <input type="text" id="lname" name="lname"><br><br>
      <input type="submit" value="Submit">
    </form>

Definition and Usage

- The `<form>` tag is used to create an HTML form for user input.

- The `<form>` element can contain one or more of the following form elements:

  - [`<input>`](https://www.w3schools.com/tags/tag_input.asp)
  - [`<textarea>`](https://www.w3schools.com/tags/tag_textarea.asp)
  - [`<button>`](https://www.w3schools.com/tags/tag_button.asp)
  - [`<select>`](https://www.w3schools.com/tags/tag_select.asp)
  - [`<option>`](https://www.w3schools.com/tags/tag_option.asp)
  - [`<optgroup>`](https://www.w3schools.com/tags/tag_optgroup.asp)
  - [`<fieldset>`](https://www.w3schools.com/tags/tag_fieldset.asp)
  - [`<label>`](https://www.w3schools.com/tags/tag_label.asp)
  - [`<output>`](https://www.w3schools.com/tags/tag_output.asp)

## [HTML `<label>` Tag](https://www.w3schools.com/tags/tag_label.asp)

Example

Three radio buttons with labels:

    <form action="/action_page.php">
      <label for="male">Male</label>
      <input type="radio" name="gender" id="male" value="male"><br>
      <label for="female">Female</label>
      <input type="radio" name="gender" id="female" value="female"><br>
      <label for="other">Other</label>
      <input type="radio" name="gender" id="other" value="other"><br><br>
      <input type="submit" value="Submit">
    </form>

Definition and Usage

The `<label>` tag defines a label for several elements:

- `<input type="checkbox">`
- `<input type="color">`
- `<input type="date">`
- `<input type="datetime-local">`
- `<input type="email">`
- `<input type="file">`
- `<input type="month">`
- `<input type="number">`
- `<input type="password">`
- `<input type="radio">`
- `<input type="range">`
- `<input type="search">`
- `<input type="tel">`
- `<input type="text">`
- `<input type="time">`
- `<input type="url">`
- `<input type="week">`
- `<meter>`
- `<progress>`
- `<select>`
- `<textarea>`

Proper use of labels with the elements above will benefit:

- Screen reader users (will read out loud the label, when the user is focused on the element)

- Users who have difficulty clicking on very small regions (such as checkboxes) - because when a user clicks the text within the `<label>` element, it toggles the input (this increases the hit area).

Tip:

- The `for` attribute of `<label>` must be equal to the `id` attribute of the related element to bind them together. A label can also be bound to an element by placing the element inside the `<label>` element.

## [HTML `<input>` Tag](https://www.w3schools.com/tags/tag_input.asp)

Example

An HTML form with three input fields; two text fields and one submit button:

    <form action="/action_page.php">
      <label for="fname">First name:</label>
      <input type="text" id="fname" name="fname"><br><br>
      <label for="lname">Last name:</label>
      <input type="text" id="lname" name="lname"><br><br>
      <input type="submit" value="Submit">
    </form>

Definition and Usage

- The `<input>` tag specifies an input field where the user can enter data.

- The `<input>` element is the most important form element.

- The `<input>` element can be displayed in several ways, depending on the type attribute.

The different input types are as follows:

- `<input type="button">`
- `<input type="checkbox">`
- `<input type="color">`
- `<input type="date">`
- `<input type="datetime-local">`
- `<input type="email">`
- `<input type="file">`
- `<input type="hidden">`
- `<input type="image">`
- `<input type="month">`
- `<input type="number">`
- `<input type="password">`
- `<input type="radio">`
- `<input type="range">`
- `<input type="reset">`
- `<input type="search">`
- `<input type="submit">`
- `<input type="tel">`
- `<input type="text"> (default value)`
- `<input type="time">`
- `<input type="url">`
- `<input type="week">`

Look at the type attribute to see examples for each input type!

Tip:

- Always use the `<label>` tag to define labels for `<input type="text">`, `<input type="checkbox">`, `<input type="radio">`, `<input type="file">`, and `<input type="password">`.

## [HTML `<textarea>` Tag](https://www.w3schools.com/tags/tag_textarea.asp)

Example

A multi-line text input control (text area):

    <label for="w3review">Review of W3Schools:</label>
    <textarea id="w3review" name="w3review" rows="4" cols="50">
    At w3schools.com you will learn how to make a website. They offer free tutorials in all web development technologies.
    </textarea>

Definition and Usage

- The `<textarea>` tag defines a multi-line text input control.

- The `<textarea>` element is often used in a form, to collect user inputs like comments or reviews.

- A text area can hold an unlimited number of characters, and the text renders in a fixed-width font (usually Courier).

- The size of a text area is specified by the `<cols>` and `<rows>` attributes (or with CSS).

- The `name` attribute is needed to reference the form data after the form is submitted (if you omit the name attribute, no data from the text area will be submitted).

- The `id` attribute is needed to associate the text area with a `label`.

Tip:

- Always add the `<label>` tag for best accessibility practices

## [HTML `<select>` Tag](https://www.w3schools.com/tags/tag_select.asp)

Example

Create a drop-down list with four options:

    <label for="cars">Choose a car:</label>
    
    <select name="cars" id="cars">
      <option value="volvo">Volvo</option>
      <option value="saab">Saab</option>
      <option value="mercedes">Mercedes</option>
      <option value="audi">Audi</option>
    </select>

Definition and Usage

- The `<select>` element is used to create a drop-down list.

- The `<select>` element is most often used in a form, to collect user input.

- The `name` attribute is needed to reference the form data after the form is submitted (if you omit the name attribute, no data from the drop-down list will be submitted).

- The `id` attribute is needed to associate the drop-down list with a label.

- The [`<option>`](https://www.w3schools.com/tags/tag_option.asp) tags inside the `<select>` element define the available options in the drop-down list.

Tip:

- Always add the `<label>` tag for best accessibility practices

## [HTML `<option>` Tag](https://www.w3schools.com/tags/tag_option.asp)

Example
A drop-down list with four options:

    <label for="cars">Choose a car:</label>
    
    <select id="cars">
      <option value="volvo">Volvo</option>
      <option value="saab">Saab</option>
      <option value="opel">Opel</option>
      <option value="audi">Audi</option>
    </select>

Definition and Usage

- The `<option>` tag defines an option in a select list.

- `<option>` elements go inside a [`<select>`](https://www.w3schools.com/tags/tag_select.asp), [`<optgroup>`](https://www.w3schools.com/tags/tag_optgroup.asp), or [`<datalist>`](https://www.w3schools.com/tags/tag_datalist.asp) element.

Note:

- The `<option>` tag can be used without any attributes, but you usually need the `value` attribute, which indicates what is sent to the server on form submission.

Tip:

- If you have a long list of options, you can group related options within the `<optgroup>` tag.




