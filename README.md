# chillman
simple dampening library for node.js that makes sure that multiple successive calls to resolve a resource waits after the first, so that the resource is only resolved once per resource resolving storm.

The use case is where you have an expensive function, that takes some time and resolves a resource for you, and when you get it back you put it in a cach, of course. So that the next orderly request doens't have to go all the way over the network again.

The problem is that when you retsrat your service, you'll get a gazillion calls to the function - all of which happens too quickly for your cache to be filled.

What Chillman does is to remember what you asked for in the first fucntion call for that whatever it is, and to paus all subsequent calls for that same resource. When the very first call gets resolved, the other following calls will be continued, so a gazillion calls will only result in one resource utilization.

See tests for example. Promises are used heavillt and Chillman depends on that the resource-fullfillment function anse return a promise.
