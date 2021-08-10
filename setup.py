from setuptools import setup

setup(
    name='project-name',  # TODO: replace
    version='0.0.1',
    url='https://your.git.forge/USERNAME/project-name',  # TODO: replace
    author='Full Name',  # TODO: replace
    author_email='login@example.com',  # TODO: replace
    description="TODO",  # TODO: replace
    packages=[
        'project_name',  # TODO: replace
    ],
    install_requires=[],  # TODO: specify python dependencies
    entry_points={
        'console_scripts': [
            'project-name = project_name.main:main',  # TODO: rename
        ],
    },
)
