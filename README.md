# Swish Take Home
Houses all the necessary files, configuration, and dependencies needed to run `Python2`, `Python3`, and `R` in a single container. The image is automatically built and pushed to Dockerhub on main branch pushes.

## Image Details
**Image Name:** `sblackburn10/sblackburn:swish`

**Build time:** 3m56s

**Image size:** 391.44 MB

**1219 vulnerabilities found in 29 packages:**
| Severity | Amount |
| :------- | :----- |
| CRITICAL |    1   |    
|  HIGH    |   12   |
|  MEDIUM  |  1159  |
|  LOW     |   47   |


## Local Build
```bash
$ docker build -t swish .
```

## Kubernetes Deployment
- Pull image from Dockerhub: `docker pull sblackburn10/sblackburn:swish`
- Apply: `kubectl apply -f deployment.yaml`

## Local Run
Run `Python2.7`, `Python3.13`, or `Rscript` in an iteractive shell:
```
$ docker run -it swish /bin/bash

# python2.7
>>>
# python2.7 <script>

# python3.13
>>>
# python3.13 <script>

# R
>
# Rscript <script>
```

Run scripts from `Docker` command:
```
$ docker run swish python2.7 <script>

$ docker run swish python3.13 <script>

$ docker run swish Rscript <script>
```

## Requirements Directory
Holds the lists of dependencies for `Python2`, `Python3`, and `R`.

- `r-requirements-bins.txt` - pre-compiled R packages for faster builds
- `r-requirements.R` - any other packages that are not available as a binary package