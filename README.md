kimsin
======

A simple logging app turned into a gem, to eliminate the need to code it every time at the beginning of a new sinatra project.

As it is so simple and effective, I ported <a href="http://railscasts.com/episodes/250-authentication-from-scratch">Ryan Bates' "Authentication from scratch"</a> to sinatra (since I prefer to use Sinatra for simpler apps).

Just like above, <a href="http://bcrypt.sourceforge.net/">bcrypt</a> and <a href="http://bcrypt-ruby.rubyforge.org/">bcrypt-ruby</a> is used for encryption.

Therefore password security is left to SSL. 

Tested using minitest and minitest-capybara.

======

TODO:

Reset password functionality
Email password functionality
