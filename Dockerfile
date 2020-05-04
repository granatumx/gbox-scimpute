FROM r-base:3.4.3

WORKDIR /usr/src/app

RUN apt-get update -y \
      && apt-get install -y python3 python3-pip

COPY ./python_requirements.txt .
RUN pip3 install --trusted-host pypi.python.org -r python_requirements.txt

COPY ./install_R_packages_from_CRAN.R .
RUN Rscript ./install_R_packages_from_CRAN.R \
       foreach \
       Matrix \
       parallel \
       stats \
       utils \
       glmnet

COPY ./update_biocLite.R .
RUN Rscript ./update_biocLite.R

COPY ./additional_requirements.txt .
RUN pip3 install --trusted-host pypi.python.org -r additional_requirements.txt

COPY . .

# Set version correctly so user can install gbox
# Requires bash and sed to set version in yamls
# Can modify if base OS does not support bash/sed
RUN apt-get update
RUN apt-get install -y sed bash
ARG VER=1.0.0
ARG GBOX=gbox:1.0.0
ENV VER=$VER
ENV GBOX=$GBOX
WORKDIR /usr/src/app
RUN ./GBOXtranslateVERinYAMLS.sh
RUN ./GBOXgenTGZ.sh

CMD ["python3", "greet.py"]

