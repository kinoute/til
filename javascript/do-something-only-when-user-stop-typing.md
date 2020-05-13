# Do something only when user stop typing 

Sometimes you want to update your views while a user is typing in a textbox.

For example, let's say we have a search form. We would like to show the results
not only after submitting the form by clicking on a button, but as soon as the
user is typing something in the search bar.

The problem is, if we use the naive approach by listening on the `keyup` or
`keydown` event, we will basically send an AJAX request every time the user is
typing something in the text input. This could lead to many problems:

* First, we will flood the server with many useless requests per second ;
* Secondly, because we're sending many requests, it could lead to a weird
    behavior where results from a request will be first displayed then a previous
    request that just finished will update the results again. Making the
    results hard to understand as it will not reflect the query.

To avoid this problem, **we should make sure to only send the search query when
the user has stopped typing.**

Fortunately, with the help of `setTimeout` and `clearTimeout`, we can fix that:

```javascript
// Find the input text box
let search_input = document.getElementById('search-input');

// timeout variable
let timeout = null;

// Listen for keystroke events
search_input.addEventListener('keyup', function (e) {
    // Clear the timeout if it has already been set.
    // This will prevent the previous task from executing
    // if it has been less than <MILLISECONDS>
    clearTimeout(timeout);

    // Make a new timeout set to go off in 1000ms (1 second)
    timeout = setTimeout(function () {
        // Submit the AJAX form in Ruby on Rails
        document.querySelector('form').dispatchEvent(new Event('submit', {bubbles: true}));
        }, 1000);
});
```

That way, we only trigger the submission of our form when the user has stopped
typing for at least 1 second.

**Source:** https://schier.co/blog/wait-for-user-to-stop-typing-using-javascript
