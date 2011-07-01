#!/usr/bin/env python
######################
#
# Base try out fro python code - read json file and do print
#
######################
# Contact:
#   vincent@wiredcraft.com
######################

import sys, os
import getopt

try:
    import simplejson
except ImportError:
    print "Can not import simplejson"
    sys.exit(1)

# --
# __init__
def __init__(self, argv):
    self.argv = argv
    # set the default values, maybe superseded by command line options
    # self.update(self.DEFAULT_CONF)
    # get command line configuration options
    self.getopt()

def usage(self, arg):
	"""docstring for usage"""
	pass


# --
# getopt
# > argv
# < conf
def getopt(self):
    # get command line options
    try:
        (opts, args) = getopt.getopt(self.argv, 'hc:j:')
    except getopt.GetoptError, e:
        raise OptError(e.msg)
  
    for (opt, val) in opts:
        if opt == '-f':
            self['follow'] = True
        elif opt == '-h':
            usage()
            sys.exit(0)
        if opt == '-i':
            self['iformat'] = val
        if opt == '-o':
            self['oformat'] = val
        if opt == '-r':
            self['follow_rst'] = True
        else:
            # this should never happen, getopt() should catch all the
            # errors
            pass
    # check if a file name was provided
    if len(args) == 0:
        usage()
        sys.exit(1)

    # check the existence of all the command line files
    for file in args[1:]:
        if not os.path.exists(file):
            raise FileError('cannot access %s: No such file or directory' % file)
    self['files'] = args



