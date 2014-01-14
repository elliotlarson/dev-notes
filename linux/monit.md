# Monit Notes

## Resources

* https://www.digitalocean.com/community/articles/how-to-install-and-configure-monit

## Configuration

#### issuing monit commands

In order to issue commands with Monit, you need to have the http server component configured (oddly).

	set httpd port 2812 and
		use address localhost
		allow localhost

#### configuring thin

    check process thin
	    matching "thin server"
	    start program = "/bin/su - deployer -c '/etc/init.d/thin start'"
	    stop program = "/bin/su - deployer -c '/etc/init.d/thin stop'"
	    if 3 restarts within 5 cycles then timeout
	    if totalmem is greater than 150.0 MB for 2 cycles then restart
	    if cpu is greater than 80% for 2 cycles then restart
	    group thin

or

    check process thin with pidfile /home/deployer/apps/acadia/shared/pids/thin.3000.pid
        start program = "/bin/su - deployer -c '/etc/init.d/thin start'"
        stop program = "/bin/su - deployer -c '/etc/init.d/thin stop'"
        if 3 restarts within 5 cycles then timeout
        if totalmem is greater than 150.0 MB for 2 cycles then restart
        if cpu is greater than 80% for 2 cycles then restart
        group thin


#### configuring Gmail mail server

I can't get this to work, though.  I think it has something to do with hostnames and DNS records.

    set mailserver smtp.gmail.com port 587
        username "someuser@gmail.com" password "password"
        using tlsv1
        with timeout 30 seconds
