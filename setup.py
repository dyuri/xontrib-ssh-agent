from setuptools import setup

try:
    with open('README.md') as fh:
        LONG_DESC = fh.read()
except (IOError, OSError):
    LONG_DESC = ''

setup(
    name="xontrib-ssh-agent",
    version='1.0.13',
    url='https://github.com/dyuri/xontrib-ssh-agent',
    license='MIT',
    author='Gyuri Horák',
    author_email='dyuri@horak.hu',
    description='SSH agent integration for xonsh',
    install_requires=[
        'repassh>=1.2.0',
    ],
    long_description=LONG_DESC,
    long_description_content_type='text/markdown',
    packages=['xontrib'],
    package_dir={'xontrib': 'xontrib'},
    package_data={'xontrib': ['*.xsh']},
    platforms='any',
    data_files=[("", ["LICENSE.txt"])],
    classifiers=[
        'Environment :: Console',
        'Intended Audience :: End Users/Desktop',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 3',
        'Topic :: Desktop Environment',
        'Topic :: System :: Shells',
        'Topic :: System :: System Shells',
    ]
)
