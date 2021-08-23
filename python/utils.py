#!/usr/bin/env python
# -*- coding: utf-8 -*-
import commands
import datetime
import os
import re
import subprocess
import sys
from functools import wraps


def LogEerrorMessage():
    def wrap(func):
        @wraps(func)
        def LogError(*arg, **kwarg):
            try:
                func(*arg, **kwarg)
            except Exception as e:
                print "function:{0}_______ErrorMessage:{1}".format(func.__name__, e)

        return LogError

    return wrap


def ShellRun(cmd, description="run shell", errorCheck=True):
    staus,output = commands.getstatusoutput(cmd)
    if len(output)<0:
        raise Exception(cmd)
    if staus !=0 :
        print "it failed to run shell command {0} .. {1}".format(description,cmd)
        if errorCheck:
            raise Exception(cmd)
    return output

def ShellRunWithLog(cmd,description="run shell",errorCheck=True):
    popen = subprocess.Popen(cmd, stdin=subprocess.PIPE, stderr=sys.stderr, stdout=sys.stdout, shell=True,
                             universal_newlines=True, bufsize=1024 * 1024 * 1024)
    popen.communicate()
    ret = popen.returncode
    if ret !=0:
        print "it failed to run shell commond:{}".format(description)
        if errorCheck:
            raise ShellRun(cmd)
    return ret

def LogTime():
    def wrap(func):
        @wraps(func)
        def ConutTime(*arg,**kwargs):
            try:
                startTime = datetime.datetime.now()
                ret = func(*arg,**kwargs)
                endTime =datetime.datetime.now()
                delta = (endTime - startTime).seconds
                seconds = delta % 60
                minutes = delta /60
                cost_time = '{} minutes {} seconds'.format(minutes,seconds)
                print "**************************************************************"
                print "function:{} cost_time: {}".format(function.__name__,cost_time)
                print "**************************************************************"
            except Exception as e:
                print "function:{} _______messageError: {}".format(func.__name__,e)
            return ret
        return ConutTime
    return wrap

def Search_File(filename,path):
    if not os.path.isdir(path):
        print "directory {} does not exist".format(path)
    returnFileList = []
    for root,_,files in os.walk(path):
        for name in files:
            if filename == name:
                returnFileList.append(os.path.join(root,name))
    return returnFileList
def IndistictSearchFile(regex,path):
    if not os.path.isdir(path):
        print "directory {} does not exist".format(path)
    returnFileList = []
    for root,_,files in os.walk(path):
        for name in files:
            if re.findall(regex,name):
                returnFileList.append(os.path.join(root,name))
    return returnFileList



