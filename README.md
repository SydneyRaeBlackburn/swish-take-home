# Swish Take Home

## Build
```bash
$ docker build -t swish .
```

## Run

Run `Python2.7`, `Python3.13`, or `Rscript` in an iteractive shell:
```
$ docker run -it swish /bin/bash

# python2.7
>>>
# python2.7 <script>

# python3.13
>>>
# python3.13 <script>

# Rscript <script>
```

Run scripts from `Docker` command:
```
$ docker run swish python2.7 <script>

$ docker run swish python3.13 <script>

$ docker run swish Rscript <script>
```