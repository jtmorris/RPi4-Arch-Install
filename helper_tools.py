########################################################################
# Author	:	John Morris
# Website	:	https://github.com/jtmorris
# Source	:	https://github.com/jtmorris/RPi4-Arch-Install
########################################################################

import subprocess
import sys

def sh_command_wrapper(*args, print_output: bool=True):
	pr = subprocess.Popen(args, stdout=subprocess.PIPE,
		stderr=subprocess.PIPE, shell=True)
	o = get_output_from_sh_command(pr)

	if print_output:
		print(o)

	return o

def get_output_from_sh_command(popen_obj):
	(stdout, stderr) = popen_obj.communicate()
	return stdout.decode('utf-8') + stderr.decode('utf-8')


def confirmation_query(question, default="yes"):
	"""Ask a yes/no question via raw_input() and return their answer.

	"question" is a string that is presented to the user.
	"default" is the presumed answer if the user just hits <Enter>.
		It must be "yes" (the default), "no" or None (meaning
		an answer is required of the user).

	The "answer" return value is True for "yes" or False for "no".
	"""
	valid = {"yes": True, "y": True, "ye": True,
			"no": False, "n": False}
	if default is None:
		prompt = " [y/n] "
	elif default == "yes":
		prompt = " [Y/n] "
	elif default == "no":
		prompt = " [y/N] "
	else:
		raise ValueError("invalid default answer: '%s'" % default)

	while True:
		sys.stdout.write(question + prompt)
		choice = input().lower()
		if default is not None and choice == '':
			return valid[default]
		elif choice in valid:
			return valid[choice]
		else:
			sys.stdout.write("Please respond with 'yes' or 'no' "
						"(or 'y' or 'n').\n")