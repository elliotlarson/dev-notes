# Grep Notes

## Resources

* **grep regular expressions:** http://www.cyberciti.biz/faq/grep-regular-expressions/

## Commands

#### grep a tail of a log:

    $ tail -n 1000 -f training.log | grep --line-buffered 'Started'

