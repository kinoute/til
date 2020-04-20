# The Safe Navigation Operator (&.) 

An interesting addition to Ruby 2.3 was the "Safe Navigation Operator (`&.`)".
It helps us to deal with `nil` values in a chaining condition. Let's say we have an
`order` made by a `customer` and we want to get the customer's `id`. To be
safe, we could do:

```ruby
if order && order.customer && order.customer.id
...
end
```

But this is too much verbose. We can rewrite the previous condition like:

```ruby
order&.customer&.id
```

What it does is, it either returns the `id` of the customer if it exists, either `nil` if one value in the chain is `nil`.

This is useful especially in Rails. For example, in Rails, when you generate a
scaffold, it generates a partial view `_form` for both the `new` and the `edit`
actions. They both use the same form.

If you want to add a dropdown menu to your form to let a user change the
customer of an order nicely, you can make the dropdown menu load with the `customer` selected already in the list:

```ruby
<%= f.select :customer_id, options_for_select(@customers, order.customer.id) %>
```

It will work for the `edit` action but what about the `new` action when you try
to create a new order? It will throw an error since for a new order, you don't
have any customer attached to it yet.

This is where the Safe Navigation Operator is handy. With it, we will avoid an
error in this scenario:

```ruby
<%= f.select :customer_id, options_for_select(@customers, order&.customer&.id) %>
```

Now, when creating a `new` order, since there is no customer linked to
this order yet, the condition will return `nil` and no customer will be
selected in the dropdown menu, avoiding an error.


