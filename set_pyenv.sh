#!/bin/bash
source /root/.bashrc

pyenv install 3.4.3 && pyenv global 3.4.3

pip install -r /tmp/requirements.txt
pip install https://github.com/amigcamel/Jseg/archive/jseg3.zip
