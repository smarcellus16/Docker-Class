FROM ubuntu:jammy as app

# ARG variables only persist during build time
ARG IQTREE_VER="2.2.0"
ARG MAFFT_VER="7.505"
ARG VCFTOOLS_VER="v0.1.16"
ARG RAXML_VER="8.2.12"
ARG FASTTREE_VER="2.1.10"
ARG AUGUR_VER="20.0.0"

#metadata labels

LABEL base.image="ubuntu:jammy"
LABEL dockerfile.version="1"
LABEL software="augur"
LABEL software.version="${AUGUR_VER}"
LABEL description="A bioinformatics toolkit for phylogentic analysis"
LABEL website="https://github.com/nextstrain/augur"
LABEL license="https://github.com/nextstrain/augur/blob/master/LICENSE.txt"
LABEL maintainer="Trevor Bedford"
LABEL maintainer.email="tb@bedford.io"

#install dependencies and clean up apt mess

RUN apt-get && apt-get install -y --no-install-recommends \
wget \
mafft \
iqtree \
raxml \
fasttree \
vcftools &&\
apt-get autoclean && rm -rf /var/lib/apt/lists**

#get augur 

RUN git clone git clone https://github.com/nextstrain/augur.git && \
python3 -m pip install .

mkdir /data

#set PATH 

ENV PATH="${PATH}:/augur-${AUGUR_VER}/bin"\
    LC_ALL=C.UTF-8

#test layer
FROM app as test 

#print version and run the supplied test flag
RUN augur --version && augur --test && augur --help

