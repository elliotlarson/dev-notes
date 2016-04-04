# Awk Notes

## Resources

* http://www.thegeekstuff.com/2010/01/awk-introduction-tutorial-7-awk-print-examples/
* http://www.ibm.com/developerworks/library/l-awk1/
* http://www.thegeekstuff.com/2010/01/8-powerful-awk-built-in-variables-fs-ofs-rs-ors-nr-nf-filename-fnr/

#### pull out the columns 3 and 4

    $ ls -l | awk '{print $3, $4}'

#### print out matching column

    $ ls -l | awk '{if ($3 == "rahmu") print $0;}'

#### print out ls -l lines that start with config

    $ ls -l | awk '$9 ~ /^config/ {print $0;}'
