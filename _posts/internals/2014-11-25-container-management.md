---
title: Container Management
modified_at: 2014-11-25 00:00:00
category: internals
tags: internals, containers,
---

# Containers management

## Shutdown

Whether you are deploying a new version of your app or for any operation which
involves container stopping (stop, restart, downscale, deployment).

We have adopted a standard process:

1. Send SIGTERM to the process
2. Wait 10 seconds
3. Send SIGKILL if the process is still alive

### What does it assume?

To ensure a graceful shutdown, you should catch __SIGTERM__ signal and
cleanly shutdown your process.

### Example

{% highlight go %}
listener, err := net.Listen("tcp", ":"+port)
if err != nil {
  panic(err)
}

go http.Serve(listener, m)

sigs := make(chan os.Signal)
signal.Notify(sigs, syscall.SIGTERM)
<-sigs
fmt.Println("SIGTERM, time to shutdown")
listener.Close()
{% endhighlight %}
