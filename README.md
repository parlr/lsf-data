# LSF data [![Build Status](https://travis-ci.org/parlr/lsf-data.svg?branch=master)](https://travis-ci.org/parlr/lsf-data)

> Vidéos et dictionnaire associés pour apprendre le vocabulaire LSF (Langue des Signes Française)

### Usage

    make split-video

### Test

**requirements:** [`bats`](https://github.com/bats-core/bats-core/).

    make test

### Install

**:warning: warning**: contains video files.

    git clone --recursive git@github.com:parlr/lsf-data.git
    cd lsf-data
    make install

### Source de données

- [LSF @ Éducation Nationale](http://lsf.education.fr/index.php?page=recherche_alphabetique)
- Apprendre 300 mots du quotidien en LSF [partie 1](https://www.youtube.com/watch?v=rz3jw0_XXoc) et [partie 2](https://www.youtube.com/watch?v=DbTKAbY-i0A) par L. Jauvert
