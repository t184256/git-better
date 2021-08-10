# SPDX-FileCopyrightText: 2021 git-better authors (see AUTHORS)
# SPDX-License-Identifier: License: GPL-3.0-or-later

from setuptools import setup

setup(
    name='git-better',
    version='0.0.1',
    url='https://github.com/t184256/git-better',
    author='Alexander Sosedkin',
    author_email='monk@unboiled.info',
    description="A set of opinionated git wrappers",
    packages=[
        'git_better',
    ],
    install_requires=['GitPython'],
    entry_points={
        'console_scripts': [
            'git-better = git_better.main:main',
        ],
    },
)
