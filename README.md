# LSF data

> Vocabulaire LSF (Langue des Signes Française)

### Source de données

* [LSF @ Éducation Nationale](http://lsf.education.fr/index.php?page=recherche_alphabetique)
* Apprendre 300 mots du quotidien en LSF [partie 1](https://www.youtube.com/watch?v=rz3jw0_XXoc) et [partie 2](https://www.youtube.com/watch?v=DbTKAbY-i0A) par L. Jauvert

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
