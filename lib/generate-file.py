#! /usr/bin/env python3
#
# Generate a file using a Jinja2 template and one or more YAML data files.

import argparse
import os
import sys
import yaml
from jinja2 import Environment, FileSystemLoader

def main():
    parser = argparse.ArgumentParser(description='Print text generated from a Jinja2 template and one or more YAML data files.')
    parser.add_argument(
        '--data',
        help='one or more YAML files containing data to be used in the template',
        action='append',
        required=True)
    parser.add_argument('template', help='the Jinja2 template file')
    args = parser.parse_args()

    # Load the template.
    env = Environment(loader=FileSystemLoader(os.path.dirname(args.template)))
    template = env.get_template(os.path.basename(args.template))

    # Load the data files.
    data = {}
    for data_file in args.data:
        with open(data_file, 'r') as f:
            data.update(yaml.load(f, Loader=yaml.Loader))

    # Render the template.
    output = template.render(data)

    # Write the output.
    sys.stdout.write(output)

if __name__ == '__main__':
    main()