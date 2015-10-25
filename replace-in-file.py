#!/usr/bin/python

from __future__ import print_function
import sys, argparse, fileinput


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Simple find and replace string in a file.")
    parser.add_argument("-p", "--path", help="file", required=True)
    parser.add_argument("-fs", "--find_str", help="string to find", required=True)
    parser.add_argument("-rs", "--replace_str", help="replace with", required=True)
    args = parser.parse_args()


for line in fileinput.FileInput(args.path,inplace=1):
   line = line.replace(args.find_str,args.replace_str)
   print (line, end="");


